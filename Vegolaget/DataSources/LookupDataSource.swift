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
        cell = tableView.dequeueReusableCellWithIdentifier(Nib.ProducerCell.rawValue)!
      case is Product:
        cell = tableView.dequeueReusableCellWithIdentifier(Nib.ProductCell.rawValue)!
      case is Store:
        cell = tableView.dequeueReusableCellWithIdentifier(Nib.StoreCell.rawValue)!
      default:
        cell = UITableViewCell(style: .Default, reuseIdentifier: Nib.BaseCell.rawValue)
    }
    
    if let view = cell.viewWithTag(101) as? UILabel {
      if item is Store {
        view.text = (item as! Store).address
      } else {
        view.text = item.name
      }
    }
    
    if let view = cell.viewWithTag(102) as? UILabel {
      var description: String = ""
      
      if let item = item as? ProductInStock {
        description = (item.detailName.isEmpty) ? item.producer : item.detailName
        description = description + "\n" + item.type
      } else if let item = item as? Product {
        description = VeganStatusType(rawValue: item.vegan)?.description.localized ?? "UNKNOWN".localized
      } else if let item = item as? Producer {
        description = VeganStatusType(rawValue: item.vegan)?.description.localized ?? "UNKNOWN".localized
      } else if let item = item as? Store {
        description = "\(item.postalCode) \(item.city)"
      }
      
      view.numberOfLines = 0
      view.text = description
      view.sizeToFit()
    }
    
    if let imageView = cell.viewWithTag(100) as? UIImageView {
      var imageName = String()
      
      if let item = item as? Product {
        if item.type.localized.containsString("vin", caseInsensitive: true) {
          imageName = "wine"
        } else if item.type.localized.containsString("öl", caseInsensitive: true) {
          imageName = "beer"
        } else {
          imageName = "liquor"
        }
      }

      imageView.image = UIImage(named: imageName)
    }
    
    return cell
  }
  
}