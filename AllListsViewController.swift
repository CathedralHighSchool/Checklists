//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/20/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  var dataModel: DataModel!
  
  
  // MARK: View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedChecklist
    // Determine if index is valid, if not do not segue
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destinationViewController as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
  
  // MARK: Helper method
  func cellForTableView(tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
    }
  }

  // MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return dataModel.lists.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

    let cell = cellForTableView(tableView)
    
    let checklist = dataModel.lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton
    
    if checklist.items.isEmpty {
      cell.detailTextLabel!.text = "(No items)"
    } else {
      let count = checklist.countUncheckedItems()
      if count == 0 {
        cell.detailTextLabel!.text = "All Done!"
      } else {
        cell.detailTextLabel!.text = "\(count) Remaining"
      }
    }
    
    cell.imageView!.image = UIImage(named: checklist.iconName)
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    dataModel.lists.removeAtIndex(indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  // MARK: Table View Delegate Methods
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    dataModel.indexOfSelectedChecklist = indexPath.row
    
    let checklist = dataModel.lists[indexPath.row]
    performSegueWithIdentifier("ShowChecklist", sender: checklist)
  }
  
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
    let controller = navigationController.topViewController as! ListDetailViewController
    
    controller.delegate = self
    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    
    presentViewController(navigationController, animated: true, completion: nil)
  }
  
  
  // MARK: - ListDetailViewController Delegate Methods
  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {     
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - UINavigationController Delegate Methods
  // If the back button was pressed, the new view controller is AllListsViewController itself and you set the “ChecklistIndex” value in NSUserDefaults to -1, meaning that no checklist is currently selected.
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
  
}