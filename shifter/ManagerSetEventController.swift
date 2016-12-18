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
    let beverage: Int
    let cashier: Int
    let cleaning: Int
    let key: String!
    
}


class ManagerSetEventViewController: UIViewController,UIPopoverPresentationControllerDelegate,MenuButtonDelegate,MSWeekViewDelegate,MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate, MSWeekViewInfiniteDelegate{

   
    
    @IBOutlet weak var weeklyView: MSWeekView!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    
    var selectedEvent = MSEvent()
    
    var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
 
    var longPressDate: NSDate!
    
    //let currentDate = NSDate()
    
    var shiftStartDate: String!
        
    var shiftDate : NSDate!
    
    var menuButtonTapped : String?
    
    var deadlineDate : String!
    
    
    let weekDateFormatter = NSDateFormatter()
    
    var currentUID = String()
    var currentSID = String()
    var currentRank = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentRank = tabBarVC.currentRank
        
        
    
        let shiftDateFormatter = NSDateFormatter()

        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekDateFormatter.dateFormat = "MMM d"
        
        var shiftStartDateString: String!
        var shiftEndDateString: String!

        
        
        self.shiftDate = shiftDateFormatter.dateFromString(shiftStartDate)!
        
        
        shiftStartDateString = weekDateFormatter.stringFromDate(shiftDate)
        shiftEndDateString = weekDateFormatter.stringFromDate(shiftDate.addDays(6))
        
        titleItem.title = "\(shiftStartDateString) - \(shiftEndDateString)"
        
