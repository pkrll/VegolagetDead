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
    self.registerNib(Nib.StoreCell.rawValue)
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = StoresDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    if let locations = self.locations {
      self.model = StoresModel(locations: locations)
      self.model.delegate = self
      self.model.loadData()
    }
    
    self.locations = nil
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    if let location = self.dataSource.itemAtIndexPath(indexPath) as? Store {
      self.performSegue(withIdentifier: Segue.ShowStore.rawValue, sender: location)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? StoreViewController, let sender = sender as? Store {
      viewController.store = sender
    }
  }
  
}
