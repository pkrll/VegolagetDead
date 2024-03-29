//
//  Font.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 31/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

enum Font: String {

  enum FontStyle: String {
    case Regular
    case Light
    case Thin
  }
  
  case Roboto
  
  func withStyle(_ style: FontStyle, size: CGFloat) -> UIFont? {
    let fontName = self.rawValue + "-" + style.rawValue
    return UIFont(name: fontName, size: size)
  }

}
