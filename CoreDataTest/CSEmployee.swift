//
//  CSEmployee.swift
//  CoreDataTest
//
//  Created by VLADIMIR KONEV on 09.06.14.
//  Copyright (c) 2014 Novilab Mobile. All rights reserved.
//

import Foundation
import CoreData

let st_fNames = ["John", "David", "Michael", "Bob"]
let st_lNames = ["Lim", "Jobs", "Kyler"]

@objc(CSEmployee)
class CSEmployee:NSManagedObject{
    @NSManaged var firstName: NSString
    @NSManaged var lastName: NSString
    @NSManaged var age: NSNumber?
    @NSManaged var department: CSDepartment
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.firstName = st_fNames[Int(arc4random_uniform(UInt32(st_fNames.count)))]
        self.lastName = st_lNames[Int(arc4random_uniform(UInt32(st_lNames.count)))]
    }
    
    func description() -> NSString{
        return "Employee: name= \(self.firstName) \(self.lastName), age=\(self.age) years" 
    }
}