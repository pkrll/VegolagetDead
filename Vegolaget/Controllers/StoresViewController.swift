//
//  StoreViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class StoresViewController: TableViewController {
  
  @IBOutlet var tableView: UITableView!
  
  internal var locations: [Location]?
  
  override internal var viewTitle: String {
    return self.locations?.first?.city ?? "Butiker"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.registerNib(Constants.Nib.StoreCell.rawValue)
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = StoresDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    if let locations = self.locations where locations.count > 0 {
      let cities = locations.map({ (item: Location) -> Int in
        return item.storeID
      })
      self.model = StoresModel(locations: locations)
      self.model.delegate = self
      self.model.coreDataPredicate = NSPredicate(format: "id IN %@", cities)
      self.model.loadData()
      self.locations = nil
    }
  }
  
}
