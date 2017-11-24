//
//  StoresDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class StoresDataSource: DataSource {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Nib.StoreCell.rawValue)!
    let item = self.itemAtIndexPath(indexPath) as! Store
    
    if let view = cell.viewWithTag(101) as? UILabel {
      view.text = item.address
    }
    
    if let view = cell.viewWithTag(102) as? UILabel {
      view.text = "\(item.postalCode)"
    }
    
    return cell
  }
  
}
