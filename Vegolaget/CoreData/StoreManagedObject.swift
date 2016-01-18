//
//  StoresManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(StoreManagedObject)
class StoreManagedObject: ItemManagedObject {
  
  @NSManaged var postalCode: String
  @NSManaged var phone: String
  @NSManaged var openHours: String
  @NSManaged var county: String
  @NSManaged var city: String
  @NSManaged var address: String
  
}