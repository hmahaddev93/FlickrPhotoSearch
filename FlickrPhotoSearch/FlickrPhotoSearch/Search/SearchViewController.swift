//
//  ViewController.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

final class SearchViewController: UIViewController {

    private static let photoCellIdentifier = "PhotoCell"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    private let alertPresenter = AlertPresenter()
    private let modalPresenter = ModalPresenter()
    private let viewModel = SearchViewModel(searchTerm: SearchTerm(keyword: nil, perPage: 25, sort: .dateTakenAsc))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        update(searchTerm: viewModel.searchTerm)
    }
    
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 100, height: 144)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: type(of: self).photoCellIdentifier)
        
        spinner.hidesWhenStopped = true
    }
    
    private func update(searchTerm: SearchTerm) {
        viewModel.searchTerm = searchTerm
        viewModel.saveSearchTerm()
        searchBar.text = viewModel.searchTerm.keyword
        
        guard let keyword = viewModel.searchTerm.keyword,
              keyword != ""
        else { return }
        
        showSpinner()
        viewModel.searchPhoto { [unowned self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.alertPresenter.present(from: self,
                                           title: "Unexpected Error",
                                           message: "\(error)",
                                           dismissButtonTitle: "OK")
                }
            }
        }
    }
    
    private func showSpinner() {
        spinner.startAnimating()
        collectionView.isHidden = true
    }
    
    private func hideSpinner() {
        spinner.stopAnimating()
        collectionView.isHidden = false
    }
    
    @IBAction func onTapFilterButton(_ sender: Any) {
        modalPresenter.presentFilter(from: self, searchTerm: viewModel.searchTerm, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.update(searchTerm: SearchTerm(keyword: searchBar.text, perPage: viewModel.searchTerm.perPage, sort: viewModel.searchTerm.sort))
    }
}

extension SearchViewController: SearchFilterViewControllerDelegate {
    func didFilterChanged(term: SearchTerm) {
        self.update(searchTerm: term)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: self).photoCellIdentifier, for: indexPath) as? PhotoCell {
            cell.photo = viewModel.photos[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
        modalPresenter.presentFullPhoto(from: self, photo: viewModel.photos[indexPath.row], animated: true)
        
    }
}




