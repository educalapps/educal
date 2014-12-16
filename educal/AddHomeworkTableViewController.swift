//
//  AddHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 11-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddHomeworkTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextfield: UITextField!

    @IBOutlet weak var descriptionTextfield: UITextView!
    
    @IBOutlet weak var datepickerCell: UITableViewCell!
    @IBOutlet weak var deadlineTextfield: UITextField!
    @IBOutlet var addHomeworkTable: UITableView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    @IBAction func donePressed(sender: AnyObject) {
        
        if !titleTextfield.text.isEmpty || !deadlineTextfield.text.isEmpty {
            // Format date
            var dateString = deadlineTextfield.text
            var dateFormatter = NSDateFormatter()
            var timeZone = NSTimeZone(name: "GMT")
        
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = timeZone
        
            var dateFromString:NSDate = dateFormatter.dateFromString(dateString)!
        
            // Add data to parse
            var homework = PFObject(className:"Homework")
            homework["title"] = titleTextfield.text
            homework["description"] = descriptionTextfield.text
            homework["deadline"] = dateFromString
            homework["personal"] = true
            homework["userObjectId"] = PFUser.currentUser()
            homework.saveInBackgroundWithTarget(nil, selector: nil)
        
            performSegueWithIdentifier("backToHomework", sender: sender)
        } else{
            Functions.Instance().showAlert("Error!", description: "Fill in the required fields.")
        }
    }
    @IBAction func dateChanged(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        var strDate = dateFormatter.stringFromDate(deadlinePicker.date)
        deadlineTextfield.text = strDate
    }
    
    @IBAction func showDatepicker(sender: AnyObject) {
        datepickerCell.hidden = false
    }
    
    @IBAction func removeDatepicker(sender: AnyObject) {
        datepickerCell.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datepickerCell.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 3
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
