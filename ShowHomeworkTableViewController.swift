//
//  ShowHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 14-01-15.
//  Copyright (c) 2015 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class ShowHomeworkTableViewController: UITableViewController {
    
    var course:PFObject?
    var homeworkInList = Array<PFObject>()

    @IBOutlet var homeworkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if course?["userObjectId"] as PFUser == PFUser.currentUser() {
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPressed"), animated: true)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        DataProvider.Instance().getCourseHomework(course!, completion: { (result) -> Void in
            if result.count != 0 {
                self.homeworkInList = result
                self.homeworkTableView.reloadData()
            } else{
                Functions.Instance().showAlert("Not found", description:"There is no homework for this course")
            }
        })
    }
    
    @IBAction func unwindToCourseHomework(segue: UIStoryboardSegue) {
        DataProvider.Instance().getCourseHomework((segue.sourceViewController as AddHomeworkTableViewController).course!, completion: { (result) -> Void in
            self.homeworkInList = result
            self.homeworkTableView.reloadData()
        })
    }

    func addPressed(){
        performSegueWithIdentifier("addCourseHomeworkSegue", sender: self)
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
        
        
        return homeworkInList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeworkCell", forIndexPath: indexPath) as UITableViewCell as CustomTableViewCell
        
        var object = homeworkInList[indexPath.row]
        
        // Set subtitle of tablecell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
        let newDate = dateFormatter.stringFromDate(object["deadline"] as NSDate)
        
        // Split date by day and month
        var newDateArray = split(newDate) {$0 == "-"}
        var onlyDate = newDateArray[0]
        var onlyTime = newDateArray[1]
        
        var onlyDateArray = split(onlyDate) {$0 == " "}
        var dateNumber = onlyDateArray[0].uppercaseString
        var dateName = onlyDateArray[1].uppercaseString
        var time = onlyTime

        // Configure the cell...
        cell.homeworkTitleLabel.text = object["title"] as? String
        cell.homeworkDeadlineLabel.text = time
        cell.dateDayLabel.text = dateNumber
        cell.dateMonthLabel.text = dateName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("courseHomeworkDetailSegue", sender: indexPath.row)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addCourseHomeworkSegue" {
            var vc = segue.destinationViewController as AddHomeworkTableViewController
            vc.course = course
        } else if segue.identifier == "courseHomeworkDetailSegue" {
            var vc = segue.destinationViewController as DetailHomeworkTableViewController
            vc.homeworkObject = homeworkInList[sender as Int]
            vc.hideCompleteSwitch = true
            vc.course = course
        }
    }
    

}
