//
//  ProducerViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducerViewController: TableViewController {
    
    @IBOutlet var tableView: UITableView!
    
    internal var producer: Producer?
    
    override internal var viewTitle: String {
        return self.producer?.name ?? "Producent"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productCell = Constants.Nib.ProductCell.rawValue
        self.registerNib(productCell, forCellReuseIdentifier: productCell, withTableView: self.tableView)
        
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.loadDataSource()
        self.loadModel()
    }
    
    override func loadDataSource() {
        self.dataSource = ProducerDataSource()
        self.dataSource.delegate = self
        self.tableView.dataSource = self.dataSource
    }
    
    override func loadModel() {
        if let id = self.producer?.id {
            self.model = ProducerModel(producerID: id)
            self.model.coreDataPredicate = NSPredicate(format: "companyID = %i", id)
            self.model.delegate = self
            self.model.loadData()
        }
    }
    
    // MARK: - Model Delegate Methods
    
    override func model(model: Model, didFinishLoadingData data: [Item]) {
        self.dataSource.loadData(data)
        super.model(model, didFinishLoadingData: [])
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Barnivore items and System Company items differ
        if indexPath.section == 1 {
            let sender = tableView.cellForRowAtIndexPath(indexPath)
            self.performSegueWithIdentifier(Constants.Segue.ShowProduct.rawValue, sender: sender)
        }
    }
}