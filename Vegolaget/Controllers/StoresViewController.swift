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
    if let locations = self.locations {
      self.model = StoresModel(locations: locations)
      self.model.delegate = self
      self.model.loadData()
    }
    
    self.locations = nil
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let location = self.dataSource.itemAtIndexPath(indexPath) as? Store {
      self.performSegueWithIdentifier(Constants.Segue.ShowStore.rawValue, sender: location)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewController = segue.destinationViewController as? StoreViewController, let sender = sender as? Store {
      viewController.storeID = sender.id
    }
  }
  
}
