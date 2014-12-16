//
//  HomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class HomeworkTableViewController: UITableViewController {
    
    @IBOutlet weak var homeworkSegment: UISegmentedControl!
    var refreshController:UIRefreshControl!
    
    var showableArray : [String] = []
    
    @IBOutlet var homeworkTableView: UITableView!

    @IBAction func segmentChanged(sender: AnyObject) {
//        if homeworkSegment.selectedSegmentIndex == 0 {
//            showableArray = array1
//        } else if homeworkSegment.selectedSegmentIndex == 1 {
//            showableArray = array2
//        } else if homeworkSegment.selectedSegmentIndex == 2 {
//            showableArray = array3
//        }
        
        homeworkTableView.reloadData()
        //println(homeworkSegment.selectedSegmentIndex)
    }
    @IBAction func signOutPressed(sender: AnyObject) {
        var alert = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default , handler: {
            (action: UIAlertAction!) in
            
            // Sign out user
            PFUser.logOut()
            Functions.Instance().showLoginViewController(self)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func refresh(sender:AnyObject){
        // Code to refresh table view
        self.getData()
        sleep(1)
        self.refreshController.endRefreshing()
    }
    
    @IBAction func getData(){
        // Clear all data
        showableArray.removeAll(keepCapacity: false)
        
        var allHomework = PFQuery(className:"Homework")
        allHomework.whereKey("userObjectId", equalTo:PFUser.currentUser().objectId)
        allHomework.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                if(objects.count == 0){
                    self.showableArray.append("No homework found")
                }
                
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    self.showableArray.append(object["title"] as String)
                }
                
                self.homeworkTableView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        homeworkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
        self.refreshController = UIRefreshControl()
        //self.refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = showableArray[indexPath.row]
        
//        if showableArray[indexPath.row] == "No homework found" {
//            cell.accessoryType = .None
//        }

        return cell
    }
    
    @IBAction func unwindToHomework(segue: UIStoryboardSegue) {
        self.getData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeworkTitle = showableArray[indexPath.row]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //println("Delete: \(indexPath.row)")
            showableArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
