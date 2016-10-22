//
//  EmployeeWeekViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EmployeeWeekViewController: UIViewController,MSWeekViewDelegate {

    var  selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
   
    @IBOutlet weak var weeklyView: MSWeekView!
  
    
    @IBOutlet weak var titleItem: UINavigationItem!
    //var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    let dateFormatter = NSDateFormatter()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWeekData()
        
        let weekStartDateFormatter = NSDateFormatter()
        let weekEndDateFormatter = NSDateFormatter()
        
        
        weekStartDateFormatter.dateFormat = "MMMM d"
        weekEndDateFormatter.dateFormat = "d"
        
        let convertedDate = weekStartDateFormatter.stringFromDate(currentDate)
        
        let weekEndDate = weekEndDateFormatter.stringFromDate(currentDate.addDays(6))
        
        titleItem.title = "\(convertedDate) - \(weekEndDate)"
        
        
        
        
        
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeShift").child("2016-10-16").child("102306111").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            
            
            snapshot in
            
            
            let startDateString = snapshot.value!["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = snapshot.value!["End Date"] as! String
            
            let coding = 0 
            
            
            let dancing = 0
            
            let cleaning = 0
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-H:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",startDate)
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa")
            print(newEvent.StartDate)
            
            self.weeklyView.addEvent(newEvent)
            
            
        })
        
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    func setupWeekData(){
        
        self.decoratedWeekView = MSWeekViewDecoratorFactory.make(self.weeklyView, features: 3 , andDelegate: self)
        
        
        let event1: MSEvent = MSEvent.make(NSDate.now(), duration: 0, title: "", location: "")
        
        
        weeklyView.delegate = self
        
        weeklyView.weekFlowLayout.show24Hours = true
        
        weeklyView.daysToShowOnScreen = 7
        
        weeklyView.daysToShow = 7
        
        weeklyView.weekFlowLayout.hourHeight = 50
        
        weeklyView.events = [event1]
        weeklyView.removeEvent(event1)
      
    }
    
    
    
    
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        print(event.StartDate, event.EndDate)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var neweEventArray = [MSEvent]()
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeShift").child("2016-10-16").child("102306111").observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            let startDateString = snapshot.value!["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = snapshot.value!["End Date"] as! String
            
            let coding = snapshot.value!["Coding"] as! Int
            
            
            let dancing = snapshot.value!["Dancing"] as! Int
            
            let cleaning = snapshot.value!["Cleaning"] as! Int
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-H:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa")
            
            neweEventArray.append(newEvent)
            
            
            self.weeklyView.events = neweEventArray
            
            
            
            
        })
        
        
        
        self.weeklyView.forceReload()
        
    }
    
    
    
   
    
    func weekView(weekView: MSWeekView!, newDaysLoaded startDate: NSDate!, to endDate: NSDate!) -> Bool {
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setEventSegue"{
        
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        
        }
    }
}



