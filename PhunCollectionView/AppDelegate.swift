//
//  AppDelegate.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/22/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let cacheSizeMemory = 500*1024*1024; // 500 MB
        let cacheSizeDisk = 500*1024*1024; // 500 MB
        
        let sharedCache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        NSURLCache.setSharedURLCache(sharedCache)
        sleep(1); // Critically important line, sadly, but it's worth it!

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if url.host == nil
        {
            return true;
        }
        
        // Support Deeplink
        // Deeplink format is Deeplink://article/#indexnumber
        let urlString = url.absoluteString
        let queryArray = urlString.componentsSeparatedByString("/")
        let query = queryArray[2]
        
        // Check if article
        if query.rangeOfString("article") != nil
        {
            let data = urlString.componentsSeparatedByString("/")
            if data.count >= 3
            {
                let parameter = data[3]
                print(parameter);
                let navigationController = self.window?.rootViewController as? UINavigationController
                if let rootViewController = navigationController?.topViewController as? ViewController {
                    let idString = data[3] as NSString
                    let id = idString.integerValue
                    rootViewController.processDeeplink(id)
                }
            }
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
    
    func setupSpotlight() {
        
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let viewController = (window?.rootViewController as! UINavigationController).viewControllers[0] as! ViewController
        viewController.restoreUserActivityState(userActivity)
        
        return true
    }

}

