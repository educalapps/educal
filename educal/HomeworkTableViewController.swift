//
//  HomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class HomeworkTableViewController: UITableViewController {
    
    // Variables
    var refreshController:UIRefreshControl!
    var showableArray = Array<PFObject>()
    var thisArray = Array<PFObject>()
    var nextArray = Array<PFObject>()
    var allArray = Array<PFObject>()
    var activeSegment:Int = 0
    
    // Outlets
    @IBOutlet var homeworkTableView: UITableView!
    
    // Actions
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        activeSegment = sender.selectedSegmentIndex
        getData()
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
    
    @IBAction func unwindToHomework(segue: UIStoryboardSegue) {
        getData()
    }
    
    // Custom functions
    
    func refresh(sender:AnyObject){
        // Get new data
        getData()
        
        // Keeps the refresher a second longer
        sleep(1)
        
        // Stop refreshing
        self.refreshController.endRefreshing()
    }
    
    @IBAction func getData(){
        // Clear all data
        showableArray.removeAll(keepCapacity: false)
        
        // Get next week and the week after that
        var nowDate = NSDate()
        var oneWeekFurther = nowDate.dateByAddingTimeInterval(60 * 60 * 24 * 7)
        var twoWeekFurther = nowDate.dateByAddingTimeInterval(60 * 60 * 24 * 14)
        
        var allHomework = PFQuery(className:"Homework")
        allHomework.whereKey("userObjectId", equalTo:PFUser.currentUser())
        
        switch(activeSegment){
            case 0:
                allHomework.whereKey("deadline", greaterThan: nowDate )
                allHomework.whereKey("deadline", lessThan: oneWeekFurther )
                allHomework.orderByDescending("deadline")
            case 1:
                allHomework.whereKey("deadline", greaterThan: oneWeekFurther )
                allHomework.whereKey("deadline", lessThan: twoWeekFurther )
                allHomework.orderByDescending("deadline")
            default:
                allHomework.orderByDescending("deadline")
        }
        
        // Get elements
        allHomework.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                // Add object to array
                for object in objects {
                    self.showableArray.append(object as PFObject)
                }
                
                // Reload tableview
                self.homeworkTableView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    // Default
    
    override func viewWillAppear(animated: Bool) {
        homeworkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
        // Pull to refresh
        self.refreshController = UIRefreshControl()
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tableview

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showableArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as UITableViewCell
        
        let cell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as CustomTableViewCell
        
        // Set title of tablecell
        cell.homeworkTitleLabel?.text = showableArray[indexPath.row]["title"] as? String
        //cell.textLabel?.text = showableArray[indexPath.row]["title"] as? String
        
        // Set subtitle of tablecell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM" // superset of OP's format
        let str = dateFormatter.stringFromDate(showableArray[indexPath.row]["deadline"] as NSDate)
        
        // Split date by day and month
        var strArray = split(str) {$0 == " "}
        
        cell.dateDayLabel?.text = strArray[0].uppercaseString
        cell.dateMonthLabel?.text = strArray[1].uppercaseString
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            showableArray[indexPath.row].deleteInBackgroundWithTarget(nil, selector: nil)
            
            showableArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            let DetailViewController = segue.destinationViewController as DetailHomeworkTableViewController
            DetailViewController.title = showableArray[sender.row]["title"] as? String
            DetailViewController.homeworkObject = showableArray[sender.row]
        }
    }
}
