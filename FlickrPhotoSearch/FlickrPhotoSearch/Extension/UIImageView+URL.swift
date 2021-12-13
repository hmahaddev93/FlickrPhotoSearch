//
//  UIImageView+URL.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadURLImage(url: URL) {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        HTTPClient.shared.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                self.image = UIImage(data: data)
            case .failure(_):
                self.image = UIImage(systemName: "photo")
            }
        }
    }
}
