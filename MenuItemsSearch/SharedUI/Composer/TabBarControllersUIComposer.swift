//
//  TabBarControllersUIComposer.swift
//  MenuItemsSearch
//
//  Created by Srilatha on 2024-09-15.
//

import UIKit

class TabBarControllersUIComposer {
    
    static func composeViewControllers(in tabBarController: UITabBarController) {
        guard let menuListNavController = tabBarController.viewControllers?[0] as? UINavigationController,
              let favoritesListNavController = tabBarController.viewControllers?[1] as? UINavigationController else {
            fatalError("Cannot get navigation controllers")
        }
        
        guard let menuListViewController = menuListNavController.topViewController as? MenuListViewController,
              let favoritesListViewController = favoritesListNavController.topViewController as? FavoritesListViewController else {
            fatalError("Cannot get root view controllers")
        }
        
        let menuListViewModel = MenuListViewModel(loader: MainQueueDispatchDecorator(decoratee: SearchResultsRemoteLoader(client: URLSessionHTTPClient())))
        menuListViewModel.onLoadSearchResults = adaptMenuToCellControllers(forwardingTo: menuListViewController, loader: RemoteImageLoader(client: URLSessionHTTPClient()))
        menuListViewController.viewModel = menuListViewModel
        menuListViewController.onFavoritesSelected = { cellController in
            favoritesListViewController.tableModel.append(cellController)
        }
        
    }
    
    private static func adaptMenuToCellControllers(forwardingTo controller: MenuListViewController, loader: ImageDataLoader) -> ([MenuModel]) -> Void {
        return { [weak controller] searchResults in
            let cellControllers = searchResults.map { searchResult in
                MenuCellController(viewModel: MenuViewModel(model: searchResult, imageDataLoader: MainQueueDispatchDecorator(decoratee: RemoteImageLoader(client: URLSessionHTTPClient())) ))
            }
            controller?.tableModel = cellControllers
        }
    }
   
}
