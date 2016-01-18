//
//  SearchDataSourceDelegate.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

protocol SearchDataSourceDelegate: DataSourceDelegate {
  var searchController: UISearchController { get }
  func didFinishFilterDataSource(_:SearchDataSource)
}