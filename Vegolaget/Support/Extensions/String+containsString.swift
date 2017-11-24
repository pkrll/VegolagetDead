//
//  String.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

extension String {
  /**
   *  Compares a string to check if it contains another string.
   *  - Parameters:
   *      - string: The string to compare with.
   *      - caseInsensitive: Set true if the case should be ignore.
   */
  func containsString(_ string: String, caseInsensitive: Bool = false) -> Bool {
    var haystack = self
    var search = string
    
    if caseInsensitive {
      search = search.lowercased()
      haystack = haystack.lowercased()
    }
    
    return (haystack.range(of: search) != nil)
  }
  
}
