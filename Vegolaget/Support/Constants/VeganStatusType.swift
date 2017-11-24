//
//  VeganStatusType.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum VeganStatusType: Int {
  
  case nonVegan  = 0
  case allVegan  = 1
  case someVegan = 2
  
  var description: String {
    var string = String()
    
    switch (self) {
    case .nonVegan:
      string = "Not Vegan Friendly"
    case .allVegan:
      string = "Vegan Friendly"
    case .someVegan:
      string = "Has Some Vegan Options"
    }
    
    return string
  }
  
}
