//
//  FullPhotoViewController.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

class FullPhotoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: FlickrPhoto!
    private let modalPresenter = ModalPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    private func update() {
        titleLabel.text = photo.title
        imageView.loadURLImage(url: photo.fullSizeUrl)
    }

    @IBAction func onClose(_ sender: Any) {
        modalPresenter.dismiss(from: self, animated: true)
    }
}
