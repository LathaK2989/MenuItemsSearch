//
//  SceneDelegate.swift
//  MenuItemsSearch
//
//  Created by Srilatha on 2024-09-13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    func configureWindow() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("Cannot instantiate tab bar controller")
        }
        
        TabBarControllersUIComposer.composeViewControllers(in: tabBarController)
        
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarController
    }
}

