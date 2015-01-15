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
    var tableContent = Array<Array<PFObject>>()
    var currentSegment = 0
    var selectedCourse:PFObject?
    var coursesInTable:Array<Array<PFObject>>?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func didFinishFetchingString(text: String) {
        println(text)
    }
    
    @IBAction func unwindToCoursesList(sender:UIStoryboardSegue){
        //reload tableview
        
        coursesTableView.reloadData()
    }
    
    @IBAction func addCoursePressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("courseDetailSegue", sender: sender)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        currentSegment = sender.selectedSegmentIndex
        coursesTableView.reloadData()
    }

    @IBAction func signOutPressed(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default , handler: {
            (action: UIAlertAction!) in
            
            // remove all local objects
            DataProvider.Instance().removeAllLocalData()
            
            // Sign out user
            PFUser.logOut()
            Functions.Instance().showLoginViewController(self)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        //set the pull to refresh
        self.refreshController = UIRefreshControl()
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
    }
    
    override func viewWillAppear(animated: Bool) {
        coursesInTable = [Array<PFObject>(), Array<PFObject>(), Array<PFObject>()]
        self.coursesTableView.reloadData()
    }
    
    func refresh(sender:AnyObject){
        // Code to refresh table view
        DataProvider.Instance().updateAllLocalData()
        coursesTableView.reloadData()
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
        

        switch currentSegment {
        case 0:
            var count = DataProvider.Instance().countJoinedCourses()
            for var i = 0; i < count; i++ {
                coursesInTable?[currentSegment].append(PFObject(className: "Course"))
            }
            return count
        case 1:
            var count = DataProvider.Instance().countHostedCourses()
            for var i = 0; i < count; i++ {
                coursesInTable?[currentSegment].append(PFObject(className: "Course"))
            }
            return count
        case 2:
            var count = DataProvider.Instance().countAllCourses()
            for var i = 0; i < count; i++ {
                coursesInTable?[currentSegment].append(PFObject(className: "Course"))
            }
            return count
        default:
            println("no segment selected")
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as UITableViewCell
        
        
        switch currentSegment {
        case 0:
            DataProvider.Instance().getJoinedCourse(indexPath.row, completion: { (object) -> Void in
                var title = object["title"] as String
                cell.textLabel?.text = title
                self.coursesInTable?[self.currentSegment][indexPath.row] = object
            })
        case 1:
            DataProvider.Instance().getHostedCourse(indexPath.row, completion: { (object) -> Void in
                var title = object["title"] as String
                cell.textLabel?.text = title
                self.coursesInTable?[self.currentSegment][indexPath.row] = object
            })
        case 2:
            DataProvider.Instance().getCourse(indexPath.row, completion: { (object) -> Void in
                var title = object["title"] as String
                cell.textLabel?.text = title
                self.coursesInTable?[self.currentSegment][indexPath.row] = object
            })
        default:
            println("no segment selected")
        }
        
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCourse = coursesInTable?[currentSegment][indexPath.row]
        performSegueWithIdentifier("courseDetailSegue", sender: self)
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            var selectedCourse = coursesInTable?[currentSegment][indexPath.row]
            if selectedCourse?["userObjectId"] as PFUser == PFUser.currentUser() {
                selectedCourse?.deleteEventually()
                selectedCourse?.unpinWithName("course")
                activityIndicator.startAnimating()
                
                Functions.Instance().delay(0.8) {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                Functions.Instance().showAlert("Permission denied", description: "You can't delete this course, because you are not the host")
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseDetailSegue" && selectedCourse != nil {
            var dc = segue.destinationViewController as AddCourseTableViewController
            dc.course = selectedCourse
            selectedCourse = nil
        }
        
    }

}
