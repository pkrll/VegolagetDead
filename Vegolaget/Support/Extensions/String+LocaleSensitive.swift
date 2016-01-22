//
//  LocaleSensitive.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 17/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

protocol LocaleSensitive {
  func compare(toString: String, withLocale locale: NSLocale, orderBy: NSComparisonResult) -> Bool
}

infix operator <? { associativity left precedence 130 }
infix operator ?> { associativity left precedence 130 }
/**
 *  Locale sensitive (case insensitive) string comparision operator.
 *  - Note: Using locale "se".
 */
func <?<T: LocaleSensitive>(left: T, right: String) -> Bool {
  return left.compare(right, withLocale: NSLocale(localeIdentifier: "se"), orderBy: .OrderedAscending)
}
/**
 *  Locale sensitive (case insensitive) string comparision operator.
 *  - Note: Using locale "se".
 */
func ?><T: LocaleSensitive>(left: T, right: String) -> Bool {
  return left.compare(right, withLocale: NSLocale(localeIdentifier: "se"), orderBy: .OrderedDescending)
}

extension String: LocaleSensitive {
  /**
   *  Returns the string localized.
   */
  var localized: String {
    return NSLocalizedString(self.uppercaseString, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "").capitalizedString
  }
  /**
   *  Compares the string using the specified options and returns the lexical ordering.
   *  - Returns: A boolean value, indicating the ordering.
   */
  func compare(toString: String, withLocale locale: NSLocale, orderBy: NSComparisonResult) -> Bool {
    if self.compare(toString, options: .CaseInsensitiveSearch, range: nil, locale: locale) == orderBy {
      return true
    }
    
    return false
  }
  
}
