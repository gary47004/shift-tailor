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
    
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var weeklyViewHeight: NSLayoutConstraint!
    
    
    var  selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
    var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    let dateFormatter = NSDateFormatter()
    
    var shiftStartDate :String! = ""
    
    
    
    
    
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
        
        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
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
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa")
            
            self.weeklyView.addEvent(newEvent)
            
            
        })
        
        
        
        
        
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "employeeAddEventSegue"{
            
            
            let destinationVC = segue.destinationViewController as! EmployeeAddEventViewController
            
            
            destinationVC.shiftStartDate = self.shiftStartDate
            destinationVC.longPressDate = longPressDate
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }
    }
    
    
    
    @IBAction func deleteEvent(sender: UIButton) {
        let eventDBRef = FIRDatabase.database().referenceFromURL("https://shifter-35349.firebaseio.com/employeeEvent/2016-10-16/102306111")
        eventDBRef.child(selectedEvent.key).removeValue()
        deleteView.hidden = true
        weeklyViewHeight.constant = 0

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
    }
    
    
    
    
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        
        
        selectedEvent = event
        deleteView.hidden = false
        weeklyViewHeight.constant = -40
        let editDBRef = FIRDatabase.database().referenceFromURL("https://shifter-35349.firebaseio.com/employeeEvent/2016-10-16/102306111")
        
        
        editDBRef.observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            
            let eventID = snapshot.key
            
            if eventID != "" {
                
                self.weeklyView.removeEvent(self.selectedEvent)
                
            }
            
            
            
        })

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var newEventArray = [MSEvent]()
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").queryOrderedByKey().observeEventType(.ChildChanged, withBlock: {
            
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
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa")
            
            newEventArray.append(newEvent)
            
            
            self.weeklyView.events = newEventArray
            
            
            
            
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
