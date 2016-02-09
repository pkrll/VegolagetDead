//
//  CategoryDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class CategoryDataSource: DataSource {
  
  override func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
    return self.items.count > 0 ? self.items[indexPath.section] : nil
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.items.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Nib.CategoryCell.rawValue)!
    let item = self.items[indexPath.section] as! Category
        
    if let imageView = cell.viewWithTag(100) as? UIImageView {
      imageView.image = UIImage(named: item.tag)
    }
    
    if let titleView = cell.viewWithTag(101) as? UILabel {
      titleView.text = item.title
    }
    
    return cell
  }
  
}