//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/14/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import Foundation

class ChecklistItem {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
}
