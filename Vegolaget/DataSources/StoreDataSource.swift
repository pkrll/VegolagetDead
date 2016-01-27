//
//  StoreDataSource.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 27/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class StoreDataSource: DataSource {
  
  internal var dateTime = [DateTime]()
  
  func loadData(data: [DateTime]) {
    self.dateTime = data
    self.delegate?.didFinishLoadDataSource(self)
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dateTime.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Nib.OpenHourCell.rawValue)!
    let item: (text: String, time: String, color: UIColor) = {
      var color: UIColor
      let item = self.dateTime[indexPath.row]
      let text = (item.isToday) ? "Today".localized : item.weekDay().localized + ", " + item.day() + " " + item.month().localized.lowercaseString
      var time = item.time

      if time == "00:00-00:00" {
        time = "Closed".localized
        color = UIColor.redColor()
      } else {
        color = UIColor.blackColor()
      }
      
      let label = (text: text, time: time, color: color)
      return label
    }()

    if let view = cell.viewWithTag(100) as? UILabel {
      view.text = item.text
      view.textColor = item.color
    }

    if let view = cell.viewWithTag(101) as? UILabel {
      view.text = item.time
      view.textColor = item.color
    }

    return cell
  }
  
}
