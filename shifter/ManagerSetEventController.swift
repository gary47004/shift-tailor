//
//  ViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/9/5.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import EasyDate
import DateTools

struct eventStruct{
    let startDate: NSDate!
    let endDate: NSDate!
    let coding: Int
    let dancing: Int
    let cleaning: Int
    let key: String!
    
}

//extension NSNull {
//    func length() -> Int { return 0 }
//    
//    func integerValue() -> Int { return 0 }
//    
//    func floatValue() -> Float { return 0 };
//    
//    //func description() -> String { return "0(NSNull)" }
//    
//    func componentsSeparatedByString(separator: String) -> [AnyObject] { return [AnyObject]() }
//    
//    func objectForKey(key: AnyObject) -> AnyObject? { return nil }
//    
//    func boolValue() -> Bool { return false }
//}


class ManagerSetEventViewController: UIViewController,UIPopoverPresentationControllerDelegate,MenuButtonDelegate,MSWeekViewDelegate,MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate, MSWeekViewInfiniteDelegate{

   
    
    @IBOutlet weak var weeklyView: MSWeekView!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    
    var  selectedEvent = MSEvent()
    
    var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
 
    var longPressDate: NSDate!
    
    //let currentDate = NSDate()
    
    var shiftStartDateString: String!
        
    var shiftDate : NSDate!
    
    var menuButtonTapped : String?
    
    

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        let shiftDateFormatter = NSDateFormatter()
        let weekStartDateFormatter = NSDateFormatter()
        let weekEndDateFormatter = NSDateFormatter()

        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekStartDateFormatter.dateFormat = "MMM d"
        weekEndDateFormatter.dateFormat = "MMM d"
        
        self.shiftDate = shiftDateFormatter.dateFromString(shiftStartDateString)!
        
        let convertedDate = weekStartDateFormatter.stringFromDate(shiftDate)
        
        let weekEndDate = weekEndDateFormatter.stringFromDate(shiftDate.addDays(6))
        
        titleItem.title = "\(convertedDate) - \(weekEndDate)"
        
        self.setupWeekData()

    }
    
    
    
    @IBAction func popoverMenu(sender: UIBarButtonItem) {
        performSegueWithIdentifier("popoverMenu", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "addEventSegue"{
            
            
            let destinationVC = segue.destinationViewController as! addEventTableViewController
            
            destinationVC.shiftStartDateString = self.shiftStartDateString
            
            destinationVC.longPressDate = longPressDate
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "delete"{
            
            let destinationVC = segue.destinationViewController as! editEventTableViewController
            
            destinationVC.event = selectedEvent //from eventSelected
            
            destinationVC.shiftStartDateString = self.shiftStartDateString
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "popoverMenu"{
            
            let destinationVC = segue.destinationViewController as! PopoverMenuViewController
            destinationVC.preferredContentSize = CGSizeMake(200, 100)
            
            let popoverController = destinationVC.popoverPresentationController
            
            if popoverController != nil{
                popoverController?.delegate = self
            }
            
            destinationVC.delegate = self
        }
    }
    
   
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
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
        print("Yeeeeeeeeeeeeeeees")
        weeklyView.delegate = self
        
        weeklyView.weekFlowLayout.show24Hours = true
        
        weeklyView.daysToShowOnScreen = 7
        
        weeklyView.daysToShow = 0
        
        weeklyView.weekFlowLayout.hourHeight = 50
        
        weeklyView.events = [event1,event2,event3,event4,event5,event6,event7]
        
        //weeklyView.removeEvent(event1)
    }
    
   
    
  
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        
        
        selectedEvent = event
        
        performSegueWithIdentifier("delete", sender: nil)
        
        let editDBRef = FIRDatabase.database().reference()
        
        
        editDBRef.child("managerEvent").child("010").child("2016-10-16").observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            
            let eventID = snapshot.key
//            let startDateString = snapshot.value!["Start Date"] as! String
//            let endDateString = snapshot.value!["End Date"] as! String
//            let coding = snapshot.value!["Coding"] as! Int
//            let dancing = snapshot.value!["Dancing"] as! Int
//            let cleaning = snapshot.value!["Cleaning"] as! Int
            
            
            if eventID != "" {
                
                self.weeklyView.removeEvent(event)
                
            }

            
            
        })
        
    }
    
    func buttonTapped(buttonTapped: String) {
        self.menuButtonTapped = buttonTapped
        print("MenuButtonTapped : ", menuButtonTapped)
        
        if menuButtonTapped == "send"{
        }else if menuButtonTapped == "drop"{
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var newEventArray = [MSEvent]()
        
        
        
        //self.weeklyView.events = []
        
        let eventDBRef = FIRDatabase.database().reference()
        
        
        
        //eventDBRef.child("managerEvent").child("010").child(shiftStartDateString).child("00001").removeValue()
        
        eventDBRef.child("managerEvent").child("010").child(shiftStartDateString).queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            

            
            print(snapshot.value)
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
            
            self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(shortStartDateString) \(coding)", location: "\(shortEndDateString)", key: eventID, coding: coding, dancing: dancing, cleaning: cleaning)
            
            
            
            let event1: MSEvent = MSEvent.make(self.shiftDate, duration: 0, title: "", location: "")
            let event2: MSEvent = MSEvent.make(self.shiftDate.addDays(1), duration: 0, title: "", location: "")
            let event3: MSEvent = MSEvent.make(self.shiftDate.addDays(2), duration: 0, title: "", location: "")
            let event4: MSEvent = MSEvent.make(self.shiftDate.addDays(3), duration: 0, title: "", location: "")
            let event5: MSEvent = MSEvent.make(self.shiftDate.addDays(4), duration: 0, title: "", location: "")
            let event6: MSEvent = MSEvent.make(self.shiftDate.addDays(5), duration: 0, title: "", location: "")
            let event7: MSEvent = MSEvent.make(self.shiftDate.addDays(6), duration: 0, title: "", location: "")
            
            //newEventArray = [event1,event2,event3,event4,event5,event6,event7]
            
            
            print("aaaaaaaaaaaaaaaaaaaaaaaa",newEvent.StartDate.day())
            
            
            
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
        
        NSLog("Long pressed at: ", longPressDate)
        
        performSegueWithIdentifier("addEventSegue", sender: nil)
        

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





/*
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 
 if segue.identifier == "addEventPopover"{
 
 let addEventPopoverVC = segue.destinationViewController
 
 addEventPopoverVC.preferredContentSize = CGSizeMake(650, 600)
 
 let popoverController = addEventPopoverVC.popoverPresentationController
 
 if popoverController != nil{
 popoverController?.delegate = self
 }
 
 
 }
 }
 
 
 func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
 return .None
 }
 */


