//
//  AppDelegate.swift
//  youbaku2
//
//  Created by ULAKBIM on 22/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    let googleMapsApiKey = "AIzaSyBpJzv9i8YfYd_-B47uHEMH04wQhNErCyI"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 2
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Selected)
        
        return true
    }

}

