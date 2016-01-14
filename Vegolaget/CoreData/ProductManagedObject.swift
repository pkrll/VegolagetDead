//
//  ProductManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(ProductManagedObject)
class ProductManagedObject: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var companyID: NSNumber
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var status: String
    
}