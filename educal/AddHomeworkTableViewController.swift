//
//  AddHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 11-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddHomeworkTableViewController: UITableViewController, UITextFieldDelegate {

    // Variables
    var homework:PFObject?
    
    // Outlets
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextView!
    @IBOutlet weak var deadlineTextfield: UITextField!
    @IBOutlet var addHomeworkTable: UITableView!
    
    // Defaults
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (homework != nil) {
            self.navigationItem.title = homework?["title"] as? String
            titleTextfield.text = homework?["title"] as String
            descriptionTextfield.text = homework?["description"] as String
            
            // Format date
            deadlineTextfield.text = Functions.Instance().showStringFromDate("yyyy-MM-dd HH:mm", date: homework?["deadline"] as NSDate)
        }
        deadlineTextfield.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Actions
    @IBAction func donePressed(sender: AnyObject) {
        
        if !titleTextfield.text.isEmpty && !deadlineTextfield.text.isEmpty {
            // Format date
            var dateString = deadlineTextfield.text
            var timeZone = NSTimeZone(name: "GMT")
            var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.timeZone = timeZone
            var dateFromString:NSDate = dateFormatter.dateFromString(dateString)!
        
            // Add data to parse
            if homework == nil {
                homework = PFObject(className:"Homework")
            }
            homework?["title"] = titleTextfield.text
            homework?["description"] = descriptionTextfield.text
            homework?["deadline"] = dateFromString
            homework?["personal"] = true
            homework?["completed"] = false
            homework?["userObjectId"] = PFUser.currentUser()
            homework?["active"] = true
            homework?.saveEventually()
            homework?.pinInBackgroundWithName("homework", block: { (succes, error) -> Void in
                self.performSegueWithIdentifier("backToHomework", sender: sender)
            })
            
        } else{
            Functions.Instance().showAlert("Error!", description: "Fill in the required fields.")
        }
    }
    
    @IBAction func showDatepicker(sender: UITextField) {
        var DatePickerView  : UIDatePicker = UIDatePicker()
        DatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        DatePickerView.backgroundColor = UIColor.whiteColor()
        DatePickerView.minuteInterval = 5
        
        if deadlineTextfield.text != "" {
            // Set date for datepicker
            DatePickerView.setDate(Functions.Instance().showDateFromString("yyyy-MM-dd HH:mm", date: deadlineTextfield.text), animated: true)
        }
        deadlineTextfield.inputView = DatePickerView
        DatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents:UIControlEvents.ValueChanged)
    }
    
    // Custom functions
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        deadlineTextfield.text = dateFormatter.stringFromDate(sender.date)
    }
}
