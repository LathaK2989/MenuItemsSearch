//
//  ReceiperSearchViewController.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-09.
//

import UIKit

class MenuListViewController: UITableViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView?
    
    private var loadingControllers = [IndexPath: MenuCellController]()
    
    var onFavoritesSelected: ((MenuCellController) -> Void)?
    
    var viewModel: MenuListViewModel?
    
    var tableModel = [MenuCellController]() {
        didSet { 
            loadingControllers = [:]
            tableView.reloadData()
        }
    }
        
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: .main), forCellReuseIdentifier: "MenuTableViewCell")
        tableView.prefetchDataSource = self
        
        viewModel?.onLoadingStateChange = { _ in }
        viewModel?.onLoadingFailed = { _ in }
    }
}

extension MenuListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        viewModel?.updateSearchText(text)
    }
}

extension MenuListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.resetSearchResults()
    }
}

extension MenuListViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Add to favorite") { [weak self] action, view, completionHandler in
            self?.addToFavorites(withItemAtIndex: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func addToFavorites(withItemAtIndex index: Int) {
        let cellController = tableModel[index]
        onFavoritesSelected?(cellController)
    }
}

extension MenuListViewController: UITableViewDataSourcePrefetching {
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
