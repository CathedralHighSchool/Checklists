//
//  ViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/13/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Table View Data Source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
    
    let label = cell.viewWithTag(1000) as! UILabel
    
    if indexPath.row % 5 == 0 {
      label.text = "Walk the dog"
    } else if indexPath.row % 5 == 1 {
      label.text = "Brush my teeth"
    } else if indexPath.row % 5 == 2 {
      label.text = "Learn iOS development"
    } else if indexPath.row % 5 == 3 {
      label.text = "Soccer practice"
    } else if indexPath.row % 5 == 4 {
      label.text = "Eat ice cream"
    }
    
    return cell
  }
  
  // MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      if cell.accessoryType == .None {
        cell.accessoryType = .Checkmark
      } else {
        cell.accessoryType = .None
      }
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}
