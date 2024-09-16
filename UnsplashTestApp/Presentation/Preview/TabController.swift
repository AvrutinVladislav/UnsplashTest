//
//  ViewController.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 13.09.2024.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .green
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .gray
    }

}

extension TabController {
    func setupTabs() {
        let collectionOfImages = self.setupNavigationController(title: "Collection", image: UIImage(systemName: "checklist.unchecked"), vc: RandomPhotosViewController())
        let favoriteImages = self.setupNavigationController(title: "Favorite", image: UIImage(systemName: "heart"), vc: FavoritesViewController())
        self.setViewControllers([collectionOfImages, favoriteImages], animated: true)
    }
    
    func setupNavigationController(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title + " images"
        return nav
    }
}
