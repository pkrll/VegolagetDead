//
//  Date.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

struct DateTime {
  
  let dateFormat = "yyyy-MM-dd"
  let dateLocale = "se"
  let date: String
  let time: String
  
  let isToday: Bool
  let hasPassed: Bool
  
  private let dateFormatter: NSDateFormatter
  
  init(date: String, time: String) {
    self.date = date
    self.time = time
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = self.dateFormat
    dateFormatter.locale = NSLocale(localeIdentifier: self.dateLocale)
    
    let todayString = dateFormatter.stringFromDate(NSDate())
    let definedDate = dateFormatter.dateFromString(self.date) as NSDate!
    let compareDate = dateFormatter.dateFromString(todayString) as NSDate!
    let comparision = compareDate.compare(definedDate).rawValue
    
    self.isToday = comparision == 0
    self.hasPassed = comparision > 0
    
    self.dateFormatter = dateFormatter
  }
  
  func weekDay() -> String {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let date = self.dateFormatter.dateFromString(self.date) as NSDate!
    let components = calendar.components(.Weekday, fromDate: date)
    
    return WeekDay(rawValue: components.weekday)?.localized ?? ""
  }
  
  func shortFormDate() -> String {
    let components = self.date.componentsSeparatedByString("-")
    let month = Month(rawValue: Int(components[1])!)?.localized ?? ""
    return components[2] + " " + month
  }
  
}