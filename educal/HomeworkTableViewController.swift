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
    var activeSegment:Int = 0
    var homeworkInTable = Array<PFObject>()
    var oneWeekFurther = NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 7)
    var twoWeekFurther = NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 14)
    
    // Outlets
    @IBOutlet var homeworkTableView: UITableView!
    
    // Actions
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        activeSegment = sender.selectedSegmentIndex
        homeworkTableView.reloadData()
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
        // Get new data

        homeworkTableView.reloadData()
    }
    
    @IBAction func addHomeworkPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editHomework", sender: self)
    }
    // Custom functions
    
    func refresh(sender:AnyObject){
        // Get new data
        
        // Keeps the refresher a second longer
        sleep(1)
        
        // Stop refreshing
        self.refreshController.endRefreshing()
    }
    

    
    // Default
    
    override func viewWillAppear(animated: Bool) {
        homeworkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        homeworkInTable.removeAll(keepCapacity: false)
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch activeSegment {
            case 0:
                var query1 = PFQuery(className: "Homework")
                query1.fromLocalDatastore()
                query1.whereKey("active", equalTo: true)
                query1.whereKey("deadline", greaterThan: NSDate() )
                query1.whereKey("deadline", lessThan: oneWeekFurther )
                return query1.countObjects()
            case 1:
                var query1 = PFQuery(className: "Homework")
                query1.fromLocalDatastore()
                query1.whereKey("active", equalTo: true)
                query1.whereKey("deadline", greaterThan: oneWeekFurther )
                query1.whereKey("deadline", lessThan: twoWeekFurther )
                return query1.countObjects()
            case 2:
                var query1 = PFQuery(className: "Homework")
                query1.fromLocalDatastore()
                query1.whereKey("active", equalTo: true)
                return query1.countObjects()
            default:
                return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as CustomTableViewCell
        
        switch activeSegment {
            case 0:
                var query = PFQuery(className: "Homework")
                query.fromLocalDatastore()
                query.whereKey("active", equalTo: true)
                query.addAscendingOrder("deadline")
                query.addAscendingOrder("completed")
                query.whereKey("deadline", greaterThan: NSDate() )
                query.whereKey("deadline", lessThan: oneWeekFurther )
                query.findObjectsInBackgroundWithBlock(){
                    (objects:[AnyObject]?, error:NSError!) in
                    
                    var myObjects = objects as [PFObject]?
                    
                    self.homeworkInTable = myObjects!
                    
                    // Set title of tablecell
                    cell.homeworkTitleLabel?.text = myObjects?[indexPath.row]["title"] as? String
                    
                    // Set subtitle of tablecell
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
                    let newDate = dateFormatter.stringFromDate(myObjects?[indexPath.row]["deadline"] as NSDate)
                    
                    // Split date by day and month
                    var newDateArray = split(newDate) {$0 == "-"}
                    var onlyDate = newDateArray[0]
                    var onlyTime = newDateArray[1]
                    
                    var onlyDateArray = split(onlyDate) {$0 == " "}
                    cell.dateDayLabel?.text = onlyDateArray[0].uppercaseString
                    cell.dateMonthLabel?.text = onlyDateArray[1].uppercaseString
                    cell.homeworkDeadlineLabel?.text = onlyTime
                    
                    if myObjects?[indexPath.row]["completed"] as Bool == true {
                        cell.accessoryType = .Checkmark
                    } else {
                        cell.accessoryType = .None
                    }
                    
                }
            case 1:
                var query = PFQuery(className: "Homework")
                query.fromLocalDatastore()
                query.whereKey("active", equalTo: true)
                query.addAscendingOrder("deadline")
                query.addAscendingOrder("completed")
                query.whereKey("deadline", greaterThan: oneWeekFurther )
                query.whereKey("deadline", lessThan: twoWeekFurther )
                query.findObjectsInBackgroundWithBlock(){
                    (objects:[AnyObject]?, error:NSError!) in
                    
                    var myObjects = objects as [PFObject]?
                    
                    self.homeworkInTable = myObjects!
                    
                    // Set title of tablecell
                    cell.homeworkTitleLabel?.text = myObjects?[indexPath.row]["title"] as? String
                    
                    // Set subtitle of tablecell
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
                    let newDate = dateFormatter.stringFromDate(myObjects?[indexPath.row]["deadline"] as NSDate)
                    
                    // Split date by day and month
                    var newDateArray = split(newDate) {$0 == "-"}
                    var onlyDate = newDateArray[0]
                    var onlyTime = newDateArray[1]
                    
                    var onlyDateArray = split(onlyDate) {$0 == " "}
                    cell.dateDayLabel?.text = onlyDateArray[0].uppercaseString
                    cell.dateMonthLabel?.text = onlyDateArray[1].uppercaseString
                    cell.homeworkDeadlineLabel?.text = onlyTime
                    
                    if myObjects?[indexPath.row]["completed"] as Bool == true {
                        cell.accessoryType = .Checkmark
                    } else {
                        cell.accessoryType = .None
                    }
                    
                }
            case 2:
                var query = PFQuery(className: "Homework")
                query.fromLocalDatastore()
                query.whereKey("active", equalTo: true)
                query.addAscendingOrder("deadline")
                query.addAscendingOrder("completed")
                query.findObjectsInBackgroundWithBlock(){
                    (objects:[AnyObject]?, error:NSError!) in
                    
                    var myObjects = objects as [PFObject]?
                    
                    self.homeworkInTable = myObjects!
                    
                    // Set title of tablecell
                    cell.homeworkTitleLabel?.text = myObjects?[indexPath.row]["title"] as? String
                    
                    // Set subtitle of tablecell
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
                    let newDate = dateFormatter.stringFromDate(myObjects?[indexPath.row]["deadline"] as NSDate)
                    
                    // Split date by day and month
                    var newDateArray = split(newDate) {$0 == "-"}
                    var onlyDate = newDateArray[0]
                    var onlyTime = newDateArray[1]
                    
                    var onlyDateArray = split(onlyDate) {$0 == " "}
                    cell.dateDayLabel?.text = onlyDateArray[0].uppercaseString
                    cell.dateMonthLabel?.text = onlyDateArray[1].uppercaseString
                    cell.homeworkDeadlineLabel?.text = onlyTime
                    
                    if myObjects?[indexPath.row]["completed"] as Bool == true {
                        cell.accessoryType = .Checkmark
                    } else {
                        cell.accessoryType = .None
                    }
                    
                }
            default:
                println("no segment")
        }
        
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            var thisHomework = DataProvider.Instance().homeworkTableContent[activeSegment][indexPath.section][indexPath.row] as PFObject
            
            thisHomework.deleteInBackgroundWithTarget(nil, selector: nil)
            
            DataProvider.Instance().homeworkTableContent[activeSegment][indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
*/

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            let DetailViewController = segue.destinationViewController as DetailHomeworkTableViewController
            DetailViewController.title = homeworkInTable[sender.row]["title"] as? String
            DetailViewController.homeworkObject = homeworkInTable[sender.row]
        }
    }
}
