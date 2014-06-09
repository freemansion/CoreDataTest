//
//  CSDataManager.swift
//  CoreDataTest
//
//  Created by VLADIMIR KONEV on 09.06.14.
//  Copyright (c) 2014 Novilab Mobile. All rights reserved.
//

import UIKit
import Foundation
import CoreData

let kCSErrorDomain = "ru.novilab-mobile.cstest"
let kCSErrorLocalStorageCode = -1000

@objc(CSDataManager)
class CSDataManager:NSObject {
    //Managed Model
    var _managedModel: NSManagedObjectModel?
    var managedModel: NSManagedObjectModel{
        if !_managedModel{
            _managedModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        }
        return _managedModel!
    }
    
    //Store coordinator
    var _storeCoordinator: NSPersistentStoreCoordinator?
    var storeCoordinator: NSPersistentStoreCoordinator{
        if !_storeCoordinator{
            let _storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CSDataStorage.sqlite")
            _storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
            
            func addStore() -> NSError?{
                var result: NSError? = nil
                if _storeCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: _storeURL, options: nil, error: &result) == nil{
                    println("Create persistent store error occurred: \(result?.userInfo)")
                }
                return result
            }
            
            var error = addStore()
            if  error != nil{
                println("Store scheme error. Will remove store and try again. TODO: add scheme migration.")
                NSFileManager.defaultManager().removeItemAtURL(_storeURL, error: nil)
                error = addStore()
                
                if error{
                    println("Unresolved critical error with persistent store: \(error?.userInfo)")
                    abort()
                }
            }
        }
        return _storeCoordinator!
    }

    //Managed Context
    var _managedContext: NSManagedObjectContext? = nil
    var managedContext: NSManagedObjectContext {
        if !_managedContext {
            let coordinator = self.storeCoordinator
            if coordinator != nil {
                _managedContext = NSManagedObjectContext()
                _managedContext!.persistentStoreCoordinator = coordinator
            }
        }
        return _managedContext!
    }
    
    //Init
    init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    @objc(appDidEnterBackground)
    func appDidEnterBackground(){
        var (result:Bool, error:NSError?) = self.saveContext()
        if error != nil{
            println("Application did not save data with reason: \(error?.userInfo)")
        }
    }

    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }

    //Save context
    func saveContext() -> (Bool, NSError?){
        println("Will save")
        var error: NSError? = nil
        var result: Bool = false
        let context = self.managedContext
        if context != nil{
            if context.hasChanges && !context.save(&error){
                println("Save context error occurred: \(error?.userInfo)")
            }else{
                result = true
            }
        }else{
            let errorCode = kCSErrorLocalStorageCode
            let userInfo = [NSLocalizedDescriptionKey : "Managed context is nil"]
            error = NSError.errorWithDomain(kCSErrorDomain, code: errorCode, userInfo: userInfo)
        }
        return (result, error)
    }
    
    //Singleton Instance
    class func sharedInstance() -> CSDataManager{
        struct wrapper{
            static var shared_instance: CSDataManager? = nil
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&wrapper.token, {wrapper.shared_instance = CSDataManager()})
        return wrapper.shared_instance!
    }
    
    func departments()->NSArray{
        let request = NSFetchRequest(entityName: "CSDepartment")
        return self.managedContext.executeFetchRequest(request, error: nil)
    }
    
    func employees() -> NSArray{
        let request = NSFetchRequest(entityName: "CSEmployee")
        return self.managedContext.executeFetchRequest(request, error: nil)
    }
}
