//
//  ProducerModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class ProducerModel: Model {
  
  private let coreDataEntities: [CoreDataEntities] = [.Product, .ProductInStock]
  
  init(producerID: Int) {
    super.init()
    self.coreDataPredicate = NSPredicate(format: "companyID = %i", producerID)
    self.endPoint = APIEndPoint.productsForProducer(producerID)
  }
  
  override func loadData() {
    var items: [AnyObject] = []
    // This model handles two different item types
    self.loadFromEntity(self.coreDataEntities[0].rawValue) { (results) -> Void in
      if let results = results {
        items.appendContentsOf(results)
      }
      
      self.loadFromEntity(self.coreDataEntities[1].rawValue, completionHandler: { (results) -> Void in
        if let results = results {
          items.appendContentsOf(results)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          if items.count > 0 {
            let items = self.didLoadFromCoreData(items)
            self.willPassDataToDelegate(items)
          } else {
            self.refreshData()
          }
        }
      })
    }
  }
  
  func loadFromEntity(entity: String, completionHandler: (results: [AnyObject]?) -> Void) {
    self.coreDataHelper.load(fromEntity: entity, withPredicate: self.coreDataPredicate, sortByKeys: self.coreDataSortKeys) { (success, data, error) -> Void in
      completionHandler(results: data)
    }
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items: [Item] = []
    // Depending on the Managed Object type, a different object should be created here.
    for product in data {
      if let product = product as? ProductInStockManagedObject {
        let json = JSON(
          [
            "id": product.id,
            "companyID": product.companyID,
            "locationID": product.locationID,
            "producer": product.producer,
            "name": product.name,
            "detailName": product.detailName,
            "type": product.type,
            "price": product.price,
            "volume": product.volume,
            "package": product.package,
            "year": product.year,
            "alcohol": product.alcohol,
            "organic": product.organic
          ]
        )
        
        let item = ProductInStock(data: json)
        items.append(item)
      } else if let product = product as? ProductManagedObject {
        let json = JSON(
          [
            "id": product.id,
            "companyID": product.companyID,
            "name": product.name,
            "type": product.type,
            "vegan": product.vegan
          ]
        )
        
        let item = Product(data: json)
        items.append(item)
      }
    }
    
    return items
  }
  
  override func saveData(data: [Item]) {
    let listing = data.filter { $0 is ProductInStock == false }
    let inStock = data.filter { $0 is ProductInStock == true }
    
    self.coreDataHelper.save(listing, toEntity: self.coreDataEntities[0].rawValue)
    self.coreDataHelper.save(inStock, toEntity: self.coreDataEntities[1].rawValue)
  }
  
  override func parseResponseData(data: NSData?) -> [Item] {
    var items = [Item]()
    if let data = data {
      let data = JSON(data: data)
      // This Model's API End Point returns a dictionary that consists of two keys.
      for (key, value): (String, JSON) in data {
        // One has the key "Product", with information on product listings from Barnivore.com, and the other uses the key "ProductInStock", with products from the System Company.
        for (_, json): (String, JSON) in value {
          var object: Item? = nil
          // Depending on which type, a different object will be created.
          // TODO: Come up with a better approach.
          if key == "\(Product.self)" {
            object = Product(data: json)
          } else if key == "\(ProductInStock.self)" {
            object = ProductInStock(data: json)
          }
          
          if let object = object {
            items.append(object)
          }
        }
      }
    }
    
    return items
  }
  
}