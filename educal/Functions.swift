//
//  Functions.swift
//  educal
//
//  Created by Bastiaan van Weijen on 10-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import Foundation

var instance: Functions?

class Functions {
    class func Instance() -> Functions {
        if !(instance != nil) {
            instance = Functions()
        }
        
        return instance!
    }
    
    func showAlert(title:String, description:String) {
        let alert = UIAlertView()
        
        // Show the errorString somewhere and let the user try again.
        alert.title = title
        alert.message = description
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func showLoginViewController(source:UIViewController){
        var mainstoryboard = UIApplication.sharedApplication().delegate?.window??.rootViewController?.storyboard
        var loginController:UIViewController = mainstoryboard?.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        source.presentViewController(loginController, animated: true, completion: nil)
    }
}