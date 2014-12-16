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
    
    @IBAction func unwindToCoursesList(sender:UIStoryboardSegue){
        //retrieve data from database and reload tableview
        getData()
    }
    
    @IBAction func addCoursePressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("courseDetailSegue", sender: sender)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        currentSegment = sender.selectedSegmentIndex
        coursesTableView.reloadData()
    }
    
    @IBAction func getData(){
        // Clear tablecontent array
        tableContent.removeAll(keepCapacity: false)
        
        for segment in 1...coursesSegment.numberOfSegments {
            tableContent.append(Array<PFObject>())
        }
        
        for segment in 1...coursesSegment.numberOfSegments {
            var courses = Array<PFObject>()
            
            switch segment {
            case 1:
                var joinedCourses = PFQuery(className:"CourseForUser")
                joinedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
                joinedCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        for object in objects {
                            courses.append(object["courseObjectId"] as PFObject)
                        }
                        self.tableContent[0] = courses
                        self.coursesTableView.reloadData()
                    } else {
                        println("fout in joined courses")
                    }
                }
            case 2:
                var hostedCourses = PFQuery(className:"Course")
                hostedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
                hostedCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        self.tableContent[1] = objects as Array<PFObject>
                         self.coursesTableView.reloadData()
                    } else {
                        println("fout in hosted courses")
                    }
                }
            case 3:
                var allCourses = PFQuery(className:"Course")
                allCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        self.tableContent[2] = objects as Array<PFObject>
                        self.coursesTableView.reloadData()
                    } else {
                        println("fout in all courses")
                    }
                }
            default:
                println("No segment selected")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve data from database and reload tableview
        getData()
        
        //set the pull to refresh
        self.refreshController = UIRefreshControl()
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
        
        if tableContent.count == 0 {
            return 0
        } else {
            return tableContent[currentSegment].count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = tableContent[currentSegment][indexPath.row]["title"] as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableContent[currentSegment][indexPath.row]["userObjectId"] as PFUser).objectId == PFUser.currentUser().objectId {
            
            selectedCourse = tableContent[currentSegment][indexPath.row]
            performSegueWithIdentifier("courseDetailSegue", sender: self)
            
        } else {
            println("im not the owner")
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (tableContent[currentSegment][indexPath.row]["userObjectId"] as PFUser).objectId == PFUser.currentUser().objectId {
            return true
        } else {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableContent[currentSegment][indexPath.row].deleteInBackgroundWithTarget(nil, selector: nil)
            
            tableContent[currentSegment].removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            getData()
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
