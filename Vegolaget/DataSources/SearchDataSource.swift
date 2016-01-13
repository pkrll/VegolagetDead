//
//  SearchDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class SearchDataSource: DataSource {
    
    internal var selectedScopeIndex = 0
    
    internal var filteredItems: [Item] = []
    
    internal var visibleItems: [Item] {
        if self.searchControllerIsActive {
            return self.filteredItems
        }
        
        return self.items
    }
    
    private var searchControllerIsActive: Bool {
        if let delegate = self.delegate as? SearchDataSourceDelegate {
            return delegate.searchController.active
        }
        
        return false
    }
    
    func filterBySearchString(string: String) {
        self.filteredItems.removeAll(keepCapacity: false)
        self.filteredItems = self.items.filter({ (item: Item) -> Bool in
            return item.name.containsString(string, caseInsensitive: true)
        })
        
        (self.delegate as? SearchDataSourceDelegate)?.didFinishFilterDataSource(self)
    }
    
    override func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
        return self.visibleItems.count > 0 ? self.visibleItems[indexPath.row] : nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleItems.count
    }
    
}
