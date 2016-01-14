//
//  ProductDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProductDataSource: DataSource {

    private var locations = [String: [String]]()
    private var indexTitle = [String]()
    
    override func loadData(data: [Item]) {
        let stores = data.sort { ($0.0 as! Store).city < ($0.1 as! Store).city }
        // The product data source will only load and display the unique locations/cities, retrieved from the Stores array.
        for store in stores as! [Store] {
            guard let initialCharacter = store.city.characters.first else {
                continue
            }
            
            let city = store.city
            let index = String(initialCharacter)
            
            if self.locations[index] == nil {
                self.locations[index] = []
            }
            
            if self.locations[index]?.contains(city) == false {
                self.locations[index]?.append(city)
            }
        }
        // Alphabeticaly sorts the keys, with Swedish characters.
        self.indexTitle = self.locations.keys.sort { self.compare($0.0, withString: $0.1, localeIdentifier: "se") }
        self.delegate?.didFinishLoadDataSource(self)
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
            textLabel.text = item
        }
        
        return cell
    }
    
}

private extension ProductDataSource {
    
    func compare(string: String, withString compare: String, localeIdentifier: String) -> Bool {
        let locale = NSLocale(localeIdentifier: localeIdentifier)
        let string = string as NSString
        let compare = compare as NSString
        
        return string.compare(compare as String, options: .CaseInsensitiveSearch, range: NSMakeRange(0, string.length), locale: locale) == NSComparisonResult.OrderedAscending
    }
    
}