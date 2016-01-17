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
     *  Returns the localized string.
     */
    var localized: String {
        return NSLocalizedString(self.uppercaseString, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "").capitalizedString
    }
    /**
     *  Compares a string to check if it contains another string.
     *  - Parameters:
     *      - string: The string to compare with.
     *      - caseInsensitive: Set true if the case should be ignore.
     */
    func containsString(string: String, caseInsensitive: Bool = false) -> Bool {
        var haystack = self
        var search = string
        
        if caseInsensitive {
            search = search.lowercaseString
            haystack = haystack.lowercaseString
        }
        
        return (haystack.rangeOfString(search) != nil)
    }

}

extension String: localeSensitive {
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
