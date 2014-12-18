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
    
    func didFinishFetchingString(text: String) {
        println(text)
    }
    
    @IBAction func unwindToCoursesList(sender:UIStoryboardSegue){
        //retrieve data from database and reload tableview
        DataProvider.Instance().fetchCoursesData(){
            (result:Array<Array<PFObject>>) in
            self.coursesTableView.reloadData()
        }
    }
    
    @IBAction func addCoursePressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("courseDetailSegue", sender: sender)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        currentSegment = sender.selectedSegmentIndex
        coursesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the pull to refresh
        self.refreshController = UIRefreshControl()
        self.refreshController.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshController)
    }
    
    func refresh(sender:AnyObject){
        // Code to refresh table view
        
        DataProvider.Instance().fetchCoursesData(){
            (result:Array<Array<PFObject>>) in
            self.coursesTableView.reloadData()
        }
        
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
        
        if DataProvider.Instance().CoursesTableContent.count == 0 {
            return 0
        } else {
            return DataProvider.Instance().CoursesTableContent[currentSegment].count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = DataProvider.Instance().CoursesTableContent[currentSegment][indexPath.row]["title"] as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCourse = DataProvider.Instance().CoursesTableContent[currentSegment][indexPath.row]
        performSegueWithIdentifier("courseDetailSegue", sender: self)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (DataProvider.Instance().CoursesTableContent[currentSegment][indexPath.row]["userObjectId"] as PFUser).objectId == PFUser.currentUser().objectId {
            return true
        } else {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            DataProvider.Instance().CoursesTableContent[currentSegment][indexPath.row].deleteInBackgroundWithBlock{
                (complete:Bool!, error:NSError!) -> Void in
                DataProvider.Instance().fetchCoursesData(){
                    (result:Array<Array<PFObject>>) in
                    
                }
            }
            
            DataProvider.Instance().CoursesTableContent[currentSegment].removeAtIndex(indexPath.row)
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
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
