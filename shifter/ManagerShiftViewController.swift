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
    
    var shiftStartDateString : String = "sssssssss"
    
    var shiftEndDate: String = ""
    
    
    let storeID = "010"
    
    var selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
    var setEventSwitch : Bool = false
    
    
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    
    @IBOutlet weak var weeklyView: MSWeekView!
    
    //var longPressDate: NSDate!
    
    let currentDate = NSDate()
    
    //var codingList = [AnyObject]()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWeekData()
        
        let weekStartDateFormatter = NSDateFormatter()
        let weekEndDateFormatter = NSDateFormatter()
        
        
        weekStartDateFormatter.dateFormat = "MMM d"
        weekEndDateFormatter.dateFormat = "MMM d"
        
        let convertedDate = weekStartDateFormatter.stringFromDate(currentDate)
        
        let weekEndDate = weekEndDateFormatter.stringFromDate(currentDate.addDays(6))
        
        titleItem.title = "\(convertedDate) - \(weekEndDate)"
        

        
        
        
        
        
        let eventDBRef = FIRDatabase.database().referenceFromURL("https://shifter-35349.firebaseio.com/ManagerShift/010/2016-10-16")
        
        eventDBRef.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let post = snapshot.value as! [String :AnyObject ]
            
            let startDateString = post["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = post["End Date"] as! String
            
            let eventType = post["Type"] as! String
            
            print(snapshot.childSnapshotForPath("Cleaning"))
            
            let codingList = snapshot.childSnapshotForPath("Coding").value
            let cleaningList = snapshot.childSnapshotForPath("Cleaning").value
            let dancingList = snapshot.childSnapshotForPath("Dancing").value
            
            print(cleaningList![0][1])
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-H:mm"
            
            print("aaaaaaaaaaaaaaaa",startDateString)
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(eventType)\n\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, codingList: codingList as! [[String]], cleaningList: cleaningList as! [[String]], dancingList:dancingList as![[String]] ,shiftType: eventType)
           
            
            print(newEvent)
            print(newEvent.StartDate)
           
            
            self.weeklyView.addEvent(newEvent)
            
            
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
        let startDateAlertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .ActionSheet)

        let datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        datePickerView.datePickerMode = .Date
        
        datePickerView.addTarget(self, action: #selector(ManagerShiftViewController.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {(alert: UIAlertAction!)in
                
                self.shiftStartDateString = ""
                self.selectedDate = ""
    
        })
        
        
        
        let setShiftAction = UIAlertAction(title: "Confirm", style: .Default, handler:
            {(alert: UIAlertAction!) in
                 self.performSegueWithIdentifier("setEvent", sender: nil)
        })
        
        
        let presentSummaryViewAction = UIAlertAction(title: "Set", style: .Default, handler: {(alert: UIAlertAction!) in
            
            
            self.shiftStartDateString = self.selectedDate
            
            
            
            print("sssssssss", self.shiftStartDateString)
            
            //print("endDate: ",self.shiftEndDate)
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            // Set date format
            dateFormatter.dateFormat = "yyyy-M-dd"
            //dateFormatter.timeZone = NSTimeZone.localTimeZone()
            
            
            if self.shiftStartDateString == "" {
                self.shiftStartDateString = dateFormatter.stringFromDate(NSDate.now())
                
            }
            
            
            let summaryAlertVC = UIAlertController(title: "欲排班日期", message: self.shiftStartDateString ,preferredStyle: .ActionSheet)
            
            summaryAlertVC.addAction(setShiftAction)
            summaryAlertVC.addAction(cancelAction)
            
            self.presentViewController(summaryAlertVC, animated: true, completion: nil)
            
         })
        
        
        
        startDateAlertVC.view.addSubview(datePickerView)
        
        startDateAlertVC.addAction(presentSummaryViewAction)
        startDateAlertVC.addAction(cancelAction)
        
        if self.setEventSwitch == true{
            
            self.performSegueWithIdentifier("setEvent", sender: nil)
            
        }else {
            self.presentViewController(startDateAlertVC, animated: true, completion: nil)
            
        }
        
        

    }
        
    
       func setupWeekData(){
        
        self.decoratedWeekView = MSWeekViewDecoratorFactory.make(self.weeklyView, features: 3 , andDelegate: self)
        
        
        let event1: MSEvent = MSEvent.make(NSDate.now().addMonth(), duration: 200, title: "333", location: "333")
        
        
        weeklyView.delegate = self
        
        weeklyView.weekFlowLayout.show24Hours = true
        
        weeklyView.daysToShowOnScreen = 7
        
        weeklyView.daysToShow = 7
        
        weeklyView.weekFlowLayout.hourHeight = 50
        
        weeklyView.events = [event1]
        //weeklyView.removeEvent(event1)
    }
    
    
    
    
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        print(event.StartDate, event.EndDate)
        print(event.cleaningList)
        
        selectedEvent = event
        
        performSegueWithIdentifier("showDetailSegue", sender: nil)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var neweEventArray = [MSEvent]()
        
        let eventDBRef = FIRDatabase.database().referenceFromURL("https://shifter-35349.firebaseio.com/ManagerShift/010/2016-10-16")
        
        eventDBRef.observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            let post = snapshot.value as! [String :AnyObject ]
            
            let startDateString = post["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = post["End Date"] as! String
            
            let eventType = post["Type"] as! String
            
            //print(snapshot.childSnapshotForPath("Coding"))
            
            let codingList = snapshot.childSnapshotForPath("Coding").value
            let cleaningList = snapshot.childSnapshotForPath("Cleaning").value
            let dancingList = snapshot.childSnapshotForPath("Dancing").value
            
            //print(codingList![0])
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-H:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(eventType)\n\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, codingList: codingList as! [[String]], cleaningList: cleaningList as! [[String]], dancingList:dancingList as! [[String]] ,shiftType: eventType)
            
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa")
            
            print(newEvent.StartDate)
            
            neweEventArray.append(newEvent)
            
            
            self.weeklyView.events = neweEventArray
            
            
            
            
        })
        
        let setEventDBREF = FIRDatabase.database().reference()
        
        setEventDBREF.child("managerEvent").child("010").child("setEventSwitch").observeEventType(.Value, withBlock:{
            
            snapshot in
            
            print("sssssssssssssnaaaaaaapshot",snapshot.value)
            
            self.setEventSwitch = snapshot.value as! Bool
            
            print("SSSSSSSWWWWWWWWWWIIIIIII", self.setEventSwitch )
            
            
        })
        
        setEventDBREF.child("managerEvent").child("010").child("currentEvent").observeEventType(.Value, withBlock: {
            
            snapshot in
            
            self.shiftStartDateString = snapshot.value as! String
            
            print("START",self.shiftStartDateString)
            
            
        })
        
        
        
        
        self.weeklyView.forceReload()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue"{
            let destinationVC = segue.destinationViewController as! ManagerShiftDetailViewController
            
            destinationVC.selectedEvent = selectedEvent //from eventSelected
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "setEvent"{
            
            print(shiftStartDateString)
            

            
            let destinationVC = segue.destinationViewController as! ManagerSetEventViewController
            
            destinationVC.shiftStartDateString = self.shiftStartDateString
            
            let setEventDBREF = FIRDatabase.database().reference()
            setEventDBREF.child("managerEvent").child("010").child("setEventSwitch").setValue(true)
            setEventDBREF.child("managerEvent").child("010").child("currentEvent").setValue(self.shiftStartDateString)

            
        
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

        
        }
        
    }
    
    
    
    
    
    func weekView(weekView: MSWeekView!, newDaysLoaded startDate: NSDate!, to endDate: NSDate!) -> Bool {
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
