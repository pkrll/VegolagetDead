//
//  ModelDelegate.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

protocol ModelDelegate: class {
  func model(_: Model, didFinishLoadingData data: [Item])
  func model(_: Model, didFinishLoadingWithError errorDescription: String)
}