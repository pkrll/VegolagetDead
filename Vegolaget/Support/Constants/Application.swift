//
//  Application.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  Application specific constants.
 */
enum Application {
  /**
   *  The name of the application as set in the bundle.
   */
  static let name: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
  /**
   *  The identifier of the app bundle.
   */
  static let identifier: String = NSBundle.mainBundle().bundleIdentifier!
  /**
   *  The beginning of the URL String for Barnivore products page.
   */
  static let barnivoreProductURL: String = "http://www.barnivore.com/products/"
  
}
