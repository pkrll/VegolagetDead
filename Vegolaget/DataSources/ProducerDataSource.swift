//
//  ProducerDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducerDataSource: DataSource {
  /**
   *  JoinedItems consist of Product items and ProductInStock items. These will be displayed depending on section.
   */
  private var joinedItems: [Int: [Item]] = [:]
  /**
   *  The table view section header titles.
   */
  private let headerTitle: [Int: String] = [
    0: "Listade på Barnivore.com",
    1: "I Systembolagets lager"
  ]
  
  override func loadData(data: [Item]) {
    let data = data.sort( { $0.0.name < $0.1.name } )
    let listing = data.filter { return $0 is ProductInStock == false }
    let inStock = data.filter { return $0 is ProductInStock == true }
    
    self.joinedItems[0] = listing
    self.joinedItems[1] = inStock
    
    self.delegate?.didFinishLoadDataSource(self)
  }
  
  override func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
    if self.joinedItems[indexPath.section]?.count > 0 {
      return self.joinedItems[indexPath.section]![indexPath.row]
    }
    
    return nil
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.joinedItems.keys.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.joinedItems[section]?.count ?? 0
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.headerTitle[section]
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.ProductCell.rawValue)!
    let item = self.joinedItems[indexPath.section]![indexPath.row] as! Product
    
    if let textLabel = cell.viewWithTag(101) as? UILabel {
      textLabel.text = item.name
    }
    
    var detailText = String()
    
    if item is ProductInStock {
      let item = item as! ProductInStock
      if item.detailName.isEmpty == false {
        detailText = item.detailName + "\n"
      }
      
      detailText += item.type
    } else {
      detailText = item.type.localized + "\n" + item.status.localized
    }
    
    if let detailTextLabel = cell.viewWithTag(102) as? UILabel {
      detailTextLabel.numberOfLines = 0
      detailTextLabel.text = detailText
      detailTextLabel.sizeToFit()
    }
    
    if let imageView = cell.viewWithTag(100) as? UIImageView {
      var imageName = String()
      
      if item.type.localized.containsString("vin", caseInsensitive: true) {
        imageName = "wine"
      } else if item.type.localized.containsString("öl", caseInsensitive: true) {
        imageName = "beer"
      } else {
        imageName = "liquor"
      }
      
      imageView.image = UIImage(named: imageName)
    }
    
    return cell
  }
  
}
