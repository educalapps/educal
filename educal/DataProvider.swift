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
    
    var oneWeekFurther = NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 7)
    var twoWeekFurther = NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 14)
    
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
    
    // count homework for this week
    func countHomeworkForThisWeek(completed:Bool) -> Int {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        query.whereKey("deadline", greaterThan: NSDate() )
        query.whereKey("deadline", lessThan: oneWeekFurther )
        return query.countObjects()
    }
    
    // get homework for this week
    func getHomeworkForRowForThisWeek(row:Int, completed:Bool, completion: (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void) {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        query.addAscendingOrder("deadline")
        query.whereKey("deadline", greaterThan: NSDate() )
        query.whereKey("deadline", lessThan: oneWeekFurther )
        query.findObjectsInBackgroundWithBlock(){
            (objects:[AnyObject]?, error:NSError!) in
            
            var myObjects = objects as [PFObject]?
            var myObject = myObjects?[row]
            
            // Set title of tablecell
            var title = myObjects?[row]["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(myObjects?[row]["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:myObject!)
        }
    }
    
    // count homework for next week
    func countHomeworkForNextWeek(completed:Bool) -> Int {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        query.whereKey("deadline", greaterThan: oneWeekFurther )
        query.whereKey("deadline", lessThan: twoWeekFurther )
        return query.countObjects()
    }
    
    // get homework for next week
    func getHomeworkForRowForNextWeek(row:Int, completed:Bool, completion: (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void) {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        query.addAscendingOrder("deadline")
        query.whereKey("deadline", greaterThan: oneWeekFurther )
        query.whereKey("deadline", lessThan: twoWeekFurther )
        query.findObjectsInBackgroundWithBlock(){
            (objects:[AnyObject]?, error:NSError!) in
            
            var myObjects = objects as [PFObject]?
            var myObject = myObjects?[row]
            
            // Set title of tablecell
            var title = myObjects?[row]["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(myObjects?[row]["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:myObject!)
        }
    }
    
    // count homework for all
    func countHomeworkForAll(completed:Bool) -> Int {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        return query.countObjects()
    }
    
    // get homework for all
    func getHomeworkForRowForAll(row:Int, completed:Bool, completion: (title:String, dateNr:String, dateName:String, time:String, object:PFObject) -> Void) {
        var query = PFQuery(className: "Homework")
        query.fromLocalDatastore()
        query.whereKey("active", equalTo: true)
        query.whereKey("completed", equalTo: completed)
        query.addAscendingOrder("deadline")
        query.findObjectsInBackgroundWithBlock(){
            (objects:[AnyObject]?, error:NSError!) in
            
            var myObjects = objects as [PFObject]?
            var myObject = myObjects?[row]
            
            // Set title of tablecell
            var title = myObjects?[row]["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(myObjects?[row]["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:myObject!)
        }
    }
}