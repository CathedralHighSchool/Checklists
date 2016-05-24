//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Marisa Toodle on 5/23/16.
//  Copyright © 2016 marisalaneous. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.enabled = true
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    textField.resignFirstResponder()
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    textField.resignFirstResponder()
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
    } else {
      let checklist = Checklist(name: textField.text!)
      delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    
    doneBarButton.enabled = (newText.length > 0)
    return true
  }
  
}