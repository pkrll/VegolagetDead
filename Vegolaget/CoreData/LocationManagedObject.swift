//
//  LocationManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(LocationManagedObject)
class LocationManagedObject: ItemManagedObject {
  
  @NSManaged var locationID: NSNumber
  @NSManaged var storeID: NSNumber
  @NSManaged var city: String
  
}