//
//  LocaleSensitive.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 17/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

protocol LocaleSensitive {
  func compare(_ toString: String, withLocale locale: Locale, orderBy: ComparisonResult) -> Bool
}

infix operator <? { associativity left precedence 130 }
infix operator ?> { associativity left precedence 130 }
/**
 *  Locale sensitive (case insensitive) string comparision operator.
 *  - Note: Using locale "se".
 */
func <?<T: LocaleSensitive>(left: T, right: String) -> Bool {
  return left.compare(right, withLocale: Locale(identifier: "se"), orderBy: .orderedAscending)
}
/**
 *  Locale sensitive (case insensitive) string comparision operator.
 *  - Note: Using locale "se".
 */
func ?><T: LocaleSensitive>(left: T, right: String) -> Bool {
  return left.compare(right, withLocale: Locale(identifier: "se"), orderBy: .orderedDescending)
}

extension String: LocaleSensitive {
  /**
   *  Returns the string localized.
   */
  var localized: String {
    return NSLocalizedString(self.uppercased(), tableName: nil, bundle: Bundle.main, value: "", comment: "").capitalized
  }
  /**
   *  Compares the string using the specified options and returns the lexical ordering.
   *  - Returns: A boolean value, indicating the ordering.
   */
  func compare(_ toString: String, withLocale locale: Locale, orderBy: ComparisonResult) -> Bool {
    if self.compare(toString, options: .caseInsensitive, range: nil, locale: locale) == orderBy {
      return true
    }
    
    return false
  }
  
}
