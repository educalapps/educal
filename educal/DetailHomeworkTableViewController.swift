//
//  DetailHomeworkTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 15-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class DetailHomeworkTableViewController: UITableViewController {
    
    var homeworkObject:PFObject?
    var hideCompleteSwitch:Bool = false
    var course:PFObject?
    
    @IBOutlet var detailView: UITableView!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var finshedSwitch: UISwitch!
    @IBOutlet weak var completeCell: UITableViewCell!
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            homeworkObject?.unpinWithName("homework")
            if homeworkObject?["personal"] as Bool == true {
                homeworkObject?["completed"] = true
                homeworkObject?["completedAt"] = NSDate()
            } else {
                var completedBy = homeworkObject?["completedBy"] as [PFUser]
                completedBy.append(PFUser.currentUser())
                homeworkObject?["completedBy"] = completedBy
            }
            homeworkObject?.saveEventually()
            homeworkObject?.pinInBackgroundWithName("homework", block: nil)
        } else{
            homeworkObject?.unpinWithName("homework")
            if homeworkObject?["personal"] as Bool == true {
                homeworkObject?["completed"] = false
            } else {
                var completedBy = homeworkObject?["completedBy"] as [PFUser]
                for var i = 0; i < completedBy.count; i++ {
                    if completedBy[i] as PFUser == PFUser.currentUser() {
                        completedBy.removeAtIndex(i)
                        break
                    }
                }
                homeworkObject?["completedBy"] = completedBy
            }
            homeworkObject?.saveEventually()
            homeworkObject?.pinInBackgroundWithName("homework", block: nil)
        }
    }
    
    func setValues(){
        
        completeCell.hidden = hideCompleteSwitch
        
        // Dateformat
        let newDate = Functions.Instance().showStringFromDate("d MMM-HH:mm", date: homeworkObject?["deadline"] as NSDate)
        
        // Split date by day and month
        var newDateArray = split(newDate) {$0 == "-"}
        var onlyDateArray = split(newDateArray[0]) {$0 == " "}
        
        // Set fields
        dateDayLabel?.text = onlyDateArray[0].uppercaseString
        dateMonthLabel?.text = onlyDateArray[1].uppercaseString
        
        if course != nil {
            var courseTitle = course?["title"] as String
            homeLabel?.text = "\(newDateArray[1]) - \(courseTitle)"
        } else {
            homeLabel?.text = newDateArray[1] as String
        }
        
        nameLabel?.text = homeworkObject?["title"] as? String
        descriptionTextview.text = homeworkObject?["description"] as? String
        
        if homeworkObject?["personal"] as Bool == true {
            if homeworkObject?["completed"] as NSObject == true {
                finshedSwitch.setOn(true, animated: true)
            }
        } else {
            var completedBy = homeworkObject?["completedBy"] as [PFUser]
            if contains(completedBy, PFUser.currentUser()) {
                finshedSwitch.setOn(true, animated: true)
            }
        }
        
        // Hide unused cells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        // Add barbutton when is it your homework
        if homeworkObject?["userObjectId"] as PFUser == PFUser.currentUser() {
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editButtonPressed"), animated: true)
        }

    }
    
    func editButtonPressed(){
        performSegueWithIdentifier("editHomework", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = homeworkObject?["title"] as? String
        setValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editHomework"{
            var dc = segue.destinationViewController as AddHomeworkTableViewController
            dc.homework = homeworkObject
            dc.course = course
        }
        
    }

}
