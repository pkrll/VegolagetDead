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
    self.coreDataEntity = CoreDataEntities(rawValue: self.searchScope.capitalizedString)
    // Cancel search if the query is empty or the scope does not match an entity.
    if self.coreDataEntity == nil || self.searchQuery.isEmpty {
      self.didPerformSearch()
      return
    }
    
    self.searchResults.removeAll(keepCapacity: false)
    
    let requestURL = APIEndPoint.Search.Root.string + self.searchScope
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
    var results = [Int]()
    if let data = response.returnData {
      let data = JSON(data: data)
      
      for (_, json): (String, JSON) in data {
        let id = json["id"].intValue
          results.append(id)
      }
    }
    // If the search turned zero results, then just give up, man. Otherwise, attempt to load the items from core data by using the retrieved ids.
    if results.isEmpty {
      self.didPerformSearch()
    } else {
      self.loadFromCoreData(results)
    }
  }
  /**
   *  The type of Item returned depends on the search scope.
   *  - parameter json: The JSON object containing the information to use to create the item.
   *  - Returns: An Item object.
   */
  override func createItem(json: JSON) -> Item {
    let item: Item
    
    switch self.searchScope {
    case "producer":
      item = Producer(data: json)
    case "product":
      item = Product(data: json)
    case "store":
      item = Store(data: json)
    default:
      item = Item(data: json)
    }
    
    return item
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
  func loadFromCoreData(itemIDs: [Int]) {
    guard let entity = self.coreDataEntity?.rawValue else {
      self.didPerformSearch()
      return
    }
    
    self.coreDataHelper.load(fromEntity: entity, withPredicate: self.constructPredicate(withArray: itemIDs), sortByKeys: self.coreDataSortKeys) { (success, data: [AnyObject]?, error) -> Void in
      if let data = data where data.count > 0 {
        self.searchResults = self.createItemFromObject(data)
        // Filter out any of the retrieved ids that are missing in the group of items fetched from Core Data
          let missing = itemIDs.filter({ (id: Int) -> Bool in
          if self.searchResults.contains({ $0.id == id }) {
            return false
          }
          
          return true
        })
        // If some items are missing attempts to call the server to get the information.
        if missing.count > 0 {
          self.loadFromServer(missing)
          return
        }
      }
      
      self.didPerformSearch()
    }
  }
  /**
   *  Loads the information from the server. Called when a search results id was not matched in the database.
   *  - Parameter itemIDs: An array containing all the missing ids.
   */
  func loadFromServer(itemIDs: [Int]) {
    var requestURL = "/" + self.searchScope.capitalizedString + "/"
    let parameters = [
      "ids": JSON(itemIDs).stringValue
    ]
    
    switch requestURL {
      case APIEndPoint.Producer.Root.rawValue:
        requestURL = APIEndPoint.Producer.Root.string
      case APIEndPoint.Product.Root.rawValue:
        requestURL = APIEndPoint.Product.Root.string
      case APIEndPoint.Store.Root.rawValue:
        requestURL = APIEndPoint.Store.Root.string
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
      } else {
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