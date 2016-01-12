//
//  TableViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class TableViewController: ViewController {


    func loadDatasource() {
        
    }
    /**
     *  Registers a nib object containing a cell with the table view under a specified identifier.
     *  - Parameters:
     *      - tableView: The table view with which to register the nib objects.
     *  - Note: Call this method for the table view to know which cells to use.
     */
    final func registerNib(nibName: String, forCellReuseIdentifier identifier: String, withTableView tableView: UITableView) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }    
    
}
