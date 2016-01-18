//
//  ItemManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(ItemManagedObject)
class ItemManagedObject: NSManagedObject {
  
  @NSManaged var id: NSNumber
  @NSManaged var name: String
  
}