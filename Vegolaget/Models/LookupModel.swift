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

  private var searchScope: String = ""
  
  private var searchResults: [Int] = []
  
  private var elements: [Item] = []
  
  override init() {
    super.init()
    self.manager.delegate = self
  }

  func getCoreDataPredicate() -> NSPredicate {
    return NSPredicate(format: "id IN %@", self.searchResults)
  }
  
  func performSearch(searchString: String, withSearchScope scope: String) {
    // Empty searches should not do anything.
    if searchString.isEmpty {
      self.delegate?.model(self, didFinishLoadingData: [])
      return
    }
    self.coreDataEntity = CoreDataEntities(rawValue: scope.capitalizedString)
    self.searchScope = scope
    
    let requestURL = APIEndPoint.Search.Root.string + scope
    let parameters = [
      "query": searchString,
      "vegan": "0"
    ]
    
    self.manager.setRequestURL(requestURL)
    self.manager.setParameters(parameters)
    self.manager.setHttpMethod("POST")
    self.manager.executeRequest(self.managerDidCompleteRequest, failure: self.managerFailedRequest)
  }
  
  override func loadData() {
    guard let entity = self.coreDataEntity?.rawValue else {
      return
    }

    // Attempts to load the items from core data by using their the retrieved ids from the search results. Zero results will ask the server.
    self.coreDataHelper.load(fromEntity: entity, withPredicate: self.getCoreDataPredicate(), sortByKeys: self.coreDataSortKeys) { (success, data: [AnyObject]?, error) -> Void in
      if let data = data where data.count > 0 {
        self.searchResults.removeAll(keepCapacity: false)
        self.elements.appendContentsOf(self.didLoadFromCoreData(data))
        // Checks if any of the retrieved ids are missing from the group fetched from core data.
        self.searchResults = self.searchResults.filter({ (id: Int) -> Bool in
          if self.elements.contains({ $0.id == id }) {
            return false
          }
          
          return true
        })

        if self.searchResults.count > 0 {
          self.refreshData()
        } else {
          self.willPassDataToDelegate(self.elements)
        }
      } else {
//        self.refreshData()
      }
    }
  }
  
  override func refreshData() {
    let endPoint: String

    switch self.searchScope {
    case "producer":
      endPoint = APIEndPoint.Producer.Root.string
    case "product":
      endPoint = APIEndPoint.Product.Root.string
    case "store":
      endPoint = APIEndPoint.Store.Root.string
    default:
      endPoint = ""
    }

    self.manager.setRequestURL(endPoint)
    self.manager.setHttpMethod("POST")
    self.manager.setParameters([
      "ids": JSON(self.searchResults).stringValue
      ])
    self.manager.executeRequest(self.managerDidCompleteRequest, failure: self.managerFailedRequest)
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items: [Item] = []
    // Depending on the Managed Object type, a different object should be created here.
    for coreDataObject in data {
      var item: Item?
      
      if let producer = coreDataObject as? ProducerManagedObject {
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
      } else if let product = coreDataObject as? ProductManagedObject {
        let json = JSON(
          [
            "id": product.id,
            "companyID": product.companyID,
            "name": product.name,
            "type": product.type,
            "vegan": product.vegan
          ]
        )
        
        item = Product(data: json)
      } else if let store = coreDataObject as? StoreManagedObject {
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
  
  override func managerDidCompleteRequest(response: APIResponse) {
    self.searchResults.removeAll(keepCapacity: false)
    
    if let data = response.returnData {
      let data = JSON(data: data)
      
      for (_, json): (String, JSON) in data {
        let id = json["id"].intValue
        self.searchResults.append(id)
      }
    }

    if self.searchResults.isEmpty {
      self.willPassDataToDelegate(self.elements)
    } else {
      self.loadData()
    }
  }
  
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
  
  override func willPassDataToDelegate(data: [Item]) {
    self.elements.removeAll(keepCapacity: false)
    super.willPassDataToDelegate(data)
  }
  
}
