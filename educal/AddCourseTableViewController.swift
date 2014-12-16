//
//  AddCourseTableViewController.swift
//  educal
//
//  Created by Jurriaan Lindhout on 12-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddCourseTableViewController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
//    var courseInfo:Course?
//    var groups = Array<Group>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        if !titleTextField.text.isEmpty || !codeTextField.text.isEmpty {
            var course = PFObject(className: "Course")
            course["userObjectId"] = PFUser.currentUser().objectId
            course["title"] = titleTextField.text
            course["code"] = codeTextField.text
            course["description"] = descriptionTextField.text
            course.saveInBackgroundWithTarget(nil, selector: nil)
            println("saved")
            performSegueWithIdentifier("BackToCoursesTableView", sender: sender)
        } else {
            Functions.Instance().showAlert("Error!", description: "Fill in the required fields.")
        }

    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    */

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        switch section {
            case 0:
                return 1
            case 1:
                return groups.count
            default:
                return 0
        }
        
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseTextFieldCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        switch indexPath.section {
            case 0:
                cell.textLabel?.text = courseInfo?.title
                cell.detailTextLabel?.text = courseInfo?.code
            case 1:
                cell.textLabel?.text = groups[indexPath.row].title
                cell.detailTextLabel?.text = groups[indexPath.row].code
            default:
                println("invalid section")
        }
        return cell
    }
    */


    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
    }
    */

}
