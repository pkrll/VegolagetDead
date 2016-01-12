//
//  APIEndPoint.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

public enum APIEndPoint {
    
    private static var address = ""
    private static var version = "1.0"
    private static var BaseURL: String {
        return self.address + self.version
    }
    
    
    enum Categories: String {
        
        case Root = "/categories/"
        
        var string: String {
            return APIEndPoint.BaseURL + self.rawValue
        }
        
    }

}