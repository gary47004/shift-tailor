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
  
    
    @IBOutlet weak var employeeSetEventButton: UIBarButtonItem!
    @IBOutlet weak var titleItem: UINavigationItem!
    //var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    let dateFormatter = NSDateFormatter()
    
    var setEvnetSwitch : Bool! = false
    
    var shiftStartDate : String! = ""
    
    var shiftDate : NSDate!
    
    var currentWeekStartDate : String! = ""
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.employeeSetEventButton.title = ""
        
        let weekDateFormatter = NSDateFormatter()
        let shiftDateFormatter = NSDateFormatter()
        
        
        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekDateFormatter.dateFormat = "MMM d"
        
        var shiftStartDateString: String!
        var shiftEndDateString: String!
        
        
        let shiftDBRef = FIRDatabase.database().reference()
        shiftDBRef.child("employeeShift").child("010").child("currentShift").observeEventType(.Value, withBlock: {
            
            
            snapshot in
            
            print("currentShift",snapshot.value)
            
            self.currentWeekStartDate = snapshot.value as! String
            
            self.shiftDate = shiftDateFormatter.dateFromString(self.currentWeekStartDate)
            
            shiftStartDateString = weekDateFormatter.stringFromDate(self.shiftDate)
            
            shiftEndDateString = weekDateFormatter.stringFromDate(self.shiftDate.addDays(6))
            
            self.titleItem.title = "\(shiftStartDateString) - \(shiftEndDateString)"
            
            print("shift Date",self.currentWeekStartDate)
            
            self.setupWeekData()

            let eventDBRef = FIRDatabase.database().reference()
            
            eventDBRef.child("employeeShift").child("010").child(self.currentWeekStartDate).child("102306111").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                
                
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
                
                
                let endDate = dateformatter.dateFromString(endDateString)!
                
                let shortFormatter = NSDateFormatter()
                shortFormatter.dateFormat = "H:mm"
                
                let shortStartDateString = shortFormatter.stringFromDate(startDate)
                
                let shortEndDateString = shortFormatter.stringFromDate(endDate)
                
                //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
                
                let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
                
                
                self.weeklyView.addEvent(newEvent)
                
                
            })


        })
        
        print("SSSSSSSSS")
        
        
        

        
        
        
        
        
        
        
        print("zzzzzzzz")
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    func setupWeekData(){
        
        self.decoratedWeekView = MSWeekViewDecoratorFactory.make(self.weeklyView, features: 3 , andDelegate: self)
        let event1: MSEvent = MSEvent.make(shiftDate, duration: 0, title: "", location: "")
        print("event1")
        let event2: MSEvent = MSEvent.make(shiftDate.addDays(1), duration: 0, title: "", location: "")
        print("event2")
        let event3: MSEvent = MSEvent.make(shiftDate.addDays(2), duration: 0, title: "", location: "")
        let event4: MSEvent = MSEvent.make(shiftDate.addDays(3), duration: 0, title: "", location: "")
        let event5: MSEvent = MSEvent.make(shiftDate.addDays(4), duration: 0, title: "", location: "")
        let event6: MSEvent = MSEvent.make(shiftDate.addDays(5), duration: 0, title: "", location: "")
        let event7: MSEvent = MSEvent.make(shiftDate.addDays(6), duration: 0, title: "", location: "")
        
        
        weeklyView.delegate = self
        
        weeklyView.weekFlowLayout.show24Hours = true
        
        weeklyView.daysToShowOnScreen = 7
        
        weeklyView.daysToShow = 0
        
        weeklyView.weekFlowLayout.hourHeight = 50
        
        weeklyView.events = [event1,event2,event3,event4,event5,event6,event7]
      
    }
    
    
    
    
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        print(event.StartDate, event.EndDate)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        var neweEventArray = [MSEvent]()
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeShift").child("010").child("2016-10-16").child("102306111").observeEventType(.ChildChanged, withBlock: {
            
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
            
            
            neweEventArray.append(newEvent)
            
            
            self.weeklyView.events = neweEventArray
            
            
            
            
        })
        
        eventDBRef.child("employeeEvent").child("010").observeEventType(.Value, withBlock: {
            
            snapshot in
            
            
            self.setEvnetSwitch = snapshot.childSnapshotForPath("setEventSwitch").value as! Bool
            self.shiftStartDate = snapshot.childSnapshotForPath("currentEvent").value as! String
            
            print(self.shiftStartDate)
            
            
            
            if self.setEvnetSwitch == true{
                self.employeeSetEventButton.title = "填表"
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
            
            
            
            
            
            
            
        })

        
        
        self.weeklyView.forceReload()
        
    }
    
    
 
    
    
    
    @IBAction func employeeSetEvent(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("employeeSetEvent", sender: nil)
    }
   
    
    func weekView(weekView: MSWeekView!, newDaysLoaded startDate: NSDate!, to endDate: NSDate!) -> Bool {
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "employeeSetEvent"{
        
            let destinationVC = segue.destinationViewController as! EmployeeEventWeekViewController
            destinationVC.shiftStartDate = self.shiftStartDate
            
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        
        }
    }
}



