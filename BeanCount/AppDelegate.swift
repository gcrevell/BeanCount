//
//  AppDelegate.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/14/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

enum Theme: Int {
    case None = 0
    case iDTC = 1
    case iDPA = 2
    case iDGA = 3
    case iDAlexa = 4
    case iDMini = 5
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var selectedTheme: Theme?
    var currentLocation: CLLocationCoordinate2D?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        let defaults = UserDefaults()
        selectedTheme = Theme(rawValue: defaults.integer(forKey: "THEME"))
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func myThemeColor() -> UIColor {
        if let theme = selectedTheme {
            switch theme {
            case .iDPA:
                return UIColor(red: 13/255, green: 94/255, blue: 181/255, alpha: 1)
                
            case .iDGA:
                return UIColor(red: 212/255, green: 36/255, blue: 54/255, alpha: 1)
                
            case .iDAlexa:
                return UIColor(red: 23/255, green: 132/255, blue: 171/255, alpha: 1)
                
            case .iDMini:
                return UIColor(red: 247/255, green: 117/255, blue: 33/255, alpha: 1)
                
            default:
                return UIColor(red: 150/255, green: 211/255, blue: 41/255, alpha: 1)
            }
        }
        return UIColor(red: 150/255, green: 211/255, blue: 41/255, alpha: 1)
    }
    
}


