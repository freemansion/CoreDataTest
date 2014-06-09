//
//  AppDelegate.swift
//  CoreDataTest
//
//  Created by VLADIMIR KONEV on 09.06.14.
//  Copyright (c) 2014 Novilab Mobile. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        let manager = CSDataManager.sharedInstance()
        println("context: \(manager.managedContext)")
        return true
    }
}

