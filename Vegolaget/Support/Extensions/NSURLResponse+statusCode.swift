//
//  NSURLResponse+statusCode.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

extension NSURLResponse {
    /**
     *  The receiver’s HTTP status code.
     *  - Returns: The status code or 0 on error.
     */
    var statusCode: Int {
        if let httpURLResponse = self as? NSHTTPURLResponse {
            return httpURLResponse.statusCode
        }
        
        return 0
    }
    /**
     *  All HTTP header fields of the receiver.
     *  - Returns: A dictionary with string keys and values.
     */
    var allHeaders: Dictionary<String, String> {
        if let httpURLResponse = self as? NSHTTPURLResponse {
            if let headerFields = httpURLResponse.allHeaderFields as? Dictionary<String, String> {
                return headerFields
            }
        }
        
        return [:]
    }
    
}