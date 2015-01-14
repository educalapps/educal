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
    
    // update all local data
    func updateAllLocalData(){
        updateLocalHomework()
        updateLocalHomeworkForUser()
        updateLocalCourses()
        updateLocalCoursesForUser()
        
    }
    
    func removeAllLocalData(){
        PFObject.unpinAllObjectsInBackgroundWithName("course", block: nil)
        PFObject.unpinAllObjectsInBackgroundWithName("homework", block: nil)
        PFObject.unpinAllObjectsInBackgroundWithName("joinedCourseRelationship", block: nil)
        PFObject.unpinAllObjectsInBackgroundWithName("courseHomework", block: nil)
    }
    
    // get all courses and set locally
    func updateLocalCourses(){        
        var myCourses = PFQuery(className:"Course")
        myCourses.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {                
                PFObject.unpinAllObjectsInBackgroundWithName("course", block: { (succes, error) -> Void in
                    PFObject.pinAllInBackground(objects, withName: "course", block: nil)
                })
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
                    PFObject.unpinAllObjectsInBackgroundWithName("joinedCourseRelationship", block: { (succes, error) -> Void in
                        PFObject.pinAllInBackground(objects, withName: "joinedCourseRelationship", block: nil)
                    })
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
                    PFObject.unpinAllObjectsInBackgroundWithName("homework", block: { (succes, error) -> Void in
                        PFObject.pinAllInBackground(objects, withName: "homework", block: nil)
                    })
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
                    PFObject.unpinAllObjectsInBackgroundWithName("courseHomework", block: { (succes, error) -> Void in
                        PFObject.pinAllInBackground(objects, withName: "courseHomework", block: nil)
                    })
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
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var object = objects[row] as PFObject
            
            // Set title of tablecell
            var title = object["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(object["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:object)
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
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var object = objects[row] as PFObject
            
            // Set title of tablecell
            var title = object["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(object["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:object)
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
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var object = objects[row] as PFObject
            
            // Set title of tablecell
            var title = object["title"] as? String
            
            // Set subtitle of tablecell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d MMM-HH:mm" // d MMM 'at' HH:mm
            let newDate = dateFormatter.stringFromDate(object["deadline"] as NSDate)
            
            // Split date by day and month
            var newDateArray = split(newDate) {$0 == "-"}
            var onlyDate = newDateArray[0]
            var onlyTime = newDateArray[1]
            
            var onlyDateArray = split(onlyDate) {$0 == " "}
            var dateNumber = onlyDateArray[0].uppercaseString
            var dateName = onlyDateArray[1].uppercaseString
            var time = onlyTime
            
            completion(title: title!, dateNr: dateNumber, dateName: dateName, time: time, object:object)
        }
    }
    
    // count joined courses for user
    func countJoinedCourses() -> Int {
        var countObjects = PFQuery(className: "CourseForUser")
        countObjects.whereKey("active", equalTo:true)
        countObjects.fromLocalDatastore()
        return countObjects.countObjects()
    }
    
    // get joined course for user
    func getJoinedCourse(row:Int, completion: (object:PFObject) -> Void) {
        var Objects = PFQuery(className: "CourseForUser")
        Objects.whereKey("active", equalTo:true)
        Objects.includeKey("courseObjectId")
        Objects.fromLocalDatastore()
        Objects.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) in
            
            var selectedObject = result[row]["courseObjectId"] as PFObject
            completion(object:selectedObject)
        }
    }
    
    // count hosted courses for user
    func countHostedCourses() -> Int {
        var countObjects = PFQuery(className: "Course")
        countObjects.whereKey("active", equalTo:true)
        countObjects.whereKey("userObjectId", equalTo: PFUser.currentUser())
        countObjects.fromLocalDatastore()
        return countObjects.countObjects()
    }
    
    // get hosted course for user
    func getHostedCourse(row:Int, completion: (object:PFObject) -> Void) {
        var Objects = PFQuery(className: "Course")
        Objects.whereKey("active", equalTo:true)
        Objects.whereKey("userObjectId", equalTo: PFUser.currentUser())
        Objects.fromLocalDatastore()
        Objects.orderByAscending("title")
        Objects.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) in
            
            var selectedObject = result[row] as PFObject
            
            completion(object:selectedObject)
        }
    }
    
    // count all courses
    func countAllCourses() -> Int {
        var countObjects = PFQuery(className: "Course")
        countObjects.whereKey("active", equalTo:true)
        countObjects.fromLocalDatastore()
        return countObjects.countObjects()
    }
    
    // get course from all courses
    func getCourse(row:Int, completion: (object:PFObject) -> Void) {
        var Objects = PFQuery(className: "Course")
        Objects.whereKey("active", equalTo:true)
        Objects.fromLocalDatastore()
        Objects.orderByAscending("title")
        Objects.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) in
            var selectedObject = result[row] as PFObject
            completion(object:selectedObject)
        }
    }
    
    // get all homework for course
    func getCourseHomework(course:PFObject, completion:(result:Array<PFObject>) -> Void) {
        var query = PFQuery(className: "Homework")
        query.whereKey("courseObjectid", equalTo: course)
        query.whereKey("personal", equalTo: false)
        query.whereKey("active", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var selectedObject = objects[0] as PFObject

            completion(result: objects as Array<PFObject>)
        }
    }
}