//
//  ProductInStockManagedObject.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData

@objc(ProductInStockManagedObject)
class ProductInStockManagedObject: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var companyID: NSNumber
    @NSManaged var locationID: NSNumber
    @NSManaged var name: String
    @NSManaged var detailName: String
    @NSManaged var type: String
    @NSManaged var price: Double
    @NSManaged var volume: Double
    @NSManaged var package: String
    @NSManaged var year: Int
    @NSManaged var alcohol: Double
    @NSManaged var organic: Bool
    
}