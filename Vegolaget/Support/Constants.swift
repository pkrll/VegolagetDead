//
//  Constants.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

public enum Constants {
  
  enum Application {
    
    static let name: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    
    static let identifier: String = NSBundle.mainBundle().bundleIdentifier!
    
  }
  
  enum UserInterface {
    /**
     *  The application's standard green color.
     */
    static let greenColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
    
    static let backButtonTitle = "Bakåt"
    
    static let scopeButtonTitles = ["Alla", "Endast veganska"]
    
  }
  
  enum Nib: String {
    
    case BaseCell
    case CategoryCell
    case ProducerCell
    case ProductCell
    case LoadingCell
    case StoreCell
    case StoreLocationCell
    
  }
  
  enum Segue: String {
    
    case ShowCategory
    case ShowProducer
    case ShowProduct
    case ShowStores
    case ShowStore
    
  }
}