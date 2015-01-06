//
//  DataProvider.swift
//  educal
//
//  Created by Jurriaan Lindhout on 17-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import Foundation

var DPinstance: DataProvider?

class DataProvider {
    
    class func Instance() -> DataProvider {
        if !(DPinstance != nil) {
            DPinstance = DataProvider()
        }
        return DPinstance!
    }
    
    // get all courses and set locally
    func updateLocalCourses(){        
        var myCourses = PFQuery(className:"Course")
        myCourses.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                PFObject.pinAllInBackground(objects, block: nil)
            }
        }
    }
    
    // get all join course relationships for user and set locally
    func updateLocalCoursesForUser(){
        if PFUser.currentUser() != nil {
            var joinedCourses = PFQuery(className:"CourseForUser")
            joinedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
            joinedCourses.findObjectsInBackgroundWithBlock{
                (objects:[AnyObject]!, error:NSError!) -> Void in
                
                if error == nil {
                    PFObject.pinAllInBackground(objects, block: nil)
                }
            }
        }
    }
    
    // get all homework for user and set locally
    func updateLocalHomework(){
        if PFUser.currentUser() != nil {
            var allHomework = PFQuery(className:"Homework")
            allHomework.whereKey("userObjectId", equalTo:PFUser.currentUser())
            allHomework.whereKey("personal", equalTo: true)
            allHomework.findObjectsInBackgroundWithBlock() {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                
                if error == nil {
                    PFObject.pinAllInBackground(objects, block: nil)
                }
            }
        }
    }
    
    // get all course homework for user and set locally
    func updateLocalHomeworkForUser(){
        if PFUser.currentUser() != nil {
            var homeworkForUser = PFQuery(className: "HomeworkForUser")
            homeworkForUser.whereKey("userObjectId", equalTo: PFUser.currentUser())
            homeworkForUser.findObjectsInBackgroundWithBlock() {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                
                if error == nil {
                    PFObject.pinAllInBackground(objects, block: nil)
                }
            }
        }
    }
}