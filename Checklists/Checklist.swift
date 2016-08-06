//
//  Checklist.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/22/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
  var name = ""
  var iconName: String
  var items = [ChecklistItem]()
  
  convenience init(name: String) {
    self.init(name: name, iconName: "No Icon")
  }
  
  init(name: String, iconName: String) {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObjectForKey("Name") as! String
    items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
    iconName = aDecoder.decodeObjectForKey("IconName") as! String
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "Name")
    aCoder.encodeObject(items, forKey: "Items")
    aCoder.encodeObject(iconName, forKey: "IconName")
  }
  
 
  /*
  func countUncheckedItems() -> Int {
    var count = 0
    for item in items where !item.checked {
      count += 1
    }
    return count
  }
 */
  
  // The above code written the 'swifty' way
  func countUncheckedItems() -> Int {
    return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
  }
}
