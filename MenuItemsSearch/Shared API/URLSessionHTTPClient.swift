//
//  URLSessionHTTPClient.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-13.
//

import Foundation


protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse, let data {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentationError()))
            }
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
    
    struct UnexpectedValuesRepresentationError: Error {}
}

