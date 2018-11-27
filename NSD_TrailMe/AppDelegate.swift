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
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
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
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, _) in
                
            }
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error{
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        return true
    }
    
   
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let followerId = userInfo["followerId"] as? String {
            let storyboard = UIStoryboard(name: "Alternate", bundle: nil)
            if let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as?
                ProfileViewController
            {
                profileViewController.id = followerId
                if let mainTabBarController = window?.rootViewController as? TabBarController {
                    mainTabBarController.selectedIndex = 0
                    if let homeNavController = mainTabBarController.viewControllers?.first as? UINavigationController {
                        homeNavController.pushViewController(profileViewController, animated: true)
                    }
                }
            }
        }
    }
   
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       CoreDataStack.saveContext()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.saveContext()
    }

}

