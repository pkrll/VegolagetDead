//
//  DataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import CoreData
/**
 *  This class serves as the basis of all Data Source classes and contains the base methods that all data source objects share.
 *
 */
class DataSource: NSObject, UITableViewDataSource {
  
  internal weak var delegate: DataSourceDelegate?
  /**
   *  The items to be displayed.
   */
  internal var items: [Item] = []
  /**
   *  Loads and sorts the items.
   */
  func loadData(data: [Item]) {
    self.items = data
    self.delegate?.didFinishLoadDataSource(self)
  }
  /**
   *  Returns an item at a specific position using an index path.
   *  - Parameter indexPath: A table view index path.
   *  - Returns: An object of type Item.
   */
  func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
    return (self.items.count > 0) ? self.items[indexPath.row] : nil
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(Nib.BaseCell.rawValue)
    
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: Nib.BaseCell.rawValue)
    }
    
    return cell!
  }
  
}