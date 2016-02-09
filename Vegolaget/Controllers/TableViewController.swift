//
//  TableViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
/**
 *  This class is a sub class of the View Controller class and provides extra functionality for using a table view.
 *  - Note: This class conforms to the Data Source Delegate.
 */
class TableViewController: ViewController, ModelDelegate, DataSourceDelegate, UITableViewDelegate {
  
  internal var model: Model!
  /**
   *  The data source of the table view.
   */
  internal var dataSource: DataSource!
  /**
   *  The refresh control allows the user to reload the table views content.
   *  - Note: Must be added as a sub view to the table view.
   */
  internal lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Dra ned för att ladda om")
    refreshControl.addTarget(self, action: "didRequestRefresh:", forControlEvents: .ValueChanged)
    
    return refreshControl
  }()
  /**
   *  Load the data source in this method.
   */
  func loadDataSource() {
    self.dataSource = DataSource()
    self.dataSource.delegate = self
  }
  /**
   *  Load the model in this method.
   */
  func loadModel() {
    self.model = Model()
    self.model.delegate = self
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
  
  // MARK: - Model Delegate Methods
  
  func model(_: Model, didFinishLoadingData data: [Item]) {
    self.dataSource.loadData(data)
    self.hideLoadingView()
  }
  
  func model(_: Model, didFinishLoadingWithError errorDescription: String) {
    self.hideLoadingView()
    self.showAlert(withMessage: errorDescription)
  }

  /**
   *  Invoked when the table view was pulled to refresh its content.
   *  - Note: You must add *refreshControl* as a sub view to the table view to use it.
   */
  func didRequestRefresh(sender: AnyObject) {
    self.refreshControl.endRefreshing()
  }
  /**
   *  Registers a nib object containing a cell with the table view under a specified identifier.
   *  - Note: Call this method for the table view to know which cells to use.
   */
  func registerNib(nibName: String, forCellReuseIdentifier identifier: String? = nil) {
    if self.respondsToSelector("tableView") {
      let tableView = self.valueForKey("tableView")
      let nib = UINib(nibName: nibName, bundle: nil)
      tableView?.registerNib(nib, forCellReuseIdentifier: identifier ?? nibName)
    }
  }
  
}
