//
//  ProductDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProductDataSource: DataSource {
  
  private var locations = [String: [Location]]()
  private var indexTitle = [String]()
  
  override func loadData(data: [Item]) {
    let locations = data.sort { ($0.0 as! Location).city < ($0.1 as! Location).city }
    
    for location in locations as! [Location] {
      guard let initialCharacter = location.city.characters.first else {
        continue
      }
      
      let index = String(initialCharacter)
      
      if self.locations[index] == nil {
        self.locations[index] = []
      }
      
      if self.locations[index]?.contains({ $0.city == location.city }) == false {
        self.locations[index]?.append(location)
      }
    }
    // Alphabeticaly sorts the keys with regards to Swedish characters.
    self.items = locations
    self.indexTitle = self.locations.keys.sort { $0.0 <? $0.1 }
    self.delegate?.didFinishLoadDataSource(self)
  }
  
  func itemsAtIndexPath(indexPath: NSIndexPath) -> [Item]? {
    let index = self.indexTitle[indexPath.section]
    let selected = self.locations[index]?[indexPath.row]
    let allItems = self.items.filter { (item: Item) -> Bool in
      let item = item as! Location
      if item.city == selected?.city {
        return true
      }
      
      return false
    }
    
    return allItems
  }
  
  // MARK: - Table View Data Source Delegate Methods
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    return self.indexTitle
  }
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return self.indexTitle.indexOf(title) ?? index
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.indexTitle[section]
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.indexTitle.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let index = self.indexTitle[section]
    return self.locations[index]?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.StoreLocationCell.rawValue)!
    let index = self.indexTitle[indexPath.section]
    let item = self.locations[index]?[indexPath.row]
    
    if let textLabel = cell.viewWithTag(101) as? UILabel {
      textLabel.text = item?.city
    }
    
    return cell
  }
  
}