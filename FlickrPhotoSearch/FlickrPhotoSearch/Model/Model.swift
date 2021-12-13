//
//  Model.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import Foundation

struct FlickrPhoto: Codable {
    let title: String
    let id: String
    let server: String
    let secret: String
    
    var thumbUrl: URL {
        return URL(string: String(format: "https://live.staticflickr.com/%@/%@_%@_t.jpg", server, id, secret))!
    }
    
    var fullSizeUrl: URL {
        return URL(string: String(format: "https://live.staticflickr.com/%@/%@_%@_b.jpg", server, id, secret))!
    }
}
