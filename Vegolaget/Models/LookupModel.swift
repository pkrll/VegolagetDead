//
//  LookupModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 01/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import SwiftyJSON

class LookupModel: Model {
  
  internal var searchQuery = String()
  internal var searchScope = String()

  private(set) var searchResults = [Item]()
  
  override init() {
    super.init()
    self.manager.delegate = self
  }
  // MARK: - Overriden Methods
  /**
   *  Performs the search.
   */
  override func loadData() {
    self.coreDataEntity = Entities(rawValue: self.searchScope)
    // Cancel search if the query is empty or the scope does not match an entity.
    if self.coreDataEntity == nil || self.searchQuery.isEmpty {
      self.didPerformSearch()
      return
    }
    
    self.searchResults.removeAll(keepCapacity: false)
    
    let requestURL = APIEndPoint.search(forType: APIEndPoint(rawValue: self.searchScope)!)
    let parameters = [
      "query": self.searchQuery
    ]
    
    self.manager.setRequestURL(requestURL)
    self.manager.setParameters(parameters)
    self.manager.setHttpMethod("POST")
    self.manager.executeRequest(self.managerDidCompleteRequest, failure: self.managerFailedRequest)
  }
  /**
   *  This method will parse the search result and depending on if the search turned out zero results, it will cancel the operation or attempt to load the items from Core Data by using the retrieved IDs.
   *  - parameter response: The response.
   */
  override func managerDidCompleteRequest(response: APIResponse) {
    var results = [String: [Int]]()
    if let data = response.returnData {
      let data = JSON(data: data)
      // The data returned from a search will consist of a multidimensional JSON array, with the type of the object as the key. Creating a dictionary mimicking this structure allows for a little more flexibility when creating objects out of the search result.
      for (key, value): (String, JSON) in data {
        // Initialize the dictionary key if it does not exist already.
        if results[key] == nil {
          results[key] = []
        }

        for (_, json): (String, JSON) in value {
          let id = json["id"].intValue
          results[key]?.append(id)
        }
      }
    }
    // If the search turned zero results, then just give up, man. Otherwise, attempt to load the items from core data by using the retrieved ids.
    if results.values.count > 0 {
      self.loadFromCoreData(results)
    } else {
      self.didPerformSearch()
    }
  }
  
  override func parseResponseData(data: NSData?) -> [Item] {
    var list = [Item]()
    if let data = data {
      let data = JSON(data: data)
      // The data returned from a search will consist of a multidimensional JSON array, with the type of the object as the key. Creating a dictionary mimicking this structure allows for a little more flexibility when creating objects out of the search result.
      for (key, value): (String, JSON) in data {
        for (_, json): (String, JSON) in value {
          let item: Item
          
          switch key {
            case "\(Producer.self)":
              item = Producer(data: json)
            case "\(Product.self)":
              item = Product(data: json)
            case "\(ProductInStock.self)":
              item = ProductInStock(data: json)
            case "\(Store.self)":
              item = Store(data: json)
            default:
              item = Item(data: json)
          }
          
          list.append(item)
        }
      }
    }

    return list
  }
  
  override func saveData(data: [Item]) {
    // Allowed items to save
    let savableEntitiesArray = [
      Entities.Producer.rawValue,
      Entities.Product.rawValue,
      Entities.ProductInStock.rawValue,
      Entities.Store.rawValue
    ]
    
    switch self.searchScope.capitalizedString {
      case let entity where savableEntitiesArray.contains(entity):
        self.coreDataHelper.save(data, toEntity: entity)
      default:
        return
    }
  }

  // MARK: - Empty Overriden Methods
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    return []
  }

  override func willPassDataToDelegate(data: [Item]) {
  }
  
}

private extension LookupModel {
  
