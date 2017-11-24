//
//  ProductDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProductDataSource: DataSource {
  
  fileprivate var locations = [String: [Location]]()
  fileprivate var indexTitle = [String]()
  
  override func loadData(_ data: [Item]) {
    let locations = data.sorted { ($0.0 as! Location).city < ($0.1 as! Location).city }
    
    for location in locations as! [Location] {
      guard let initialCharacter = location.city.characters.first else {
        continue
      }
      
      let index = String(initialCharacter)
      
      if self.locations[index] == nil {
        self.locations[index] = []
      }
      
      if self.locations[index]?.contains(where: { $0.city == location.city }) == false {
        self.locations[index]?.append(location)
      }
    }
    // Alphabeticaly sorts the keys with regards to Swedish characters.
    self.items = locations
    self.indexTitle = self.locations.keys.sorted { $0.0 <? $0.1 }
    self.delegate?.didFinishLoadDataSource(self)
  }
  
  func itemsAtIndexPath(_ indexPath: IndexPath) -> [Item]? {
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
  
  func sectionIndexTitlesForTableView(_ tableView: UITableView) -> [String]? {
    // No reason to show the index titles if there are fewer than 5 items.
    if self.indexTitle.count > 5 {
      return self.indexTitle
    }
    
    return nil
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return self.indexTitle.index(of: title) ?? index
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.indexTitle[section]
  }
  
  func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
    return self.indexTitle.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let index = self.indexTitle[section]
    return self.locations[index]?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Nib.StoreLocationCell.rawValue)!
    let index = self.indexTitle[indexPath.section]
    let item = self.locations[index]?[indexPath.row]
    
    if let textLabel = cell.viewWithTag(101) as? UILabel {
      textLabel.text = item?.city
    }
    
    return cell
  }
  
}
