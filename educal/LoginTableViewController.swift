//
//  LoginTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {

    // Variables
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func signInPressed(sender: UIButton?) {
        PFUser.logInWithUsernameInBackground(emailTextfield.text, password:passwordTextfield.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.userDefaults.setValue(user.objectId, forKey: "userId")
                self.userDefaults.setValue(user.username, forKey: "username")
                self.userDefaults.setValue(user["name"], forKey: "userNickname")
                self.userDefaults.setValue(user.email, forKey: "userEmail")
                self.userDefaults.synchronize()
                
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
        if userDefaults.objectForKey("userId") != nil {
            self.performSegueWithIdentifier("signInSegue", sender: self)
        } else{
            println("Niet ingelogd")
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
            var username:String = userDefaults.objectForKey("userNickname") as String
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
