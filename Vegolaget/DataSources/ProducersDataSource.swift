//
//  ProducersDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducersDataSource: SearchDataSource {
    /**
     *  Current page.
     */
    internal var pageCurrent = 1
    /**
     *  Number of items to show at a time.
     *  - Note: This will limit the number of items displayed at a time.
     */
    internal var pageLimit = 15
    /**
     *  Returns the total number of pages for the table view to show.
     *  - Note: This property determines how many items to show at once in the table view. Whenever a new page is available a load button should be rendered at the last visible row.
     */
    internal var pageTotal: Int {
        let count = self.visibleItems.count
        return Int(ceil(Double(count) / Double(self.pageLimit)))
    }
    /**
     *  Returns the number of visible items currenlty displayed in the table view.
     */
    internal var numberOfItemsInView: Int {
        let index = self.pageCurrent * self.pageLimit
        let count = self.visibleItems.count
        
        if count > index {
            return self.visibleItems[0..<index].count
        }
        
        return count
    }
    /**
     *  Returns the number of items searchable.
     */
    internal var numberOfSearchableItems: Int {
        if self.visibleItems.count > 0 {
            return self.visibleItems.count
        }
        
        return self.items.count
    }

    override func filterBySearchString(string: String) {
        self.filteredItems.removeAll(keepCapacity: false)
        self.filteredItems = self.items.filter({ (item: Item) -> Bool in
            var matchByType = true
            let matchByName = item.name.containsString(string, caseInsensitive: true)
            let matchByLand = (item as! Producer).country.containsString(string, caseInsensitive: true)
            
            if self.selectedScopeIndex == 1 {
                matchByType = (item as! Producer).isVegan
                // This makes sure that the type matching works when activating the search bar after a cancellation.
                if string.isEmpty {
                    return matchByType
                }
            }
            
            return matchByName && matchByType || matchByLand && matchByType
        })
        
        (self.delegate as? SearchDataSourceDelegate)?.didFinishFilterDataSource(self)
    }
    /**
     *  This method determines if there are more items to show from the elements array in a table view. If there are, the data source will increment the page number itself.
     *  - Parameters:
     *      - atRow: The row that is being displayed.
     *  - Returns: A boolean value indicating whether there are more items or not to be shown.
     *  - Note: If the return value is true, reload the table view do display the new rows.
     */
    func hasMoreItemsToLoad(atRow row: Int) -> Bool {
        // Because this method might also be called by the table view delegate method tableView(_:willDisplayCell:forRowAtIndexPath:) it should only return true if the current displayed row is the last visible row, so that it doesn't cause a bug.
        if row  == self.numberOfItemsInView && self.pageTotal > self.pageCurrent {
            self.pageCurrent++
            return true
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.numberOfItemsInView
        let total = self.visibleItems.count
        // Return an extra row if there are more items to load; to show a LoadingCell at the bottom.
        if count > 0 && count != total {
            return count + 1
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        // The last row, if there are more items to show, should be a different type of cell
        if indexPath.row == self.numberOfItemsInView {
            cell = self.tableView(tableView, loadingCellForRowAtIndexPath: indexPath)
        } else {
            cell = self.tableView(tableView, producerCellForRowAtIndexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, producerCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.ProducerCell.rawValue)!
        let item = self.visibleItems[indexPath.row] as! Producer
        
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            // TODO: CHANGE THIS
            imageView.image = UIImage(named: "wine")
        }
        
        if let textLabel = cell.viewWithTag(101) as? UILabel {
            textLabel.text = item.name
        }
        
        if let detailLabel = cell.viewWithTag(102) as? UILabel {
            detailLabel.text = item.status.localized
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, loadingCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.LoadingCell.rawValue)!
        
        return cell
    }

}
