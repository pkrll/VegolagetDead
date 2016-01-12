//
//  DataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class DataSource: NSObject, UITableViewDataSource {
    
    internal var delegate: DataSourceDelegate?
    /**
     *  The items to be displayed.
     */
    internal var data: [Item] = []
    /**
     *  Loads and sorts the items.
     */
    func loadData(data: [Item]) {
        self.data = data.sort ({ $0.0.id < $0.1.id })
        self.delegate?.didFinishLoadDataSource(self)
    }
    /**
     *  Returns an item at a specific position using an index path.
     *  - Parameter indexPath: A table view index path.
     *  - Returns: An object of type Item.
     */
    func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
        return (self.data.count > 0) ? self.data[indexPath.row] : nil
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.BaseCell.rawValue)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: Constants.Nib.BaseCell.rawValue)
        }
        
        return cell!
    }

}