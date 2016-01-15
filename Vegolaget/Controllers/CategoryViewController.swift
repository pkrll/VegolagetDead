//
//  CategoryViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class CategoryViewController: TableViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNib(Constants.Nib.CategoryCell.rawValue)
        self.tableView.delegate = self
        self.loadDataSource()
        self.loadModel()
    }

    override func loadDataSource() {
        self.dataSource = CategoryDataSource()
        self.dataSource.delegate = self
        self.tableView.dataSource = self.dataSource
    }

    override func loadModel() {
        self.model = CategoryModel()
        self.model.delegate = self
        self.model.loadData()
    }

//    override func model(model: Model, didFinishLoadingData data: [Item]) {
//        self.dataSource.loadData(data)
//        super.model(model, didFinishLoadingData: [])
//    }

    override func didFinishLoadDataSource(_: DataSource) {
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ProducersViewController, let sender = sender as? Category {
            viewController.category = sender
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let item = self.dataSource.itemAtIndexPath(indexPath) {
            self.performSegueWithIdentifier(Constants.Segue.ShowCategory.rawValue, sender: item)
        }
    }
    
}