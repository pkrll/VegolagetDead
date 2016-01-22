//
//  ApplicationShortcutType.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 22/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum ApplicationShortcutType: String {
  
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

