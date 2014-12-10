//
//  LoginTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func signInPressed(sender: UIButton?) {
        PFUser.logInWithUsernameInBackground(emailTextfield.text, password:passwordTextfield.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("signInSegue", sender: self)
            } else {
                // The login failed. Check error to see why.
                var errorMsg:String = error.userInfo?["error"] as String
                Functions.Instance().showAlert("Error!", description: "Your login failed. Message: \(errorMsg)")
            }
        }
    }

    @IBAction func facebookSignInPressed(sender: UIButton) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            self.performSegueWithIdentifier("signInSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "signInSegue") {
            var curUser = PFUser.currentUser()
            
            
            var username:String = curUser["name"] as String
            Functions.Instance().showAlert("Congratulations \(username)!", description: "From now your life will be organized as fuck!")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next {
            textField.resignFirstResponder()
            switch textField {
                case emailTextfield:
                    passwordTextfield.becomeFirstResponder()
                default:
                    println("no textfield found")
            }
        } else if textField.returnKeyType == UIReturnKeyType.Go {
            signInPressed(nil)
        }
        
        return true
    }
    
}
