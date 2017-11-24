//
//  ProducerDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProducerDataSource: DataSource {
  /**
   *  JoinedItems consist of Product items and ProductInStock items. These will be displayed depending on section.
   */
  fileprivate var joinedItems: [Int: [Item]] = [:]
  /**
   *  The table view section header titles.
   */
  fileprivate let headerTitle: [Int: String] = [
    0: "Listade på Barnivore.com",
    1: "I Systembolagets lager"
  ]
  
  override func loadData(_ data: [Item]) {
//    let data = data.sort( { $0.0.name < $0.1.name } )
    let listing = data.filter { return $0 is ProductInStock == false }
    let inStock = data.filter { return $0 is ProductInStock == true }
    
    self.joinedItems[0] = listing
    self.joinedItems[1] = inStock
    
    self.delegate?.didFinishLoadDataSource(self)
  }
  
  override func itemAtIndexPath(_ indexPath: IndexPath) -> Item? {
    if self.joinedItems[indexPath.section]?.count > 0 {
      return self.joinedItems[indexPath.section]![indexPath.row]
    }
    
    return nil
  }
  
  func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
    return self.joinedItems.keys.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.joinedItems[section]?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.headerTitle[section]
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Nib.ProductCell.rawValue)!
    let item = self.joinedItems[indexPath.section]![indexPath.row] as! Product
    
    if let textLabel = cell.viewWithTag(101) as? UILabel {
      textLabel.text = item.name
    }
    
    var detailText = String()

    if let item = item as? ProductInStock {
      detailText = item.detailName + "\n" + item.type
    } else {
      let veganStatus = VeganStatusType(rawValue: item.vegan)?.description.localized ?? "UNKNOWN".localized
      detailText = item.type.localized + "\n" + veganStatus
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
