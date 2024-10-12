//
//  MainTabBarController.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    let watchlistViewModel = WatchlistViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let movieListVC = MovieListViewController(watchlistViewModel: watchlistViewModel)
        let watchlistVC = WatchlistViewController(watchlistViewModel: watchlistViewModel)

        movieListVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "star"), tag: 1)
        
        viewControllers = [UINavigationController(rootViewController: movieListVC), UINavigationController(rootViewController: watchlistVC)]
    }
}
