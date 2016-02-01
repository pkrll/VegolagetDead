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

  private let searchCategory: Item.Type? = nil
  
  override init() {
    super.init()
    self.manager.delegate = self
  }
  
  override func saveData(data: [Item]) {
  }
  
  override func loadData() {
  }
  
  func performSearch(searchString: String) {
    let requestURL = APIEndPoint.Search.Root.string + "/product/"
    let parameters = ["query": searchString]
    self.manager.setRequestURL(requestURL)
    self.manager.setParameters(parameters)
    self.manager.setHttpMethod("POST")
    self.manager.executeRequest(self.managerDidCompleteRequest, failure: self.managerFailedRequest)
  }
  
  override func managerDidCompleteRequest(response: APIResponse) {
    if let data = response.returnData {
      let json = JSON(data: data)
      print(json)
    }
  }
  
  
  
}
