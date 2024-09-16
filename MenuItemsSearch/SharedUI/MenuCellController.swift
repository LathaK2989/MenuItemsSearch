//
//  ReceipeSearchCellController.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-11.
//

import UIKit

class MenuCellController {
    private let viewModel: MenuViewModel
    private var cell: MenuTableViewCell?

    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell
        cell?.receipeDescription.text = viewModel.description
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.recceipeImageView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.activityIndicator.startAnimating()
            } else {
                cell?.activityIndicator.stopAnimating()
            }
        }
        
        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }
        
        loadImageData()
        return cell!
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }
    
    private func releaseCellForReuse() {
        cell?.onReuse = nil
        cell = nil
    }
    
    func preload() {
        loadImageData()
    }
    
    private func loadImageData() {
        guard let isLoading = cell?.activityIndicator.isAnimating, !isLoading else { return }
        viewModel.loadImageData()
    }
}

