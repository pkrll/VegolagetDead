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
