//
//  CSDepartment.swift
//  CoreDataTest
//
//  Created by VLADIMIR KONEV on 09.06.14.
//  Copyright (c) 2014 Novilab Mobile. All rights reserved.
//

import Foundation
import CoreData

@objc(CSDepartment)
class CSDepartment : NSManagedObject{
    @NSManaged var title: NSString
    @NSManaged var internalID: NSNumber
    @NSManaged var phone: NSString?
    @NSManaged var employees: NSSet
    
    override func awakeFromInsert() {
        self.title = "New department"
        self.internalID = 0
    }
    
    func description() -> NSString{
        let employeesDescription = self.employees.allObjects.map({employee in employee.description()})
        return "Department: title=\(self.title), id=[\(self.internalID)], phone=\(self.phone) and employees = \(employeesDescription)"
    }

    //Working with Employees
    func addEmployeesObject(employee: CSEmployee?){
        let set:NSSet = NSSet(object: employee)
        self.addEmployees(set)
    }
    
    func removeEmployeesObject(employee: CSEmployee?){
        let set:NSSet = NSSet(object: employee)
        self.removeEmployees(set)
    }
    
    func addEmployees(employees: NSSet?){
        self.willChangeValueForKey("employees", withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: employees)
        self.primitiveValueForKey("employees").unionSet(employees)
        self.didChangeValueForKey("employees", withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: employees)
    }
    
    func removeEmployees(employees: NSSet?){
        self.willChangeValueForKey("employess", withSetMutation: NSKeyValueSetMutationKind.MinusSetMutation, usingObjects: employees)
        self.primitiveValueForKey("employees").minusSet(employees)
        self.didChangeValueForKey("employees", withSetMutation: NSKeyValueSetMutationKind.MinusSetMutation, usingObjects: employees)
    }
}
