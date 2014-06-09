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
        //Get manager
        let manager = CSDataManager.sharedInstance()
        
        //Testing insert new objects
        let newDepartment : CSDepartment = NSEntityDescription.insertNewObjectForEntityForName("CSDepartment", inManagedObjectContext: manager.managedContext) as CSDepartment
        let newEmployee: CSEmployee = NSEntityDescription.insertNewObjectForEntityForName("CSEmployee", inManagedObjectContext: manager.managedContext) as CSEmployee
        let newEmployee2: CSEmployee = NSEntityDescription.insertNewObjectForEntityForName("CSEmployee", inManagedObjectContext: manager.managedContext) as CSEmployee
        newEmployee.department = newDepartment
        newDepartment.addEmployeesObject(newEmployee2)
        manager.saveContext()
        
        //Get and print all departments
        println("Have add oen department and two employees")
        println("Departments: \(manager.departments())")
        println("Employees: \(manager.employees())")
        
        //Testing remove child object
        //TODO: Working bad(((( - child pointer to department is not changed
//        newDepartment.removeEmployeesObject(newEmployee2)
//        manager.saveContext()
//        println("Have delete one employee")
//        println("Departments: \(manager.departments())")
        
        //Testing cascade remove
        manager.managedContext.deleteObject(newDepartment)
        manager.saveContext()
        println("\nHave delete department")
        println("Departments: \(manager.departments())")
        println("Employees: \(manager.employees())")
        
//        Uncomment to remove all records
//        let departments = manager.departments()
//        for i in 0..departments.count{
//            let dep = departments[i] as CSDepartment
//            manager.managedContext.deleteObject(dep)
//        }
//        let employees = manager.employees()
//        for i in 0..employees.count{
//            let emp = employees[i] as CSEmployee
//            manager.managedContext.deleteObject(emp)
//        }
//        manager.saveContext()
//        println("\nHave delete all data")
//        println("Departments: \(manager.departments())")
//        println("Employees: \(manager.employees())")
        
        return true
    }
}

