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
    var homeworkInTable:Array<Array<Array<PFObject>>>?
    
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
        homeworkInTable = [[Array<PFObject>(), Array<PFObject>()],[Array<PFObject>(), Array<PFObject>()],[Array<PFObject>(), Array<PFObject>()]]
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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        
        switch section {
            case 0:
                return ""
            case 1:
                return "Complete"
            default:
                return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch activeSegment {
            case 0:
                if section == 0 {
                    var count = DataProvider.Instance().countHomeworkForThisWeek(false)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                } else {
                    var count = DataProvider.Instance().countHomeworkForThisWeek(true)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                }
            case 1:
                if section == 0 {
                    var count = DataProvider.Instance().countHomeworkForNextWeek(false)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                } else {
                    var count = DataProvider.Instance().countHomeworkForNextWeek(true)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                }
            case 2:
                if section == 0 {
                    var count = DataProvider.Instance().countHomeworkForAll(false)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                } else {
                    var count = DataProvider.Instance().countHomeworkForAll(true)
                    for var i = 0; i < count; i++ {
                        homeworkInTable?[activeSegment][section].append(PFObject(className: "Homework"))
                    }
                    
                    return count
                }
            default:
                return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        var cell:CustomTableViewCell?
        
        switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as? CustomTableViewCell
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("completeCell", forIndexPath: indexPath) as? CustomTableViewCell
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as? CustomTableViewCell
        }
        
        switch activeSegment {
            case 0:
                if indexPath.section == 0 {
                    DataProvider.Instance().getHomeworkForRowForThisWeek(indexPath.row, completed: false, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                } else {
                    DataProvider.Instance().getHomeworkForRowForThisWeek(indexPath.row, completed: true, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                }
            case 1:
                if indexPath.section == 0 {
                    DataProvider.Instance().getHomeworkForRowForNextWeek(indexPath.row, completed: false, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                } else {
                    DataProvider.Instance().getHomeworkForRowForNextWeek(indexPath.row, completed: true, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                }
            case 2:
                if indexPath.section == 0 {
                    DataProvider.Instance().getHomeworkForRowForAll(indexPath.row, completed: false, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                } else {
                    DataProvider.Instance().getHomeworkForRowForAll(indexPath.row, completed: true, completion: { (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void in
                        cell?.homeworkTitleLabel.text = title
                        cell?.dateDayLabel.text = dateNr
                        cell?.dateMonthLabel.text = dateName
                        cell?.homeworkDeadlineLabel.text = time
                        self.homeworkInTable?[self.activeSegment][indexPath.section][indexPath.row] = object
                    })
                }
            default:
                println("no segment")
        }
        
        
        
        
        return cell!
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
            DetailViewController.homeworkObject = homeworkInTable?[activeSegment][sender.section][sender.row]
            println(activeSegment)
            println(sender.section)
            println(sender.row)
        }
    }
}
