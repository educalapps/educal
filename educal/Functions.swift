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
    
    var coursesTableContent = Array<Array<PFObject>>()
    
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
    
    func refreshCoursesData(coursesTable:UITableView? = nil){
        // Clear tablecontent array
        coursesTableContent.removeAll(keepCapacity: false)
        
        for segment in 1...3 {
            coursesTableContent.append(Array<PFObject>())
        }
        
        for segment in 1...3 {
            var courses = Array<PFObject>()
            
            switch segment {
            case 1:
                var joinedCourses = PFQuery(className:"CourseForUser")
                joinedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
                joinedCourses.orderByAscending("courseObjectId")
                joinedCourses.includeKey("courseObjectId")
                joinedCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        for object in objects {
                            courses.append(object["courseObjectId"] as PFObject)
                        }
                        self.coursesTableContent[0] = courses
                        coursesTable?.reloadData()
                    } else {
                        println("fout in joined courses")
                    }
                }
            case 2:
                var hostedCourses = PFQuery(className:"Course")
                hostedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
                hostedCourses.orderByAscending("title")
                hostedCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        self.coursesTableContent[1] = objects as Array<PFObject>
                        coursesTable?.reloadData()
                    } else {
                        println("fout in hosted courses")
                    }
                }
            case 3:
                var allCourses = PFQuery(className:"Course")
                allCourses.orderByAscending("title")
                allCourses.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        self.coursesTableContent[2] = objects as Array<PFObject>
                        coursesTable?.reloadData()
                    } else {
                        println("fout in all courses")
                    }
                }
            default:
                println("No segment selected")
            }
        }
    }
}