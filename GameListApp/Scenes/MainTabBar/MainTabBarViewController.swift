//
//  MainTabBarViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    private let homeViewController = UINavigationController(rootViewController:
                                                                HomeViewController(HomeViewModel(GameService())))
    private let favoritesViewController = UINavigationController(rootViewController:
                                           FavoritesViewController(FavoritesViewModel(CoreDataFavoriteHelper())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
// MARK: - UI Configure
    private func configure() {
        homeViewController.tabBarItem.image = UIImage(systemName: "gamecontroller.fill")
        favoritesViewController.tabBarItem.image = UIImage(systemName: "heart.fill")
        
        homeViewController.title = "Home"
        favoritesViewController.title = "Favorites"
        
        tabBar.tintColor = .red
        tabBar.backgroundColor = .systemBackground
        setViewControllers([homeViewController, favoritesViewController], animated: true)
    }
}
