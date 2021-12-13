//
//  SearchFilterViewController.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

protocol SearchFilterViewControllerDelegate: AnyObject {
    func didFilterChanged(term: SearchTerm)
}

final class SearchFilterViewController: UIViewController {

    @IBOutlet weak var perPageTextField: UITextField!
    @IBOutlet weak var sortByModeButton: UIButton!
    
    var searchTerm: SearchTerm!
    private let allTerms = SortByMode.allCases
    private let modalPresenter = ModalPresenter()
    var delegate: SearchFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        update()
    }
    
    private func setupView() {
        sortByModeButton.layer.borderColor = UIColor.black.cgColor
        sortByModeButton.layer.cornerRadius = 4
    }
    
    private func update() {
        perPageTextField.text = "\(searchTerm.perPage)"
        sortByModeButton.setTitle(searchTerm.sort.title, for: .normal)
    }
    
    private func presentSortModePicker() {
        let sortModePicker = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        for sortMode in allTerms {
            let pickAction = UIAlertAction(title: sortMode.title, style: .default) { action in
                guard let index = sortModePicker.actions.firstIndex(of: action) else {
                    return
                }
                self.searchTerm.sort = self.allTerms[index]
                self.update()
            }
            sortModePicker.addAction(pickAction)
        }
        
        self.present(sortModePicker, animated: true)
    }
    
    @IBAction func onTapSortByMode(_ sender: Any) {
        presentSortModePicker()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        view.endEditing(true)
        modalPresenter.dismiss(from: self, animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        view.endEditing(true)
        delegate?.didFilterChanged(term: SearchTerm(keyword: self.searchTerm.keyword, perPage: Int(perPageTextField.text!)!, sort: searchTerm.sort))
        modalPresenter.dismiss(from: self, animated: true)
    }
}
