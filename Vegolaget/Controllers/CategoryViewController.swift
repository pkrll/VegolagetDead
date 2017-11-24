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
    
    self.registerNib(Nib.CategoryCell.rawValue)
    self.tableView.delegate = self
    self.tableView.addSubview(self.refreshControl)
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
  
  override func didRequestRefresh(_ sender: AnyObject) {
    self.model.refreshData()
  }
    
  override func didFinishLoadDataSource(_: DataSource) {
    self.tableView.reloadData()
    self.refreshControl.endRefreshing()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? ProducersViewController, let sender = sender as? Category {
      viewController.category = sender
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    if let item = self.dataSource.itemAtIndexPath(indexPath) {
      self.performSegue(withIdentifier: Segue.ShowCategory.rawValue, sender: item)
    }
  }
  
}
