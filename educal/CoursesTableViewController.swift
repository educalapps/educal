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
    var allCoursesInTable = Array<PFObject>()
    
    func didFinishFetchingString(text: String) {
        println(text)
    }
    
    @IBAction func unwindToCoursesList(sender:UIStoryboardSegue){
        //reload tableview
        
        
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
    
    override func viewWillAppear(animated: Bool) {
        coursesTableView.reloadData()
    }
    
    func refresh(sender:AnyObject){
        // Code to refresh table view
        
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
        //allCoursesInTable.removeAll(keepCapacity: false)
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        

        switch currentSegment {
        case 0:
            var countObjects = PFQuery(className: "CourseForUser")
            countObjects.fromLocalDatastore()
            return countObjects.countObjects()
        case 1:
            var countObjects = PFQuery(className: "Course")
            countObjects.whereKey("userObjectId", equalTo: PFUser.currentUser())
            countObjects.fromLocalDatastore()
            return countObjects.countObjects()
        case 2:
            var countObjects = PFQuery(className: "Course")
            countObjects.fromLocalDatastore()
            return countObjects.countObjects()
        default:
            println("no segment selected")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as UITableViewCell
        
        
        switch currentSegment {
        case 0:
            var Objects = PFQuery(className: "CourseForUser")
            Objects.includeKey("courseObjectId")
            Objects.fromLocalDatastore()
            Objects.skip = indexPath.row
            Objects.limit = 1
            Objects.findObjectsInBackgroundWithBlock(){
                (result:[AnyObject]!, error:NSError!) in
                
                var object = (result[0]["courseObjectId"] as PFObject)
                cell.textLabel?.text = object["title"] as? String
                self.allCoursesInTable.append(object)
            }
            cell.textLabel?.text = "Course \(indexPath.row)"
        case 1:
            var Objects = PFQuery(className: "Course")
            Objects.whereKey("userObjectId", equalTo: PFUser.currentUser())
            Objects.fromLocalDatastore()
            Objects.orderByAscending("title")
            Objects.skip = indexPath.row
            Objects.limit = 1
            Objects.findObjectsInBackgroundWithBlock(){
                (result:[AnyObject]!, error:NSError!) in
                
                var object = result[0] as PFObject
                cell.textLabel?.text = object["title"] as? String
                self.allCoursesInTable.append(object)
            }
            cell.textLabel?.text = "Course \(indexPath.row)"
        case 2:
            var Objects = PFQuery(className: "Course")
            Objects.fromLocalDatastore()
            Objects.orderByAscending("title")
            Objects.skip = indexPath.row
            Objects.limit = 1
            Objects.findObjectsInBackgroundWithBlock(){
                (result:[AnyObject]!, error:NSError!) in
                
                var object = result[0] as PFObject
                cell.textLabel?.text = object["title"] as? String
                self.allCoursesInTable.append(object)
            }
            cell.textLabel?.text = "Course \(indexPath.row)"
        default:
            println("no segment selected")
        }
        
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCourse = allCoursesInTable[indexPath.row]
        performSegueWithIdentifier("courseDetailSegue", sender: self)
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
