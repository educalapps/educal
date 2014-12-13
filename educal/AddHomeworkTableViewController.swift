//
//  AddHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 11-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddHomeworkTableViewController: UITableViewController {

    @IBOutlet var addHomeworkTable: UITableView!
    
    var personalTitle = ["Title","Description","Deadline"]
    var personalPlaceholder = ["Type your title here","Type your description here","Type your deadline here"]
    
    var courseTitle = ["Title","Description", "Group"]
    var coursePlaceholder = ["Type your title here","Type your description here", ""]
    
    var course = ["a","b","c","d","e","f"]
    
    var showableArray : [String] = []
    var showableArrayDetail : [String] = []
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentChanged(sender: AnyObject) {
        if segmentControl.selectedSegmentIndex == 0 {
            showableArray = personalTitle
            showableArrayDetail = personalPlaceholder
        } else if segmentControl.selectedSegmentIndex == 1 {
            showableArray = courseTitle
            showableArrayDetail = coursePlaceholder
        }
        
        addHomeworkTable.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        showableArray = personalTitle
        showableArrayDetail = personalPlaceholder
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return showableArray.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if showableArray[indexPath.row] == "Group" {
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if showableArray[indexPath.row] != "Group" {
            let cell:HomeworkTableViewCell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as HomeworkTableViewCell
            
            cell.titleLabel.text = showableArray[indexPath.row]
            cell.inputTextfield.placeholder = personalPlaceholder[indexPath.row]
            
            return cell
        } else{
            let cell = tableView.dequeueReusableCellWithIdentifier("addGroupCell", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = showableArray[indexPath.row]
            
            return cell
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
