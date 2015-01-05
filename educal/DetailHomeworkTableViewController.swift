//
//  DetailHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 15-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

var homeworkTitle:String?


class DetailHomeworkTableViewController: UITableViewController {
    
    var homeworkObject:PFObject?
    
    @IBOutlet var detailView: UITableView!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var finshedSwitch: UISwitch!
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            if homeworkObject?["personal"] as Bool == true {
                homeworkObject?["completed"] = true
                homeworkObject?["completedAt"] = NSDate()
                homeworkObject?.saveEventually()
                homeworkObject?.pinInBackgroundWithBlock() {
                    (succeeded:Bool, error:NSError!) in
                    
                }
            }
        } else{
            if homeworkObject?["personal"] as Bool == true {
                homeworkObject?["completed"] = false
                homeworkObject?.saveEventually()
                homeworkObject?.pinInBackgroundWithBlock() {
                    (succeeded:Bool, error:NSError!) in
                    
                }
            }
        }
    }
    
    func setValues(){
        
        // Dateformat
        let newDate = Functions.Instance().showStringFromDate("d MMM-HH:mm", date: homeworkObject?["deadline"] as NSDate)
        
        // Split date by day and month
        var newDateArray = split(newDate) {$0 == "-"}
        var onlyDateArray = split(newDateArray[0]) {$0 == " "}
        
        // Set fields
        dateDayLabel?.text = onlyDateArray[0].uppercaseString
        dateMonthLabel?.text = onlyDateArray[1].uppercaseString
        homeLabel?.text = newDateArray[1]
        nameLabel?.text = homeworkObject?["title"] as? String
        descriptionTextview.text = homeworkObject?["description"] as? String
        if homeworkObject?["completed"] as NSObject == true {
            finshedSwitch.setOn(true, animated: true)
        }

        
        // Hide unused cells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        // Add barbutton when is it your homework
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editButtonPressed"), animated: true)

    }
    
    func editButtonPressed(){
        performSegueWithIdentifier("editHomework", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editHomework"{
            var dc = segue.destinationViewController as AddHomeworkTableViewController
            dc.homework = homeworkObject
        }
        
    }

}
