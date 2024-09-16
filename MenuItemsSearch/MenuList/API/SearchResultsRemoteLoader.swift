//
//  SearchResultsRemoteLoader.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-11.
//

import Foundation

protocol SearchResultsLoader {
    typealias Result = Swift.Result<[MenuModel], Error>
    
    func fetchSearchResults(withSearchTerm searchText: String, completion: @escaping (Result) -> Void)
}

struct SearchResultsRemoteLoader: SearchResultsLoader {
        
    private let client: URLSessionHTTPClient
        
    init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    func fetchSearchResults(withSearchTerm searchText: String, completion: @escaping (SearchResultsLoader.Result) -> Void) {
        
        /*Getting sample from bundle but ideally we would get from url*/
        let url = Bundle.main.url(forResource: "menu", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            completion(SearchResultsRemoteLoader.map(data, from: response))
        } catch {
            completion(.failure(Error.connectivity))
        }
        
    
       /* let urlString = "http://anyURL.com"
        let url = URL(string: urlString)!
        
        client.get(from: url) { result in
            switch result {
            case .success(let (data, response)):
                completion(SearchResultsRemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        } */

    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> SearchResultsLoader.Result {
        guard response.statusCode == 200 else {
            return .failure(Error.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let items = try decoder.decode([MenuModel].self, from: data)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
    
    enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
}

