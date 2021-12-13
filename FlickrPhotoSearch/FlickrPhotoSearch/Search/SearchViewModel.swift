//
//  SearchViewModel.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import Foundation

final class SearchViewModel {
    var searchTerm: SearchTerm
    var photos = [FlickrPhoto]()
    
    init(searchTerm: SearchTerm) {
        self.searchTerm = searchTerm
        self.loadSavedSearchTerm()
    }
    
    func searchPhoto(completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        FlickrService().searchPhoto(with: self.searchTerm) { [unowned self] result in
            switch result {
            case .success(let photos):
                self.photos = photos
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveSearchTerm() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.searchTerm) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SearchTerm")
        }
    }
    
    func loadSavedSearchTerm() {
        let defaults = UserDefaults.standard
        if let savedTerm = defaults.object(forKey: "SearchTerm") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(SearchTerm.self, from: savedTerm) {
                self.searchTerm = loaded
            }
        }
    }
}
