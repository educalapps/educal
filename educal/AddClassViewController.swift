//
//  AddClassViewController.swift
//  educal
//
//  Created by Bastiaan van Weijen on 08-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var codeTextfield: UITextField!
    @IBOutlet weak var schoolTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClass(sender: AnyObject) {

        // Get schoolID
        var query = PFQuery(className:"School")
        query.whereKey("title", equalTo:schoolTextfield.text)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    var curSchoolId = object.objectId
                    var gameScore = PFObject(className:"Class")
                    
                    gameScore["title"] = self.nameTextfield.text
                    gameScore["code"] = self.codeTextfield.text
                    gameScore["schoolId"] = curSchoolId
                    gameScore.saveInBackgroundWithTarget(nil, selector: nil)
                    
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
                
                // If no school found, ask for creating one
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
