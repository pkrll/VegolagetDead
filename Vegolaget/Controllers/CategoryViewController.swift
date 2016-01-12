//
//  CategoryViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class CategoryViewController: TableViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = Constants.Nib.CategoryCell.rawValue
        self.registerNib(nibName, forCellReuseIdentifier: nibName, withTableView: self.tableView)
        self.tableView.delegate = self
        self.loadDatasource()
        self.loadModel()
    }
    
    override func loadDatasource() {

    }
    
    override func loadModel() {
        self.model = CategoryModel()
        self.model.delegate = self
        self.model.loadData()
    }
    
    override func model(model: Model, didFinishLoadingData data: [Item]) {
        self.dataSource.loadData(data)
        super.model(model, didFinishLoadingData: [])
    }
    
    override func didFinishLoadDataSource(_: DataSource) {
        self.tableView.reloadData()
    }
}