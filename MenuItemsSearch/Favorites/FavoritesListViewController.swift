//
//  FavoritesListViewController.swift
//  MenuItemsSearch
//
//  Created by Srilatha on 2024-09-15.
//

import UIKit

class FavoritesListViewController: UITableViewController {
        
    private var loadingControllers = [IndexPath: MenuCellController]()
    
    var tableModel = [MenuCellController]() {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: .main), forCellReuseIdentifier: "MenuTableViewCell")
    }
}

extension FavoritesListViewController : UITableViewDataSourcePrefetching {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).preload()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> MenuCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}
