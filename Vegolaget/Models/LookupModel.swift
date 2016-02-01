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

  func GetCoreDataPredicate() -> NSPredicate {
    return NSPredicate(format: "id in %@", self.searchResults)
  }
  
  func performSearch(searchString: String, withSearchScope scope: String) {
    // Empty searches should not do anything.
    if searchString.isEmpty {
      self.delegate?.model(self, didFinishLoadingData: [])
      return
    }
    self.coreDataEntity = CoreDataEntities(rawValue: scope)
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
    self.coreDataHelper.load(fromEntity: entity, withPredicate: self.GetCoreDataPredicate(), sortByKeys: self.coreDataSortKeys) { (success, data: [AnyObject]?, error) -> Void in
      if let data = data where data.count > 0 {
        self.elements = self.didLoadFromCoreData(data)
        // Checks if any of the retrieved ids are missing from the group fetched from core data.
        self.searchResults = self.searchResults.filter({ (id: Int) -> Bool in
          return self.elements.contains { $0.id != $0 }
        })
        
        if self.searchResults.count > 0 {
          self.refreshData()
        } else {
          self.willPassDataToDelegate(self.elements)
        }
      } else {
        self.refreshData()
      }
    }
  }
  
  override func refreshData() {
    // CALLS API WITH POST AS METHOD AND PARAMETERS SET TO ARRAY OF IDS
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    return []
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
    
    self.loadData()
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
  
}
