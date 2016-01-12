//
//  CategoryManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import CoreData

@objc(CategoryManagedObject)
class CategoryManagedObject: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var tag: String
    @NSManaged var name: String
    @NSManaged var title: String
    @NSManaged var count: NSNumber
    
}