//
//  AppShortcutType.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  This enum represents the different application short cut types.
 */
enum AppShortcutType: String {
  
  case Nearby
  case Search
  
  init?(rawValue: String) {
    if let rawValue = rawValue.componentsSeparatedByString(".").last {
      switch rawValue {
      case "Nearby":
        self = .Nearby
      case "Search":
        self = .Search
      default:
        return nil
      }
    } else {
      return nil
    }
  }
  
}