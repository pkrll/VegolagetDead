//
//  ProducerManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(ProducerManagedObject)
class ProducerManagedObject: ItemManagedObject {
  
  @NSManaged var country: String
  @NSManaged var notes: String
  @NSManaged var tag: String
  @NSManaged var status: String
  @NSManaged var doesWine: Bool
  @NSManaged var doesBeer: Bool
  @NSManaged var doesLiquor: Bool
  
}