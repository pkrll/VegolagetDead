//
//  TableViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class TableViewController: ViewController, DataSourceDelegate, UITableViewDelegate {

    internal var dataSource: DataSource!
    
    func loadDataSource() {
        self.dataSource = DataSource()
        self.dataSource.delegate = self
    }
    /**
     *  Invoked when the data source has finished loading the data received from the controller.
     *  - Note: Will reload the table view if there is one set. Override this method if there are other operations needed to be run.
     */
    func didFinishLoadDataSource(_: DataSource) {
        if self.respondsToSelector("tableView") {
            let tableView = self.valueForKey("tableView")
            tableView?.reloadData()
        }
    }
    /**
     *  Registers a nib object containing a cell with the table view under a specified identifier.
     *  - Parameters:
     *      - tableView: The table view with which to register the nib objects.
     *  - Note: Call this method for the table view to know which cells to use.
     */
    func registerNib(nibName: String, forCellReuseIdentifier identifier: String, withTableView tableView: UITableView) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }    
    
}
