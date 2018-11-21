//
//  TabBarController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let activityController = ActivityController()
            let activityNavController = UINavigationController(rootViewController: activityController)
            present(activityNavController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let signInController = LoginViewController()
                let navController = UINavigationController(rootViewController: signInController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        view.backgroundColor = backColor
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let homeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = UINavigationController(rootViewController: homeController)
        homeController.tabBarItem = UITabBarItem(title: "Feed", image:  UIImage(named: "home"), tag: 0)
        
        let historyController = HistoryController()
        let historyNavController = UINavigationController(rootViewController: historyController)
        historyNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        let activityController = ActivityController()
        let activityNavController = UINavigationController(rootViewController: activityController)
        activityNavController.tabBarItem = UITabBarItem(title: "Start", image: UIImage(named: "stopwatch"), tag: 2)
        
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        
        let moreController = MoreController()
        let moreNavController = UINavigationController(rootViewController: moreController)
        moreNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 4)
        
        viewControllers = [homeNavController, historyNavController, activityNavController, searchNavController, moreNavController]
        
        self.selectedIndex = 0
    }
}
