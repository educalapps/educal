//
//  AddCourseTableViewController.swift
//  educal
//
//  Created by Jurriaan Lindhout on 12-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddCourseTableViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var joinRelation:PFObject?
    
    var course:PFObject?
    
    func savePressed() {
        
        if !titleTextField.text.isEmpty && !codeTextField.text.isEmpty {
            
            if course == nil {
                course = PFObject(className: "Course")
            }
            course?["userObjectId"] = PFUser.currentUser()
            course?["title"] = titleTextField.text
            course?["code"] = codeTextField.text
            course?["description"] = descriptionTextField.text
            course?["active"] = true
            course?.saveEventually()
            course?.pinInBackgroundWithName("course", block: { (succes, error) -> Void in
                self.performSegueWithIdentifier("BackToCoursesTableView", sender: self)
            })
            
            
        } else {
            Functions.Instance().showAlert("Error!", description: "Fill in the required fields.")
        }
        
    }
    
    func joinCoursePressed() {
        var courseForUser = PFObject(className: "CourseForUser")
        courseForUser["courseObjectId"] = course
        courseForUser["userObjectId"] = PFUser.currentUser()
        courseForUser["active"] = true
        courseForUser.pinWithName("joinedCourseRelationship")
        courseForUser.saveEventually { (succes, error) -> Void in
            if error == nil {
                DataProvider.Instance().updateAllLocalData()
            }
        }
        Functions.Instance().showAlert("Congratulations!", description: "You have successfully joined this course")
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Leave", style: .Plain, target: self, action: "unjoinCoursePressed"), animated: true)
        
    }
    
    func unjoinCoursePressed() {
        
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("courseObjectId", equalTo: joinRelation?["courseObjectId"])
        joinRelation?.deleteEventually()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var pfobjects = objects as [PFObject]
            PFObject.unpinAllInBackground(pfobjects, withName: "courseHomework", block: { (succes, error) -> Void in
                
                if error == nil {
                    self.joinRelation?.unpinWithName("joinedCourseRelationship")
                }
                
            })
        }
        Functions.Instance().showAlert("", description: "You have now left this course")
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Join", style: .Plain, target: self, action: "joinCoursePressed"), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  course != nil {
            self.title = course?["title"] as? String
            titleTextField.text = course?["title"] as String
            codeTextField.text = course?["code"] as String
            descriptionTextField.text = course?["description"] as String
            
            if (course?["userObjectId"] as PFUser).objectId as String == PFUser.currentUser().objectId {
                titleTextField.clearButtonMode = UITextFieldViewMode.Always
                codeTextField.clearButtonMode = UITextFieldViewMode.Always
                
                self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "savePressed"), animated: true)
                
            } else {
                titleTextField.enabled = false
                codeTextField.enabled = false
                descriptionTextField.editable = false
                
                var query = PFQuery(className:"CourseForUser")
                query.fromLocalDatastore()
                query.whereKey("courseObjectId", equalTo:course)
                query.whereKey("userObjectId", equalTo: PFUser.currentUser())
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        // The find succeeded.
                        if objects.count == 1 {
                            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Leave", style: .Plain, target: self, action: "unjoinCoursePressed"), animated: true)
                            self.joinRelation = objects[0] as? PFObject
                        } else {
                            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Join", style: .Plain, target: self, action: "joinCoursePressed"), animated: true)
                        }
                        
                    } else {
                        // Log details of the failure
                        NSLog("Error: %@ %@", error, error.userInfo!)
                    }
                }
                
                
            }
            
        } else {
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "savePressed"), animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitles = Array<String>()
        if course != nil && (course?["userObjectId"] as PFUser).objectId as String != PFUser.currentUser().objectId {
            headerTitles = ["Title", "Code", "Description", "Homework"]
        } else {
            headerTitles = ["Title*", "Code*", "Description", "Homework"]
        }
        
        return headerTitles[section]
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footerTitles = Array<String>()
        if course != nil && (course?["userObjectId"] as PFUser).objectId as String != PFUser.currentUser().objectId {
            footerTitles = ["", "", "", ""]
        } else {
            footerTitles = ["", "", "* Required fields", ""]
        }
        
        return footerTitles[section]
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHomeworkSegue" {
            var vc = segue.destinationViewController as ShowHomeworkTableViewController
            vc.course = course
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
