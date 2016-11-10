//
//  EmployeeEventWeekViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EmployeeEventWeekViewController: UIViewController,MSWeekViewDelegate,MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate, MSWeekViewInfiniteDelegate {

   
    
    
    @IBOutlet weak var weeklyView: MSWeekView!
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    
    
    var  selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
    var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    let dateFormatter = NSDateFormatter()
    
    var shiftStartDate :String! = ""
    
    var shiftDate: NSDate!
    
    let weekDateFormatter = NSDateFormatter()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let shiftDateFormatter = NSDateFormatter()
        
        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekDateFormatter.dateFormat = "MMM d"
        
        var shiftStartDateString: String!
        var shiftEndDateString: String!
        
        self.shiftDate = shiftDateFormatter.dateFromString(shiftStartDate)
        
        shiftStartDateString = weekDateFormatter.stringFromDate(shiftDate)
        shiftEndDateString = weekDateFormatter.stringFromDate(shiftDate.addDays(6))
        
        titleItem.title = "\(shiftStartDateString) - \(shiftEndDateString)"
        
        self.setupWeekData()
        
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "employeeAddEventSegue"{
            
            
            let destinationVC = segue.destinationViewController as! EmployeeAddEventViewController
            
            
            destinationVC.shiftStartDate = self.shiftStartDate
            destinationVC.longPressDate = longPressDate
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "employeeEditEventSegue"{
        
            let destinationVC = segue.destinationViewController as! EmployeeEditEventViewController
            
            destinationVC.selectedEvent = selectedEvent
            destinationVC.shiftStartDate = self.shiftStartDate
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        
        
        
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    func setupWeekData(){
        
        self.decoratedWeekView = MSWeekViewDecoratorFactory.make(self.weeklyView, features: 3 , andDelegate: self)
        
        
        let event1: MSEvent = MSEvent.make(shiftDate, duration: 0, title: "", location: "")
        let event2: MSEvent = MSEvent.make(shiftDate.addDays(1), duration: 0, title: "", location: "")
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
        
        
        selectedEvent = event
        
        performSegueWithIdentifier("employeeEditEventSegue", sender: nil)
        
        let editDBRef = FIRDatabase.database().reference()
        
        
        editDBRef.child("employeeEvent").child("010").child(shiftStartDate).observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            
            let eventID = snapshot.key
            
            if eventID != "" {
                
                self.weeklyView.removeEvent(self.selectedEvent)
                
            }
            
            
            
        })

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        var newEventArray = [MSEvent]()
//        
//        let eventDBRef = FIRDatabase.database().reference()
//        
//        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").queryOrderedByKey().observeEventType(.ChildChanged, withBlock: {
//            
//            snapshot in
//            
//            let startDateString = snapshot.value!["Start Date"] as! String
//            
//            let eventID = snapshot.key
//            
//            let endDateString = snapshot.value!["End Date"] as! String
//            
//            let coding = 0
//            
//            
//            let dancing = 0
//            let cleaning = 0
//            
//            let dateformatter = NSDateFormatter()
//            
//            dateformatter.dateFormat = "yyyy-M-dd-H:mm"
//            
//            let startDate = dateformatter.dateFromString(startDateString)!
//            
//            let endDate = dateformatter.dateFromString(endDateString)!
//            
//            let shortFormatter = NSDateFormatter()
//            shortFormatter.dateFormat = "H:mm"
//            
//            let shortStartDateString = shortFormatter.stringFromDate(startDate)
//            
//            let shortEndDateString = shortFormatter.stringFromDate(endDate)
//            
//            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
//            
//            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
//            
//            
//            newEventArray.append(newEvent)
//            
//            
//            self.weeklyView.events = newEventArray
//            
//            
//            
//            
//        })
        var newEventArray = [MSEvent]()
        
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            
            let startDateString = snapshot.value!["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = snapshot.value!["End Date"] as! String
            
            let coding = snapshot.value!["Preference"] as! Int
            
            
            let dancing = 0
            
            let cleaning = 0
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
            
            
            
            let event1: MSEvent = MSEvent.make(self.shiftDate, duration: 0, title: "", location: "")
            let event2: MSEvent = MSEvent.make(self.shiftDate.addDays(1), duration: 0, title: "", location: "")
            let event3: MSEvent = MSEvent.make(self.shiftDate.addDays(2), duration: 0, title: "", location: "")
            let event4: MSEvent = MSEvent.make(self.shiftDate.addDays(3), duration: 0, title: "", location: "")
            let event5: MSEvent = MSEvent.make(self.shiftDate.addDays(4), duration: 0, title: "", location: "")
            let event6: MSEvent = MSEvent.make(self.shiftDate.addDays(5), duration: 0, title: "", location: "")
            let event7: MSEvent = MSEvent.make(self.shiftDate.addDays(6), duration: 0, title: "", location: "")
            
            newEventArray.append(newEvent)
            
            
            
            self.weeklyView.events = newEventArray
            
            self.weeklyView.addEvents([event1,event2,event3,event4,event5,event6,event7])
            
            for newEvent in newEventArray{
                if newEvent.StartDate!.day() == self.shiftDate.day(){
                    self.weeklyView.removeEvent(event1)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(1).day(){
                    self.weeklyView.removeEvent(event2)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(2).day(){
                    self.weeklyView.removeEvent(event3)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(3).day(){
                    self.weeklyView.removeEvent(event4)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(4).day(){
                    self.weeklyView.removeEvent(event5)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(5).day(){
                    self.weeklyView.removeEvent(event6)
                }else if newEvent.StartDate!.day() == self.shiftDate.addDays(6).day(){
                    self.weeklyView.removeEvent(event7)
                }
                
            }
            
            
        })

        
               
        self.weeklyView.forceReload()
        
    }
    
    
    
    // week view decorator dragable delegate
    
    func weekView(weekView: MSWeekView!, event: MSEvent!, moved date: NSDate!) {
        print("Event moved")
    }
    
    func weekView(weekView: MSWeekView!, canMoveEvent event: MSEvent!, to date: NSDate!) -> Bool {
        return true
    }
    
    // week view decorator new event delegate
    
    func weekView(weekView: MSWeekView!, onLongPressAt date: NSDate!) {
        
        print(date)
        
        longPressDate = date
        
        print("Long pressed at: ", longPressDate)
        
        performSegueWithIdentifier("employeeAddEventSegue", sender: nil)
        
        
    }
    
    
    
    
    
    // week view decorator infinite delegate
    
    func weekView(weekView: MSWeekView!, newDaysLoaded startDate: NSDate!, to endDate: NSDate!) -> Bool {
        
        //        print("new days loaded: " + startDate.toDateString() + " - " + endDate.toDateString())
        //
        //        let newEvent = MSEvent.make(startDate.addHours(7), duration: 60*3, title: "New Event ", location: "卡洛斯")
        //        let lastEvent = MSEvent.make(endDate.addHours(-7), duration: 60*3, title: "Last Event ", location: "真新鎮")
        //        weeklyView.addEvents([newEvent, lastEvent])
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
