//
//  localeSensitive.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 17/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

protocol localeSensitive {
    func compare(toString: String, withLocale locale: NSLocale, orderBy: NSComparisonResult) -> Bool
}