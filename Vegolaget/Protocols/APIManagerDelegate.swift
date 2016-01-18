//
//  APIManagerDelegate.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

protocol APIManagerDelegate: class {
  func manager(_: APIManager, didCompleteRequest response: APIResponse)
  func manager(_: APIManager, failedRequest response: APIResponse)
}