//
//  MainQueueDispatchDecorator.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-13.
//

import Foundation

class MainQueueDispatchDecorator<T> {
    
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.sync(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: SearchResultsLoader where T == SearchResultsLoader {
    func fetchSearchResults(withSearchTerm searchText: String, completion: @escaping (Result<[MenuModel], Error>) -> Void) {
        decoratee.fetchSearchResults(withSearchTerm: searchText) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == ImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
        return task
    }
}
