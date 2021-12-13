//
//  ModalPresenter.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

protocol ModalPresenter_Proto {
    func present(from: UIViewController, destination: UIViewController, animated: Bool)
    func dismiss(from: UIViewController, animated: Bool)
    func presentFilter(from: UIViewController, searchTerm: SearchTerm, animated: Bool)
    func presentFullPhoto(from: UIViewController, photo: FlickrPhoto, animated: Bool)
}

class ModalPresenter: ModalPresenter_Proto {
    func dismiss(from: UIViewController, animated: Bool) {
        from.dismiss(animated: true)
    }
    
    func present(from: UIViewController, destination: UIViewController, animated: Bool) {
        from.present(destination, animated: true)
    }
    
    func presentFilter(from: UIViewController, searchTerm: SearchTerm, animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchFilterViewController") as! SearchFilterViewController
        vc.searchTerm = searchTerm

        if let from = from as? SearchFilterViewControllerDelegate {
            vc.delegate = from
        }
        present(from: from, destination: vc, animated: true)
    }
    
    func presentFullPhoto(from: UIViewController, photo: FlickrPhoto, animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FullPhotoViewController") as! FullPhotoViewController
        vc.photo = photo
        present(from: from, destination: vc, animated: true)
    }
}

