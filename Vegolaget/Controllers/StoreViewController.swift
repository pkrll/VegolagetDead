//
//  StoreViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 22/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class StoreViewController: TableViewController {
  
  internal var storeID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = StoreDataSource()
  }
  
  override func loadModel() {
    if let storeID = self.storeID {
      self.model = StoreModel(storeID: storeID)
      self.model.delegate = self
      self.model.loadData()
    }
    
    self.storeID = nil
  }
  
}
