//
//  ManagerShiftViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ManagerShiftViewController: UIViewController,MSWeekViewDelegate {
    
    var selectedDate: String = ""
    
    var shiftStartDate : String!
    
    var shiftEndDate: String = ""
    
    
    let storeID = "010"
    
    var selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
    var setEventSwitch : Bool = false
    
    var currentWeekStartDate:String!
    
    var shiftDate : NSDate!
    
    var currentEventDeadline : NSDate!
    
    var isSchedulingSwitch : Bool!
    
    
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    
    @IBOutlet weak var weeklyView: MSWeekView!
    
    //var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    //var codingList = [AnyObject]()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let shiftDateFormatter = NSDateFormatter()
        let weekDateFormatter = NSDateFormatter()
        
        
        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekDateFormatter.dateFormat = "MMM d"
        
        var shiftStartDateString: String!
        var shiftEndDateString:String!

        
        let shiftDBRef = FIRDatabase.database().reference()
        shiftDBRef.child("managerShift").child("010").child("currentShift").observeEventType(.Value, withBlock: {snapshot in
            
            self.currentWeekStartDate = snapshot.value as! String
            
            print("current", self.currentWeekStartDate)
            
            self.shiftDate = shiftDateFormatter.dateFromString(self.currentWeekStartDate)
            shiftStartDateString = weekDateFormatter.stringFromDate(self.shiftDate)
            shiftEndDateString = weekDateFormatter.stringFromDate(self.shiftDate.addDays(6))
            self.titleItem.title = "\(shiftStartDateString) - \(shiftEndDateString)"
            
            self.setupWeekData()
            
            print("Value Load Data")
            
            self.loadData()
            
            shiftDBRef.child("managerShift").child("010").child(self.currentWeekStartDate).observeEventType(.ChildRemoved, withBlock: {
                
                snapshot in
                
                print("Child Removed")
                
                self.loadData()
            
            })
            shiftDBRef.child("managerShift").child("010").child(self.currentWeekStartDate).observeEventType(.ChildChanged, withBlock: {
                
                snapshot in
                
                print("Child Changed")
                
                self.loadData()
                
            })

            
            

            
        })
    }
    
    func datePickerValueChanged(sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-M-dd"
        
        // Apply date format
        self.selectedDate = dateFormatter.stringFromDate(sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    @IBAction func setEvent(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        var currentTime = NSDate()
        
        
        dateFormatter.dateFormat = "yyyy-M-dd-HH:mm"
        let currentTimeString = dateFormatter.stringFromDate(currentTime)
        currentTime = dateFormatter.dateFromString(currentTimeString)!
    
        let dateComponentsFormatter = NSDateComponentsFormatter ()
        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Full
        let interval = self.currentEventDeadline!.timeIntervalSinceDate(currentTime)
        print("剩餘時間：",dateComponentsFormatter.stringFromTimeInterval(interval)!)
        
        
        let startDateAlertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .ActionSheet)
        let isSchedulingVC = UIAlertController(title: "正在排班中", message: "剩餘時間：\n\(dateComponentsFormatter.stringFromTimeInterval(interval)!)", preferredStyle: .Alert)

        let datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        datePickerView.datePickerMode = .Date
        
        datePickerView.addTarget(self, action: #selector(ManagerShiftViewController.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {(alert: UIAlertAction!)in
                
                self.shiftStartDate = ""
                self.selectedDate = ""
    
        })
        
        let okAction = UIAlertAction(title: "確認", style: .Default, handler:nil)
    
        let setShiftAction = UIAlertAction(title: "Confirm", style: .Default, handler:
            {(alert: UIAlertAction!) in
                 self.performSegueWithIdentifier("setEvent", sender: nil)
        })
        
        
        let presentSummaryViewAction = UIAlertAction(title: "Set", style: .Default, handler: {(alert: UIAlertAction!) in
            
            
            self.shiftStartDate = self.selectedDate
            
            
            
            
            //print("endDate: ",self.shiftEndDate)
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            // Set date format
            dateFormatter.dateFormat = "yyyy-M-dd"
            //dateFormatter.timeZone = NSTimeZone.localTimeZone()
            
            
            if self.shiftStartDate == "" {
                self.shiftStartDate = dateFormatter.stringFromDate(NSDate.now())
                
            }
            
            
            let summaryAlertVC = UIAlertController(title: "欲排班日期", message: self.shiftStartDate ,preferredStyle: .ActionSheet)
            
            summaryAlertVC.addAction(setShiftAction)
            summaryAlertVC.addAction(cancelAction)
            
            self.presentViewController(summaryAlertVC, animated: true, completion: nil)
            
         })
        
        
        
        startDateAlertVC.view.addSubview(datePickerView)
        
        startDateAlertVC.addAction(presentSummaryViewAction)
        startDateAlertVC.addAction(cancelAction)
        
        isSchedulingVC.addAction(okAction)
        
        if self.isSchedulingSwitch == true{
            print("is scheduling")
            self.presentViewController(isSchedulingVC, animated: true, completion: nil)
        }else{
            if self.setEventSwitch == true{
                
                self.performSegueWithIdentifier("setEvent", sender: nil)
                
            }else {
                self.presentViewController(startDateAlertVC, animated: true, completion: nil)
                
            }
            
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
        
        performSegueWithIdentifier("showDetailSegue", sender: nil)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        let setEventDBREF = FIRDatabase.database().reference()
        
        setEventDBREF.child("managerEvent").child("010").observeEventType(.Value, withBlock:{
            
            snapshot in
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-M-dd"
            
            self.setEventSwitch = snapshot.childSnapshotForPath("setEventSwitch").value as! Bool
            self.shiftStartDate = snapshot.childSnapshotForPath("currentEvent").value as! String
            self.isSchedulingSwitch = snapshot.childSnapshotForPath("isSchedulingSwitch").value as! Bool
            
            let deadlineString = snapshot.childSnapshotForPath("currentEventDeadline").value as! String
            print(deadlineString)
            self.currentEventDeadline = dateFormatter.dateFromString(deadlineString)
            print("DL",self.currentEventDeadline)
            
            
            
        })
        
        self.weeklyView.forceReload()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue"{
            let destinationVC = segue.destinationViewController as! ManagerShiftDetailViewController
            
            destinationVC.currentWeekStartDate = currentWeekStartDate
            destinationVC.selectedEvent = selectedEvent //from eventSelected
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "setEvent"{
            
            let destinationVC = segue.destinationViewController as! ManagerSetEventViewController
            
            destinationVC.shiftStartDate = self.shiftStartDate
            
            print("ShiftStartDate",self.shiftStartDate)
            
      
            
            let setEventDBREF = FIRDatabase.database().reference()
            setEventDBREF.child("managerEvent").child("010").child("setEventSwitch").setValue(true)
            setEventDBREF.child("managerEvent").child("010").child("currentEvent").setValue(self.shiftStartDate)

            
        
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

        
        }
        
    }
    
    
    func loadData(){
        
        
        var newEventArray = [MSEvent]()
        
        newEventArray = []

        let eventDBRef = FIRDatabase.database().reference()
        
        //print("Current Week",self.currentWeekStartDate)
        
        eventDBRef.child("managerShift").child("010").child(self.currentWeekStartDate).observeEventType(.ChildAdded, withBlock: {
            
            snapshot in
            
            //print("inside")
            
            let post = snapshot.value as! [String :AnyObject ]
            
            let startDateString = post["Start Date"] as! String
            
            let eventID = snapshot.key
        
            let endDateString = post["End Date"] as! String
            
            let eventType = post["Type"] as! String
            
            //print(snapshot.value)
            
            let codingList = snapshot.childSnapshotForPath("Coding").value
            let cleaningList = snapshot.childSnapshotForPath("Cleaning").value
            let dancingList = snapshot.childSnapshotForPath("Dancing").value
            
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(eventType)\n\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, codingList: codingList as! [[String:String]], cleaningList: cleaningList as! [[String:String]], dancingList:dancingList as![[String:String]] ,shiftType: eventType)
            
            
            
            
            let event1: MSEvent = MSEvent.make(self.shiftDate, duration: 0, title: "", location: "")
            let event2: MSEvent = MSEvent.make(self.shiftDate.addDays(1), duration: 0, title: "", location: "")
            let event3: MSEvent = MSEvent.make(self.shiftDate.addDays(2), duration: 0, title: "", location: "")
            let event4: MSEvent = MSEvent.make(self.shiftDate.addDays(3), duration: 0, title: "", location: "")
            let event5: MSEvent = MSEvent.make(self.shiftDate.addDays(4), duration: 0, title: "", location: "")
            let event6: MSEvent = MSEvent.make(self.shiftDate.addDays(5), duration: 0, title: "", location: "")
            let event7: MSEvent = MSEvent.make(self.shiftDate.addDays(6), duration: 0, title: "", location: "")
            
            
            
            newEventArray.append(newEvent)
            
            print(newEventArray)
                        
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
    }
    
    
    func weekView(weekView: MSWeekView!, newDaysLoaded startDate: NSDate!, to endDate: NSDate!) -> Bool {
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
