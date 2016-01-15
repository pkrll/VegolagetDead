//
//  StoreViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class StoresViewController: TableViewController {

    @IBOutlet var tableView: UITableView!
    
    internal var location: Location?
    
    override internal var viewTitle: String {
        return self.location?.name ?? "Butiker"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.registerNib(Constants.Nib.StoreCell.rawValue)
        self.loadDataSource()
        self.loadModel()
    }

    override func loadDataSource() {
        self.dataSource = StoresDataSource()
        self.dataSource.delegate = self
        self.tableView.dataSource = self.dataSource
    }
    
    override func loadModel() {
        self.model = StoresModel(city: self.location!.name)
        self.model.delegate = self
        self.model.loadData()
    }
    
}
