//
//  PhotoCell.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var photo: FlickrPhoto! {
        didSet {
            titleLabel.text = photo.title
            thumbImageView.loadURLImage(url: photo.thumbUrl)
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
