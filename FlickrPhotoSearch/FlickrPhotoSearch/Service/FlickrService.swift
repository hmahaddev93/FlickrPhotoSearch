//
//  FlickrService.swift
//  FlickrPhotoSearch
//
//  Created by Khateeb H. on 12/13/21.
//

import Foundation

enum SortByMode: CaseIterable, Codable {
    case datePostedAsc, datePostedDesc, dateTakenAsc, dateTakenDesc, interestingnessDesc, interestingnessAsc, relevance
    var key: String {
        switch self {
        case .datePostedAsc:
            return "date-posted-asc"
        case .datePostedDesc:
            return "date-posted-desc"
        case .dateTakenAsc:
            return "date-taken-asc"
        case .dateTakenDesc:
            return "date-taken-desc"
        case .interestingnessDesc:
            return "interestingness-desc"
        case .interestingnessAsc:
            return "interestingness-asc"
        case .relevance:
            return "relevance"
        }
    }
    
    var title: String {
        switch self {
        case .datePostedAsc:
            return "Date posted ascending"
        case .datePostedDesc:
            return "Date posted descending"
        case .dateTakenAsc:
            return "Date taken ascending"
        case .dateTakenDesc:
            return "Date taken descending"
        case .interestingnessDesc:
            return "Interestingness descending"
        case .interestingnessAsc:
            return "Interestingness ascending"
        case .relevance:
            return "Relevance"
        }
    }
}

struct SearchTerm: Codable {
    let keyword: String?
    var perPage: Int
    var sort: SortByMode
}

enum FlickrAPI  {
    static let host: String = "flickr.com"
    static let path: String = "/services/rest/"
    static let apiKey: String = "1508443e49213ff84d566777dc211f2a"
    enum Methods {
        static let search = "flickr.photos.search"
    }
}

protocol Flickr_Service_Protocol {
    func searchPhoto(with term: SearchTerm, completion: @escaping (Result<[FlickrPhoto], Error>) -> Void)
}

final class FlickrService: Flickr_Service_Protocol {
    
    private let httpClient: HTTPClient
    private let jsonDecoder: JSONDecoder
    
    enum ContactServiceError: Error {
        case invalidData
    }
    
    init(httpClient: HTTPClient = HTTPClient.shared) {
        self.httpClient = httpClient
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
    }
    
    struct FlickrResponseBody: Codable {
        let photos: FlickrPhotosBody
    }
    
    struct FlickrPhotosBody: Codable {
        let photo: [FlickrPhoto]
    }
    
    func searchPhoto(with term: SearchTerm, completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = FlickrAPI.host
        urlComponents.path = FlickrAPI.path

        let methodQuery = URLQueryItem(name: "method", value: FlickrAPI.Methods.search)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: FlickrAPI.apiKey)
        let jsonFormatQuery = URLQueryItem(name: "format", value: "json")
        let noJsonCallbackQuery = URLQueryItem(name: "nojsoncallback", value: "1")
        let perPageQuery = URLQueryItem(name: "per_page", value: "\(term.perPage)")
        let sortQuery = URLQueryItem(name: "sort", value: term.sort.key)

        urlComponents.queryItems = [methodQuery, apiKeyQuery, jsonFormatQuery, noJsonCallbackQuery, perPageQuery, sortQuery]
        
        if let keyword = term.keyword, keyword != ""{
            let keywordQuery = URLQueryItem(name: "text", value: keyword)
            urlComponents.queryItems?.append(keywordQuery)
        }
        
        httpClient.get(url: urlComponents.url!) { result in
            switch result {
            case .success(let data):
                completion(Result(catching: { try self.jsonDecoder.decode(FlickrResponseBody.self, from: data).photos.photo }))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}


