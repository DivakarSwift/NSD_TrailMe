//
//  AppDelegate.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/19/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        // Set appearance of Navigation and Tab Bars
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor.rgb(red: 0, green: 71, blue: 255)
        UITabBar.appearance().barTintColor = .white
        
        
        return true
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       CoreDataStack.saveContext()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.saveContext()
    }

}

