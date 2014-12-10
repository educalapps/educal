//
//  RegistrationTableViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func signUpPressed(sender: UIButton) {
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
                self.performSegueWithIdentifier("signInAfterSignUp", sender: self)
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
        if (segue.identifier == "signInAfterSignUp") {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(nameTextfield.text, forKey: "name")
            userDefaults.synchronize()
            
            
            var username:String = userDefaults.objectForKey("name") as String
            
            Functions.Instance().showAlert("Congratulations \(username)!", description: "From now your life will be organized as fuck!")
        }
    }
    
    
}
