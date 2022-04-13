//
//  AppDelegate.swift
//  My Contact List
//
//  Created by E Roche on 3/30/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //get a reference to the standard UserDefaults object
        let settings = UserDefaults.standard
        
        //check whether a value is already stored with two specific keys in the settings object
        //checks if the sortField has been set. if not, store City as the value in sortField
        if settings.string(forKey: Constants.kSortField) == nil {
            settings.set("City", forKey: Constants.kSortField)
        }
        //repeats the same check for the sort direction. If no value is stored, it defaults to true
        if settings.string(forKey: Constants.kSortDirectionAscending) == nil {
            settings.set(true, forKey: Constants.kSortDirectionAscending)
        }
        //ensures that any changes are saved back to the settings file, and write the values of the two settings fields to NSLog.
        //This shows how to retrieve a Boolean value using the bool(:ForKey:) method and retrieve a string by using string(:ForKey:).
        settings.synchronize()
        //print("Sort field: \(settings.string(forKey: Constants.kSortField)!)")
        //print("Sort direction: \(settings.bool(forKey: Constants.kSortDirectionAscending))")
        
        NSLog("Sort field: %@", settings.string(forKey: Constants.kSortField)!)
        NSLog("Sort direction: \(settings.bool(forKey: Constants.kSortDirectionAscending))")

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    //MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = { //a wrapper around the actual data store - creates and returns container with loaded store for the app
        let container = NSPersistentContainer(name: "MyContactListModel") //the container contains the name of the Core Data datamodel
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            //replace with appropriate error handling code
                //fatalError generates a crash log and terminates app
                //for development only - replace for a shipped version of app
                fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
        return container
    } ()
    
    //MARK: - Core Data Saving Support
    
    func saveContext () { //called whenever data changes need to be saved to the persistent container
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
    
    
}

