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
        DataProvider.Instance().fetchHomeworkData(){
            (result:Array<Array<Array<PFObject>>>) in
            self.homeworkTableView.reloadData()
        }
        homeworkTableView.reloadData()
    }
    
    // Custom functions
    
    func refresh(sender:AnyObject){
        // Get new data
        DataProvider.Instance().fetchHomeworkData(){
            (result:Array<Array<Array<PFObject>>>) in
            self.homeworkTableView.reloadData()
            println("reloading")
        }
        
        // Keeps the refresher a second longer
        sleep(1)
        
        // Stop refreshing
        self.refreshController.endRefreshing()
    }
    

    
    // Default
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "reloadTable", userInfo: nil, repeats: false)
        
        
        // Pull to refresh
        self.refreshController = UIRefreshControl()
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
    }
    
    func reloadTable(){
        homeworkTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tableview

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Uncompleted"
        } else{
            return "Completed"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataProvider.Instance().homeworkTableContent.count == 0 {
            return 0
        } else {
            return DataProvider.Instance().homeworkTableContent[activeSegment][section].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as CustomTableViewCell
        
        var thisHomework = DataProvider.Instance().homeworkTableContent[activeSegment][indexPath.section][indexPath.row] as PFObject
        
        // Set title of tablecell
        cell.homeworkTitleLabel?.text = thisHomework["title"] as? String
        
        // Set subtitle of tablecell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
        let newDate = dateFormatter.stringFromDate(thisHomework["deadline"] as NSDate)
        
        // Set accessorytype
        if thisHomework["completed"] as NSObject == true {
            cell.tintColor = UIColor.grayColor()
            cell.accessoryType = .Checkmark
            cell.dateBackgroundView.backgroundColor = UIColor.grayColor()
            cell.homeworkDeadlineLabel.textColor = UIColor.grayColor()
            cell.homeworkTitleLabel.textColor = UIColor.grayColor()
        } else{
            cell.accessoryType = .DisclosureIndicator
            cell.dateBackgroundView.backgroundColor = Functions.Instance().UIColorFromRGB(0xd1190d)
            cell.homeworkDeadlineLabel.textColor = Functions.Instance().UIColorFromRGB(0xd1190d)
            cell.homeworkTitleLabel.textColor = UIColor.blackColor()
        }
        
        // Split date by day and month
        var newDateArray = split(newDate) {$0 == "-"}
        var onlyDate = newDateArray[0]
        var onlyTime = newDateArray[1]
        
        var onlyDateArray = split(onlyDate) {$0 == " "}
        cell.dateDayLabel?.text = onlyDateArray[0].uppercaseString
        cell.dateMonthLabel?.text = onlyDateArray[1].uppercaseString
        cell.homeworkDeadlineLabel?.text = onlyTime
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            let DetailViewController = segue.destinationViewController as DetailHomeworkTableViewController
            DetailViewController.title = DataProvider.Instance().homeworkTableContent[activeSegment][sender.section][sender.row]["title"] as? String
            DetailViewController.homeworkObject = DataProvider.Instance().homeworkTableContent[activeSegment][sender.section][sender.row]
        }
    }
}
