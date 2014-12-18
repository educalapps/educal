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
    
    var joinedCourses:Array<PFObject>?
    var hostedCourses:Array<PFObject>?
    var allCourses:Array<PFObject>?
    var CoursesTableContent = Array<Array<PFObject>>()
    
    var homeWorkThisWeek = Array<Array<PFObject>>()
    var homeWorkNextWeek = Array<Array<PFObject>>()
    var homeWorkAll = Array<Array<PFObject>>()
    var homeworkTableContent = Array<Array<Array<PFObject>>>()
    
    class func Instance() -> DataProvider {
        if !(DPinstance != nil) {
            DPinstance = DataProvider()
        }
        return DPinstance!
    }
    
    func fetchCoursesData(completion:(result:Array<Array<PFObject>>)->Void){
        CoursesTableContent.removeAll(keepCapacity: false)
        
        var allCourses = PFQuery(className:"Course")
        allCourses.orderByAscending("title")
        
        var hostedCourses = PFQuery(className:"Course")
        hostedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
        hostedCourses.orderByAscending("title")
        
        var joinedCourses = PFQuery(className:"CourseForUser")
        joinedCourses.whereKey("userObjectId", equalTo:PFUser.currentUser())
        joinedCourses.orderByAscending("courseObjectId")
        joinedCourses.includeKey("courseObjectId")
        
        var group = dispatch_group_create()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var group = dispatch_group_create()
            
            dispatch_group_enter(group)
            self.fetchObjectsForQuery(allCourses){
                (result:Array<PFObject>) in
                self.allCourses = result
                dispatch_group_leave(group)
            }
            
            dispatch_group_enter(group)
            self.fetchObjectsForQuery(hostedCourses){
                (result:Array<PFObject>) in
                self.hostedCourses = result
                dispatch_group_leave(group)
            }
            
            dispatch_group_enter(group)
            self.fetchObjectsForPointerQuery(joinedCourses, pointer: "courseObjectId"){
                (result:Array<PFObject>) in
                self.joinedCourses = result
                dispatch_group_leave(group)
            }
            
            
            
            dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                println("fetching courses complete!!")
                self.CoursesTableContent.append(self.joinedCourses!)
                self.CoursesTableContent.append(self.hostedCourses!)
                self.CoursesTableContent.append(self.allCourses!)
                
                completion(result: self.CoursesTableContent)
            })
            
            
        })
    }
    
    func fetchHomeworkData(completion:(result:Array<Array<Array<PFObject>>>)->Void) {
        homeworkTableContent.removeAll(keepCapacity: false)
        
        // Get next week and the week after that
        var nowDate = NSDate()
        var oneWeekFurther = nowDate.dateByAddingTimeInterval(60 * 60 * 24 * 7)
        var twoWeekFurther = nowDate.dateByAddingTimeInterval(60 * 60 * 24 * 14)
        
        var thisWeekHomework = PFQuery(className:"Homework")
        thisWeekHomework.whereKey("userObjectId", equalTo:PFUser.currentUser())
        thisWeekHomework.whereKey("deadline", greaterThan: nowDate )
        thisWeekHomework.whereKey("deadline", lessThan: oneWeekFurther )
        thisWeekHomework.orderByAscending("deadline")
        
        var nextWeekHomework = PFQuery(className:"Homework")
        nextWeekHomework.whereKey("userObjectId", equalTo:PFUser.currentUser())
        nextWeekHomework.whereKey("deadline", greaterThan: oneWeekFurther )
        nextWeekHomework.whereKey("deadline", lessThan: twoWeekFurther )
        nextWeekHomework.orderByAscending("deadline")
        
        var allHomework = PFQuery(className:"Homework")
        allHomework.whereKey("userObjectId", equalTo:PFUser.currentUser())
        allHomework.orderByAscending("deadline")
        
        var group = dispatch_group_create()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var group = dispatch_group_create()
            
            dispatch_group_enter(group)
            self.fetchObjectsForQueryWithBool(thisWeekHomework, boolColumn: "completed") {
                (result:Array<Array<PFObject>>) in
                println("thisweekHomework complete")
                self.homeWorkThisWeek = result
                dispatch_group_leave(group)
            }
            
            dispatch_group_enter(group)
            self.fetchObjectsForQueryWithBool(nextWeekHomework, boolColumn: "completed") {
                (result:Array<Array<PFObject>>) in
                println("nextweekHomework complete")
                self.homeWorkNextWeek = result
                dispatch_group_leave(group)
            }
            
            dispatch_group_enter(group)
            self.fetchObjectsForQueryWithBool(allHomework, boolColumn: "completed") {
                (result:Array<Array<PFObject>>) in
                println("allHomework complete")
                self.homeWorkAll = result
                dispatch_group_leave(group)
            }
            
            dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                println("fetching homework complete!!")
                self.homeworkTableContent.append(self.homeWorkThisWeek)
                self.homeworkTableContent.append(self.homeWorkNextWeek)
                self.homeworkTableContent.append(self.homeWorkAll)
                
                
                completion(result: self.homeworkTableContent)
            })
        })
    }
    
    func fetchObjectsForQueryWithBool(query:PFQuery, boolColumn:String, completion:(result:Array<Array<PFObject>>) -> Void) {
        var objectArray = Array<Array<PFObject>>()
        objectArray.append(Array<PFObject>())
        objectArray.append(Array<PFObject>())
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                for object in objects {
                    if object[boolColumn] as Bool == false {
                        objectArray[0].append(object as PFObject)
                    } else {
                        objectArray[1].append(object as PFObject)
                    }
                }
                
                completion(result: objectArray)
            }
        }
    }
    
    func fetchObjectsForQuery(query:PFQuery, completion: (result:Array<PFObject>)->Void) {
        var objectArray = Array<PFObject>()
                
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                objectArray = objects as Array<PFObject>
                completion(result: objectArray)
            }
        }
    }
    
    func fetchObjectsForPointerQuery(query:PFQuery, pointer:String, completion:(result:Array<PFObject>) -> Void) {
        
        var objectArray = Array<PFObject>()
            
            query.findObjectsInBackgroundWithBlock{
                (objects:[AnyObject]!, error:NSError!) -> Void in
                
                if error == nil {
                    var newObjects = Array<PFObject>()
                    for object in objects {
                        newObjects.append(object[pointer] as PFObject)
                    }
                    objectArray = newObjects
                    completion(result: objectArray)
                }
            }
        
    }
}