//
//  RegistrationTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func signUpPressed(sender: UIButton?) {
        var user = PFUser()
        user.username = emailTextfield.text
        user.password = passwordTextfield.text
        user.email = emailTextfield.text
        
        // other fields can be set just like with PFObject
        user["name"] = nameTextfield.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                
                // update all local data
                DataProvider.Instance().updateLocalHomework()
                DataProvider.Instance().updateLocalHomeworkForUser()
                DataProvider.Instance().updateLocalCourses()
                DataProvider.Instance().updateLocalCoursesForUser()
                
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                Functions.Instance().showAlert("Error!", description: error.userInfo?["error"] as String)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next {
            textField.resignFirstResponder()
            switch textField {
                case nameTextfield:
                    emailTextfield.becomeFirstResponder()
                case emailTextfield:
                    passwordTextfield.becomeFirstResponder()
                default:
                    println("no textfield found")
            }
        } else if textField.returnKeyType == UIReturnKeyType.Go {
            signUpPressed(nil)
        }
        
        return true
    }
    
}
