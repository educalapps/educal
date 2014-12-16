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
    
    var course:PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (course != nil) {
            titleTextField.text = course?["title"] as String
            codeTextField.text = course?["code"] as String
            descriptionTextField.text = course?["description"] as String
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        if !titleTextField.text.isEmpty && !codeTextField.text.isEmpty {
            
            if course == nil {
                course = PFObject(className: "Course")
            }
            course?["userObjectId"] = PFUser.currentUser()
            course?["title"] = titleTextField.text
            course?["code"] = codeTextField.text
            course?["description"] = descriptionTextField.text
            course?.saveInBackgroundWithTarget(nil, selector: nil)
            println("saved")
            performSegueWithIdentifier("BackToCoursesTableView", sender: sender)
        } else {
            Functions.Instance().showAlert("Error!", description: "Fill in the required fields.")
        }

    }

}