        self.setupWeekData()

    }
    
    
    
    @IBAction func popoverMenu(sender: UIBarButtonItem) {
        performSegueWithIdentifier("popoverMenu", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "addEventSegue"{
            
            
            let destinationVC = segue.destinationViewController as! addEventTableViewController
            
            destinationVC.shiftStartDate = self.shiftStartDate
            
            destinationVC.longPressDate = longPressDate
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem

            
        }else if segue.identifier == "delete"{
            
            let destinationVC = segue.destinationViewController as! editEventTableViewController
            
            destinationVC.event = selectedEvent //from eventSelected
            
            destinationVC.shiftStartDate = self.shiftStartDate
            
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
        
        weeklyView.delegate = self
        
        weeklyView.weekFlowLayout.show24Hours = true
        
        weeklyView.daysToShowOnScreen = 7
        
        weeklyView.daysToShow = 0
        
        weeklyView.weekFlowLayout.hourHeight = 30
        
        weeklyView.events = [event1,event2,event3,event4,event5,event6,event7]
        
        //weeklyView.removeEvent(event1)
    }
    
   
    
  
    
    // week View Delegate
    
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        
        
        selectedEvent = event
        
        performSegueWithIdentifier("delete", sender: nil)
        
        let editDBRef = FIRDatabase.database().reference()
        
        
        editDBRef.child("managerEvent").child(self.currentSID).child(shiftStartDate).observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            
            let eventID = snapshot.key
//            let startDateString = snapshot.value!["Start Date"] as! String
//            let endDateString = snapshot.value!["End Date"] as! String
//            let beverage = snapshot.value!["beverage"] as! Int
//            let cashier = snapshot.value!["cashier"] as! Int
//            let cleaning = snapshot.value!["cleaning"] as! Int
            
            
            if eventID != "" {
                
                self.weeklyView.removeEvent(event)
                
            }

            
            
        })
        
    }
    
    func datePickerValueChanged(sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-M-dd"
        
        // Apply date format
        self.deadlineDate = dateFormatter.stringFromDate(sender.date)
        
        print("Selected value \(deadlineDate)")
    }
    
    
    func setDeadlineDate() {
        let setDeadlineDateVC = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "請選取填表期限", preferredStyle: .ActionSheet)
        
        let datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        
        datePickerView.datePickerMode = .Date
        
        datePickerView.addTarget(self, action: #selector(ManagerShiftViewController.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        let cancelAction = UIAlertAction(title: "取消",style: .Cancel, handler: {(alert:UIAlertAction) in
            
            self.deadlineDate = ""
            
        })
        
        let setDeadlineAction = UIAlertAction(title: "發送填表通知", style: .Default, handler:{(alert:UIAlertAction) in
            
            let eventDBRef = FIRDatabase.database().reference()
            eventDBRef.child("managerEvent").child(self.currentSID).child("currentEventDeadline").setValue(self.deadlineDate)
            eventDBRef.child("managerEvent").child(self.currentSID).child("setEventSwitch").setValue(false)
            eventDBRef.child("managerEvent").child(self.currentSID).child("isSchedulingSwitch").setValue(true)
            
            
            

            
            
            
            let completeVC = UIAlertController(title: "已完成排班", message: "將於 \(self.deadlineDate) 收到班表",preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: {(alert:UIAlertAction) in
                
                                /*
                 
                 
                 
                 填表通知
                 
                 
                 對象：該店員工
                 回傳：填表介面 EmployeeEventWeekViewController
                 
                 
                 
                 
                 */
                
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                
            })
            
            completeVC.addAction(confirmAction)
            
            self.presentViewController(completeVC, animated: true, completion: nil)
        })
        
        
        setDeadlineDateVC.view.addSubview(datePickerView)
        setDeadlineDateVC.addAction(cancelAction)
        setDeadlineDateVC.addAction(setDeadlineAction)
        
        self.presentViewController(setDeadlineDateVC, animated: true, completion: nil)
        
        print("present send VC")


    }
    
    func dropEvent() {
        
        let startDateFormatter = NSDateFormatter()
        
        startDateFormatter.dateFormat = "yyyy-M-dd"
        
        let endDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "M-dd"
        var shiftStartDateString: String!
        var shiftEndDateString: String!

        shiftStartDateString = startDateFormatter.stringFromDate(self.shiftDate)
        shiftEndDateString = endDateFormatter.stringFromDate(self.shiftDate.addDays(6))
        
        
        
        
        let dropEventVC = UIAlertController(title: "取消排班", message: "確定要取消 \(shiftStartDateString) - \(shiftEndDateString) 的排班嗎？", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default, handler: {(alert:UIAlertAction) in
        
            let eventDBRef = FIRDatabase.database().reference()
            eventDBRef.child("managerEvent").child(self.currentSID).child(self.shiftStartDate).removeValue()
            eventDBRef.child("managerEvent").child(self.currentSID).child("setEventSwitch").setValue(false)
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        
        
        })
        
        dropEventVC.addAction(cancelAction)
        dropEventVC.addAction(confirmAction)
        
        self.presentViewController(dropEventVC, animated: true, completion: nil)
    }

    
    func buttonTapped(buttonTapped: String) {
        self.menuButtonTapped = buttonTapped
        print("MenuButtonTapped : ", menuButtonTapped)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        
        var newEventArray = [MSEvent]()
        
        
        
        //self.weeklyView.events = []
        
        let eventDBRef = FIRDatabase.database().reference()
        
        
        
        //eventDBRef.child("managerEvent").child(self.currentSID).child(shiftStartDate).child("00001").removeValue()
        
        eventDBRef.child("managerEvent").child(self.currentSID).child(shiftStartDate).queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            print("Snapshot",snapshot.value)

        
            
            let startDateString = snapshot.value!["StartDate"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = snapshot.value!["EndDate"] as! String
            
            let beverage = snapshot.value!["beverage"] as! Int
            
            
            let cashier = snapshot.value!["cashier"] as! Int
            
            let cleaning = snapshot.value!["cleaning"] as! Int
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, beverage: beverage, cashier: cashier, cleaning: cleaning, key: eventID))
            
            
            
            let newEvent = MSEvent.makeManagerEventEvent(startDate, end: endDate, title: "\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, beverage: beverage, cashier: cashier, cleaning: cleaning)
            
            
            
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


