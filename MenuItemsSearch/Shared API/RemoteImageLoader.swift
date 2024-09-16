//
//  RemoteImageLoader.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-13.
//

import UIKit

protocol ImageDataLoaderTask {
    func cancel()
}

protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}

class RemoteImageLoader: ImageDataLoader {
    private var completion: ((ImageDataLoader.Result) -> Void)?
    private let client: URLSessionHTTPClient
    
    private let imageCache = NSCache<NSURL, NSData>()
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private class HTTPClientTaskWrapper: ImageDataLoaderTask {
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
//        let nsURL = url as NSURL
//        
//        // 1. Check if image data is in the cache
//                if let cachedData = imageCache.object(forKey: nsURL) {
//                    completion(.success(cachedData as Data))
//                    return task
//                }
        
        task.wrapped = client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { (data, response) in
                    let isValidResponse = response.statusCode == 200 && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
            
//            // 3. Cache the downloaded data if successful
//            if case let .success(data) = mappedResult {
//                self.imageCache.setObject(data as NSData, forKey: nsURL)
//            }
        }
        return task

    }
}
