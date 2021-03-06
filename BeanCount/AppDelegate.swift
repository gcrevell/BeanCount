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
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var loginToken: String? = nil
    
    private var _theme: Theme?
    var selectedTheme: Theme? {
        get {
            if _theme == nil {
                let defaults = UserDefaults()
                
                _theme = Theme(rawValue: defaults.integer(forKey: "THEME"))
            }
            
            return _theme
        }
        set (newTheme) {
            let defaults = UserDefaults()
            
            defaults.set(newTheme?.rawValue, forKey: "THEME")
            defaults.synchronize()
            
            _theme = newTheme
        }
    }
    
    var location: Location?
    var selectedLocation: Location? {
        get {
            
            return location
        }
        set (newLocation) {
            if newLocation != nil {
                let db = Database()
                db.updateLocation(forUserToken: loginToken!, withLocation: newLocation!, completionHandler: { (data, response, error) in
                    if data == nil {
                        // Unable to connect
                        print("There was a network connection while setting the users location.")
                        return
                    }
                    
                    let reply = String(data: data!, encoding: .utf8)
                    
                    if reply == "-1" {
                        // Incorrect password used
                        print("An incorrect (or no) password was used when updating the user's location.")
                    }
                    
                    if reply == "" {
                        // Unknown error with SQL statement
                        print("An unknown error occurred while setting the users location.")
                    }
                })
            }
            
            location = newLocation
        }
    }
    
    func set(location: Location?, completionHandler: @escaping (_ response: Int) -> Void) {
        self.location = location
        
        let db = Database()
        db.updateLocation(forUserToken: loginToken!, withLocation: location, completionHandler: { (data, response, error) in
            var value = -1
            
            if data == nil {
                // Network error
                value = -2
            } else {
                let reply = String(data: data!, encoding: .utf8)
                
                if reply == "-3" {
                    // Incorrect password
                    value = -3
                } else if reply == "" {
                    // SQL error
                    value = -4
                } else {
                    // yay! worked!
                    value = 0
                }
            }
            
            completionHandler(value)
        })
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //        FIRApp.configure()
        let defaults = UserDefaults()
        //        let db = FIRDatabase.database().reference()
        
        //        if let uid = defaults.string(forKey: "LOCATION_UID") {
        //            db.child("locations").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        //
        //                if snapshot.value == nil || snapshot.value is NSNull {
        //                    print("Could not find location in Firebase")
        //                    return
        //                }
        //
        //                let data = snapshot.value! as! [String : AnyObject]
        //                print("My location data: \(data)")
        //
        //                let latitude = data["latitude"] as! Double
        //                let longitude = data["longitude"] as! Double
        //                let name = data["locationName"] as! String
        //                let city = data["city"] as! String
        //                let state = data["state"] as! String
        //
        //                self.selectedLocation = Location(latitude: latitude,
        //                                                    longitude: longitude,
        //                                                    name: name,
        //                                                    UID: uid,
        //                                                    city: city,
        //                                                    state: state)
        //            })
        //        }
        
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
    
    // MARK: - Core Data iOS 10
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error._userInfo)")
            }
        })
        return container
    }()
    
    /*
     // MARK: - Core Data iOS 9
     
     lazy var applicationDocumentsDirectory: NSURL = {
     // The directory the application uses to store the Core Data store file. This code uses a directory named "Gabriel.Revells.CoreData9Test" in the application's documents Application Support directory.
     let urls = FileManager.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
     return urls[urls.count-1]
     }()
     
     lazy var managedObjectModel: NSManagedObjectModel = {
     // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
     let modelURL = Bundle.main.urlForResource("CoreData9Test", withExtension: "momd")!
     return NSManagedObjectModel(contentsOf: modelURL)!
     }()
     
     lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
     // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
     // Create the coordinator and store
     let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
     let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
     var failureReason = "There was an error creating or loading the application's saved data."
     do {
     try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
     } catch {
     // Report any error we got.
     var dict = [String: AnyObject]()
     dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
     dict[NSLocalizedFailureReasonErrorKey] = failureReason
     
     dict[NSUnderlyingErrorKey] = error as NSError
     let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
     // Replace this with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
     abort()
     }
     
     return coordinator
     }()
     
     lazy var managedObjectContext: NSManagedObjectContext = {
     // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
     let coordinator = self.persistentStoreCoordinator
     var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
     managedObjectContext.persistentStoreCoordinator = coordinator
     return managedObjectContext
     }()
     
     // MARK: - Core Data Saving support
     
     func saveContext () {
     if #available(iOS 10.0, *) {
     let context = persistentContainer.viewContext
     
     if context.hasChanges {
     do {
     try context.save()
     } catch {
     // Replace this implementation with code to handle the error appropriately.
     // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     let nserror = error as NSError
     fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
     }
     }
     } else {
     // Fallback on earlier versions
     if managedObjectContext.hasChanges {
     do {
     try managedObjectContext.save()
     } catch {
     // Replace this implementation with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     let nserror = error as NSError
     NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
     abort()
     }
     }
     }
     }
     */
    
    // MARK: - Global functions
    
    func myThemeColor() -> UIColor {
        if let theme = selectedTheme {
            switch theme {
            case .blue:
                return UIColor(red: 13/255, green: 94/255, blue: 181/255, alpha: 1)
                
            case .red:
                return UIColor(red: 212/255, green: 36/255, blue: 54/255, alpha: 1)
                
                //            case .lightBlue:
                //                return UIColor(red: 23/255, green: 132/255, blue: 171/255, alpha: 1)
                
            case .orange:
                return UIColor(red: 247/255, green: 117/255, blue: 33/255, alpha: 1)
                
            default:
                return UIColor(red: 150/255, green: 211/255, blue: 41/255, alpha: 1)
            }
        }
        return UIColor(red: 150/255, green: 211/255, blue: 41/255, alpha: 1)
    }
    
}


