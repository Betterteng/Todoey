//
//  AppDelegate.swift
//  Todoey
//
//  Created by 滕施男 on 26/3/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        // To check the file path of the Realm file of this application...
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Error unwraping the fileURL with [Realm file]")
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing Realm: \(error)")
        }
        
        return true
    }
}
