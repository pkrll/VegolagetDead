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
  func loadData(_ data: [Item]) {
    self.items = data
    self.delegate?.didFinishLoadDataSource(self)
  }
  /**
   *  Returns an item at a specific position using an index path.
   *  - Parameter indexPath: A table view index path.
   *  - Returns: An object of type Item.
   */
  func itemAtIndexPath(_ indexPath: IndexPath) -> Item? {
    return (self.items.count > 0) ? self.items[indexPath.row] : nil
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: Nib.BaseCell.rawValue)
    
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: Nib.BaseCell.rawValue)
    }
    
    return cell!
  }
  
}
