//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/14/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemViewControllerDelegate: class {
  func addItemViewControllerDidCancel(controller: AddItemViewController)
  func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
  
  // MARK: Outlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: AddItemViewControllerDelegate?
  
  // MARK: View Controller Lifecycle
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder() // Display keyboard when view appears
  }
  
  // MARK: Actions
  @IBAction func cancel() {
    textField.resignFirstResponder()
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    textField.resignFirstResponder()
    let item = ChecklistItem()
    item.text = textField.text!
    item.checked = false
    
    delegate?.addItemViewController(self, didFinishAddingItem: item)
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
