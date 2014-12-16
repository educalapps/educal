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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        if !titleTextField.text.isEmpty || !codeTextField.text.isEmpty {
            var course = PFObject(className: "Course")
            course["userObjectId"] = PFUser.currentUser()
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

}
