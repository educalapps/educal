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
    
    func showStringFromDate(format: String, date:NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let newDate = dateFormatter.stringFromDate(date)
        
        return newDate
    }
    
    func showDateFromString(format: String, date:String) -> NSDate{
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        var dateFromString:NSDate = dateFormatter.dateFromString(date)!
        
        return dateFromString
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}