//
//  CoursesTableViewController.swift
//  educal
//
//  Created by Jurriaan Lindhout on 15-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    @IBOutlet var coursesTableView: UITableView!
    @IBOutlet weak var coursesSegment: UISegmentedControl!
    
    var refreshController:UIRefreshControl!
    var showableArray  = Array<PFObject>()
    var currentSegment = 0
    
    @IBAction func unwindToCoursesList(sender:UIStoryboardSegue){
        //retrieve data from database and reload tableview
        getData()
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        currentSegment = sender.selectedSegmentIndex
        getData()
    }
    
    @IBAction func getData(){
        // Clear all data
        showableArray.removeAll(keepCapacity: false)
        var allCourses:PFQuery?
        switch currentSegment {
        case 0:
            allCourses = PFQuery(className:"CourseForUser")
            allCourses?.whereKey("userObjectId", equalTo:PFUser.currentUser())
        case 1:
            allCourses = PFQuery(className:"Course")
            allCourses?.whereKey("userObjectId", equalTo:PFUser.currentUser())
        case 2:
            allCourses = PFQuery(className:"Course")
        default:
            println("No segment selected")
        }
        allCourses?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if self.currentSegment != 0 {
                    for object in objects {
                        self.showableArray.append(object as PFObject)
                    }
                } else {
                    for object in objects {
                        self.showableArray.append(object["courseObjectId"] as PFObject)
                    }
                }
                
                
                self.coursesTableView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve data from database and reload tableview
        getData()
        
        
        
        //set the pull to refresh
        self.refreshController = UIRefreshControl()
        //self.refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
    }
    
    func refresh(sender:AnyObject){
        // Code to refresh table view
        getData()
        sleep(1)
        self.refreshController.endRefreshing()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if showableArray.count != 0 {
            cell.textLabel?.text = showableArray[indexPath.row]["title"] as? String
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            showableArray[indexPath.row].deleteInBackgroundWithTarget(nil, selector: nil)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
