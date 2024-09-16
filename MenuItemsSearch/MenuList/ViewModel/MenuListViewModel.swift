//
//  ReceipeSearchViewModel.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-09.
//

import Foundation

class MenuListViewModel {
    private let loader: SearchResultsLoader

    var onLoadSearchResults: (([MenuModel]) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    private var searchTimer: Timer?
    
    init(loader: SearchResultsLoader) {
        self.loader = loader
    }
    
    func updateSearchText(_ text: String) {
        searchTimer?.invalidate()
        
        guard text.count > 3 else {
            onLoadSearchResults?([])
            return
        }
        
        onLoadingStateChange?(true)
        searchTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
            self?.performSearch(text)
        })
    }
    
    func resetSearchResults() {
        searchTimer?.invalidate()
        onLoadSearchResults?([])
    }
    
    func addToFavorite() {
        
    }
    
    func performSearch(_ text: String) {
        loader.fetchSearchResults(withSearchTerm: text) { [weak self] result in
            self?.onLoadingStateChange?(false)
            switch result {
            case .success(let results):
                self?.onLoadSearchResults?(results)
            case .failure(let failure):
                self?.onLoadingFailed?(failure)
            }
        }
    }
}
