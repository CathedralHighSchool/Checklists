//
//  ViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/13/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

  var items: [ChecklistItem]
  
  required init?(coder aDecoder: NSCoder) {
    items = [ChecklistItem]()
    super.init(coder: aDecoder)
    loadChecklistItems()
    
    print("Documents folder is \(documentsDirectory())")
    print("Data file path is \(dataFilePath())")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  // MARK: - Methods
  
  // Set the text for the cell
  func configureTextForCell(cell: UITableViewCell, withCheckListItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
  
  // Set checkmark for cell
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel
    label.text = item.checked ? "√" : ""
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let navigationController = segue.destinationViewController as! UINavigationController
    let controller = navigationController.topViewController as! ItemDetailViewController
    controller.delegate = self
    
    if segue.identifier == "EditItem" {
      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }
    }
  }
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
  }
    
  func dataFilePath() -> String {
    return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
  }
  
  func saveChecklistItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadChecklistItems() {
    let path = dataFilePath()
    
    // Check whether Checklists.plist exists, and if so, grab and decode data
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
      }
    }
  }
  
  // MARK: - Table View Data Source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
    let item = items[indexPath.row]
    
    configureTextForCell(cell, withCheckListItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    items.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    saveChecklistItems()
  }
  
  // MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      let item = items[indexPath.row]
      item.toggleChecked()
      
      configureCheckmarkForCell(cell, withChecklistItem: item)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    saveChecklistItems()
  }
  
  // MARK: Add Item View Controller Delegate
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
    // Calculate what the index of the new row in the array should be, then add new item to array
    let newRowIndex = items.count
    items.append(item)
    
    // Make an NSIndexPath object that points to the new row
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    
    // Tell table view to insert the new row
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    if let index = items.indexOf(item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withCheckListItem: item)
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }

}

