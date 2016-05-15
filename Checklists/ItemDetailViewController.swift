//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/14/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
  
  // MARK: Properties
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  // MARK: View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.enabled = true
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder() // Display keyboard when view appears
  }
  
  // MARK: Actions
  @IBAction func cancel() {
    textField.resignFirstResponder()
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    textField.resignFirstResponder()
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      item.checked = false
      
      delegate?.itemDetailViewController(self, didFinishAddingItem: item)
    }
  }
  
  // MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  // MARK: Text Field Delegate
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    
    // Done bar button is disabled if textField is empty
    doneBarButton.enabled = (newText.length > 0)
    return true
  }
}
