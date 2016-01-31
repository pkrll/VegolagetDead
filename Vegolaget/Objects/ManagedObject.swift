//
//  Managed Object classes
//  Vegolaget
//
//  Created by Ardalan Samimi on 27/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(ItemManagedObject)
class ItemManagedObject: NSManagedObject {
  @NSManaged var id: NSNumber
  @NSManaged var name: String
}

@objc(CategoryManagedObject)
class CategoryManagedObject: ItemManagedObject {
  @NSManaged var tag: String
  @NSManaged var title: String
  @NSManaged var count: NSNumber
}

@objc(ProducerManagedObject)
class ProducerManagedObject: ItemManagedObject {
  @NSManaged var country: String
  @NSManaged var tag: String
  @NSManaged var vegan: Int
  @NSManaged var doesWine: Bool
  @NSManaged var doesBeer: Bool
  @NSManaged var doesLiquor: Bool
}

@objc(ProductManagedObject)
class ProductManagedObject: ItemManagedObject {
  @NSManaged var companyID: NSNumber
  @NSManaged var type: String
  @NSManaged var vegan: Int
}

@objc(ProductInStockManagedObject)
class ProductInStockManagedObject: ItemManagedObject {
  @NSManaged var companyID: NSNumber
  @NSManaged var locationID: NSNumber
  @NSManaged var detailName: String
  @NSManaged var type: String
  @NSManaged var price: Double
  @NSManaged var volume: Double
  @NSManaged var package: String
  @NSManaged var year: Int
  @NSManaged var alcohol: Double
  @NSManaged var organic: Bool
}

@objc(LocationManagedObject)
class LocationManagedObject: ItemManagedObject {
  @NSManaged var locationID: NSNumber
  @NSManaged var storeID: NSNumber
  @NSManaged var city: String
}

@objc(StoreManagedObject)
class StoreManagedObject: ItemManagedObject {
  @NSManaged var postalCode: String
  @NSManaged var openHours: String
  @NSManaged var county: String
  @NSManaged var city: String
  @NSManaged var address: String
}