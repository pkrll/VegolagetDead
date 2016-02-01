//
//  LookupDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 01/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class LookupDataSource: DataSource {
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = self.items[indexPath.row]
    let cell: UITableViewCell

    switch item {
      case is Producer:
        cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.ProducerCell.rawValue)!
      case is Product:
        cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.ProductCell.rawValue)!
      case is Store:
        cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.StoreCell.rawValue)!
      default:
        cell = UITableViewCell(style: .Default, reuseIdentifier: Constants.Nib.BaseCell.rawValue)
    }
    
    if let view = cell.viewWithTag(101) as? UILabel {
      if item is Store {
        view.text = (item as! Store).address
      } else {
        view.text = item.name
      }
    }
    
    if let view = cell.viewWithTag(102) as? UILabel {
      var veganStatus: String = "UNKNOWN".localized
      
      if let item = item as? Product {
        veganStatus = VeganStatusType(rawValue: item.vegan)?.description.localized ?? "UNKNOWN".localized
      } else if let item = item as? Producer {
        veganStatus = VeganStatusType(rawValue: item.vegan)?.description.localized ?? "UNKNOWN".localized
      }

      view.text = veganStatus
    }
    
    return cell
  }
  
}