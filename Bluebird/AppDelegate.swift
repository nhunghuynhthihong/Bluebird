//
//  AppDelegate.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/20/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set color for Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 31.0/255.0, green:
            134.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName:UIColor.whiteColor(),
                 NSFontAttributeName:barFont]
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if User.currentUser != nil {
            print("There is a current user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
            window?.rootViewController = vc
        }
        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(url.description)
        
        TwitterClient.sharedInstance.handleOpenUrl(url)
        return true
    }

}