  /**
   *  Returns a custom, dynamic predicate for core data.
   */
  func constructPredicate(withArray array: [AnyObject]) -> NSPredicate {
    return NSPredicate(format: "id IN %@", array)
  }
  /**
   *  Last method invoked after a search.
   */
  func didPerformSearch() {
    dispatch_async(dispatch_get_main_queue()) {
      self.delegate?.model(self, didFinishLoadingData: self.searchResults)
      self.searchResults.removeAll(keepCapacity: false)
    }
  }
  /**
   *  Loads items from Core Data.
   */
  func loadFromCoreData(results: [String: [Int]]) {
    var index = 0
    var missing = [String: [Int]]()
    
    for (key, resultArray): (String, [Int]) in results {
      guard let entity = Entities(rawValue: key)?.rawValue else {
        self.didPerformSearch()
        return
      }
      
      self.coreDataHelper.load(fromEntity: entity, withPredicate: self.constructPredicate(withArray: resultArray), sortByKeys: self.coreDataSortKeys) { (success, data: [AnyObject]?, error) -> Void in
        if let data = data where data.count > 0 {
          let items = self.createItemFromObject(data)
          self.searchResults.appendContentsOf(items)
        }
        // Filter out any of the retrieved ids that are missing in the group of items fetched from Core Data
        let array = resultArray.filter({ (id: Int) -> Bool in
          if self.searchResults.contains({ $0.id == id }) {
            return false
          }
          
          return true
        })
        
        if array.count > 0 {
          missing[key] = array
        }

        // Runs at the end of the loop, checking if there are any ids missing.
        if ++index == results.count {
          // If some items are missing, attempts to call the server to get the information.
          if missing.count > 0 {
            self.loadFromServer(missing)
            return
          }
          
          self.didPerformSearch()
        }
      }
    }
  }
  /**
   *  Loads the information from the server. Called when a search results id was not matched in the database.
   *  - Parameter itemIDs: An array containing all the missing ids.
   */
  func loadFromServer(items: [String: [Int]]) {
    var requestURL = "/" + self.searchScope + "/"
    let parameters = [
      "items": JSON(items[self.searchScope] ?? [:])
    ]

    switch self.searchScope {
      case APIEndPoint.Producer.rawValue:
        requestURL = APIEndPoint.producer()
      case APIEndPoint.Product.rawValue:
        requestURL = APIEndPoint.product()
      case APIEndPoint.ProductInStock.rawValue:
        requestURL = APIEndPoint.productInStock()
      case APIEndPoint.Store.rawValue:
        requestURL = APIEndPoint.store()
      default:
        self.didPerformSearch()
        return
    }
    
    self.manager.setRequestURL(requestURL)
    self.manager.setParameters(parameters)
    self.manager.setHttpMethod("POST")
    self.manager.executeRequest({ (response: APIResponse) -> Void in
      let elements = self.parseResponseData(response.returnData)

      if elements.isEmpty == false {
        self.saveData(elements)
        self.searchResults.appendContentsOf(elements)
      }
      
      self.didPerformSearch()
    }, failure: self.managerFailedRequest)
  }
  /**
   *  Create Item objects from the core data results.
   *  - Parameter objects: An array of Item Managed Object classes.
   */
  func createItemFromObject(objects: [AnyObject]) -> [Item] {
    var items = [Item]()
    for object in objects {
      var item: Item?
      
      if let producer = object as? ProducerManagedObject {
        let json = JSON([
          "id": producer.id,
          "name": producer.name,
          "country": producer.country,
          "tag": producer.tag,
          "vegan": producer.vegan,
          "doesBeer": producer.doesBeer,
          "doesWine": producer.doesWine,
          "doesLiquor": producer.doesLiquor
        ])
        item = Producer(data: json)
      } else if let product = object as? ProductInStockManagedObject {
        let json = JSON([
          "id": product.id,
          "companyID": product.companyID,
          "locationID": product.locationID,
          "name": product.name,
          "detailName": product.detailName,
          "producer": product.producer,
          "type": product.type,
          "price": product.price,
          "volume": product.volume,
          "package": product.package,
          "year": product.year,
          "alcohol": product.alcohol,
          "organic": product.organic
        ])
        item = ProductInStock(data: json)
      } else if let product = object as? ProductManagedObject {
        let json = JSON([
          "id": product.id,
          "companyID": product.companyID,
          "name": product.name,
          "type": product.type,
          "vegan": product.vegan
        ])
        item = Product(data: json)
      } else if let store = object as? StoreManagedObject {
        let json = JSON([
          "id": store.id,
          "name": store.name,
          "address": store.address,
          "postalCode": store.postalCode,
          "city": store.city,
          "county": store.county,
          "openHours": store.openHours
          ])
        item = Store(data: json)
      }
      
      if let item = item {
        items.append(item)
      }
    }
    
    return items
  }

}