//
//  MenuViewModel.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-13.
//

import UIKit

class MenuViewModel {
    private let model: MenuModel
    private let imageDataLoader: ImageDataLoader
    private var task: ImageDataLoaderTask?
    
    init(model: MenuModel, imageDataLoader: ImageDataLoader) {
        self.model = model
        self.imageDataLoader = imageDataLoader
    }
    
    var title: String {
        model.name
    }
    
    var description: String {
        model.description
    }
    
    var onImageLoad:((UIImage) -> Void)?
    var onImageLoadingStateChange: ((Bool) -> Void)?
    var onShouldRetryImageLoadStateChange: ((Bool) -> Void)?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        task = imageDataLoader.loadImageData(from: model.coverImgUrl, completion: {[weak self] result in
            self?.handle(result)
        })
    }
    
    private func handle(_ result: ImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
