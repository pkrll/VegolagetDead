//
//  StoreViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class StoreViewController: TableViewController {

    @IBOutlet var tableView: UITableView!
    
    internal var store: Store?
    
    override internal var viewTitle: String {
        return self.store?.address ?? "Systembolaget"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib(Constants.Nib.StoreCell.rawValue)
        self.tableView.delegate = self
    }

    
    override func loadDataSource() {
    }
    
    override func loadModel() {
    }
    
}
