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
import CoreLocation

class EmployeeWeekViewController: UIViewController, MSWeekViewDelegate, CLLocationManagerDelegate {
    
    //GY
    @IBOutlet weak var rangingOutlet: UIBarButtonItem!
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString:"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, identifier: "THLight")
    let testBeacon = [CLBeacon]()
    var formatter = NSDateFormatter()
    var myCalendar = NSCalendar.currentCalendar()
    var weekDay = ""
    var firstDay = ""
    var storagePlace = ""
    var arrival : String?
    var departure : String?
    var intervalA:Int?
    var intervalB:Int?
    var managerAttendStoragePlace = ""
    var managerAttendenceStoragePlace = ""
    struct managerShiftDataStruct{
        let key : String?
    }
    var managerShiftData = [managerShiftDataStruct]()
    //GY

    
    var  selectedEvent = MSEvent()
    
    //var eventList = [eventStruct]()
    
    var decoratedWeekView: MSWeekView!
    
    @IBOutlet weak var nextWeekButton: UIBarButtonItem!
   
    @IBOutlet weak var previousWeekButton: UIBarButtonItem!
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
    
    var currentWeekNumber : Int = 0
    
    var announcementSwitch : Bool? = false

    var nextWeekStartDate: String! = ""
    
    var currentUID = String()
    var currentSID = String()
    var currentRank = String()
    var currentProfession = String()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentRank = tabBarVC.currentRank
        currentProfession = tabBarVC.currentPro
        
        
        
        
        //GY
        rangingOutlet.enabled = false
        //GY
        
        self.employeeSetEventButton.title = ""
        
        
       // var newEventArray = [MSEvent]()

        
        
        let shiftDBRef = FIRDatabase.database().reference()
        
       
        shiftDBRef.child("employeeShift").child(self.currentSID).child("currentShift").observeEventType(.Value, withBlock: {
            
            
            snapshot in
            
            print(snapshot)
            self.currentWeekStartDate = snapshot.value as! String
            
            let shiftDateFormatter = NSDateFormatter()
            
            shiftDateFormatter.dateFormat = "yyyy-M-dd"
            
            self.shiftDate = shiftDateFormatter.dateFromString(self.currentWeekStartDate)
            
            
            self.setupWeekData()
            
            self.observeData()
            
            self.loadData(0)
            
            
            
            
        })
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
        
        weeklyView.weekFlowLayout.hourHeight = 18
        
        weeklyView.events = [event1,event2,event3,event4,event5,event6,event7]
      
    }
    
    
    
    
    
    // week View Delegate
    
    
    //GY
    @IBAction func rangingButton(sender: UIBarButtonItem) {
        
        locationManager.delegate = self;
        
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
        }
        //允許app使用位置
        locationManager.startRangingBeaconsInRegion(region)
        //開始搜尋
        locationManager(locationManager, didRangeBeacons:testBeacon, inRegion: region)
        
    }
    
    
    func weekView(sender: AnyObject!, eventSelected event: MSEvent!) {
        
        let compareResultA = event.StartDate.compare(currentDate)
        let compareResultB = event.EndDate.compare(currentDate)
        intervalA = Int(event.StartDate.timeIntervalSinceDate(currentDate))
        intervalB = Int(event.EndDate.timeIntervalSinceDate(currentDate))
        if(intervalA <= 10800 && intervalB >= -10800){
            rangingOutlet.enabled = true
        }else{
            rangingOutlet.enabled = false
        }
        //差距三小時＝10800秒
        
        weekDay = event.key
        //weekDay = "00"+"\(myCalendar.component(.Weekday, fromDate: currentDate))"
        
        //let addingNumber = 1-Int(myCalendar.component(.Weekday, fromDate: currentDate))
        
        //let firstDayOfWeek = myCalendar.dateByAddingUnit(.Day, value: addingNumber, toDate: currentDate, options: [])
        //現在日期加上addingNumber的日期
        formatter.dateFormat = "yyyy-M-dd"
        //firstDay = formatter.stringFromDate(firstDayOfWeek!)
        firstDay = "2016-12-12"
        
        
        storagePlace = "employeeShift/"+currentSID+"/"+firstDay+"/"+currentUID+"/"+weekDay
        managerAttendStoragePlace = "managerShift/"+currentSID+"/"+firstDay+"/"+"Day6"+"/"+currentProfession
        
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(managerAttendStoragePlace).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let Id = snapshot.value!["ID"] as? String
            let Key = snapshot.key
            
            if(Id == self.currentUID){
                self.managerShiftData.insert(managerShiftDataStruct(key: Key), atIndex: 0)
            }
        })
        
        
        databaseRef.child(storagePlace).observeEventType(.Value, withBlock: {
            snapshot in
            
            self.arrival = snapshot.value!["arrivalTime"] as? String
            self.departure = snapshot.value!["departureTime"] as? String
            
            print(self.arrival)
            print(self.departure)
            //最後才跑＊重要＊
            //有可能還是沒資料（還沒跑完），再設定按鈕enabled時間在跑完arrival,departure後
        })
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        let nearBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown}
        //只要有測到，就放進nearBeacons
        if (nearBeacons.count > 0){
            
            locationManager.stopRangingBeaconsInRegion(region)
            //停止搜尋
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-M-dd-H:mm"
            let time = dateFormatter.stringFromDate(date)
            
            
            let clockIn = UIAlertController(title: "是否打卡？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            //actionsheet無法
            let goToWork = UIAlertAction(title: "上班打卡", style: UIAlertActionStyle.Default, handler:{
                (action:UIAlertAction) -> () in
                self.postArrival(time)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            let getOff = UIAlertAction(title: "下班打卡", style: UIAlertActionStyle.Default, handler: {
                (action:UIAlertAction) -> () in
                self.postDeparture(time)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:{
                (action:UIAlertAction) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            let close = UIAlertAction(title: "關閉", style: UIAlertActionStyle.Default, handler:{
                (action:UIAlertAction) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            if(arrival == nil && departure == nil){
                clockIn.addAction(goToWork)
                clockIn.addAction(cancel)
                self.presentViewController(clockIn, animated: true, completion: nil)
                
            }else if(arrival != nil && departure == nil){
                clockIn.addAction(getOff)
                clockIn.addAction(cancel)
                self.presentViewController(clockIn, animated: true, completion: nil)
                
            }else if(arrival != nil && departure != nil){
                clockIn.title = "您已經在這個時段打卡完成"
                clockIn.message = "同一時段無法打兩次卡"
                clockIn.addAction(close)
                self.presentViewController(clockIn, animated: true, completion: nil)
            }
        }
        
        print("BEACONS: " + "\(beacons)")
        print("NEAR BEACONS: " + "\(nearBeacons)")
        
    }
    
    
    func postArrival(arrival : String){
        
        let post : [String : AnyObject] = ["arrivalTime" : arrival]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(storagePlace).updateChildValues(post)
        
        if(intervalA<0){
            let number = String(0-intervalA!)
            let late : [String : String] = ["late" : number]
            databaseRef.child(storagePlace).updateChildValues(late)
            databaseRef.child(managerAttendenceStoragePlace).updateChildValues(late)
        }else{
            let number = "0"
            let late : [String : String] = ["late" : number]
            databaseRef.child(storagePlace).updateChildValues(late)
            databaseRef.child(managerAttendenceStoragePlace).updateChildValues(late)
        }
        
    }
    
    func postDeparture(departure : String){
        
        let post : [String : AnyObject] = ["departureTime" : departure]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(storagePlace).updateChildValues(post)
        
        if(intervalB>0){
            let number = String(intervalB!-0)
            let leaveEarly : [String : String] = ["leaveEarly" : number]
            databaseRef.child(storagePlace).updateChildValues(leaveEarly)
            databaseRef.child(managerAttendenceStoragePlace).updateChildValues(leaveEarly)
        }else{
            let number = "0"
            let leaveEarly : [String : String] = ["leaveEarly" : number]
            databaseRef.child(storagePlace).updateChildValues(leaveEarly)
            databaseRef.child(managerAttendenceStoragePlace).updateChildValues(leaveEarly)
        }
        
    }
    //GY
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        let eventDBRef = FIRDatabase.database().reference()
        
        
        
        eventDBRef.child("employeeEvent").child(self.currentSID).observeEventType(.Value, withBlock: {
            
            snapshot in
            
            
            self.setEvnetSwitch = snapshot.childSnapshotForPath("setEventSwitch").value as! Bool
            self.shiftStartDate = snapshot.childSnapshotForPath("currentEvent").value as! String
            
            print("排班",self.shiftStartDate)
            
            if self.setEvnetSwitch == true{
                self.employeeSetEventButton.title = "填表"
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
            
    
        })

        
        
        self.weeklyView.forceReload()
        
    }
    @IBAction func showNextWeek(sender: UIBarButtonItem) {
        
        
        var weekDateFormmater = NSDateFormatter()
        
        weekDateFormmater.dateFormat = "yyyy-M-dd"
        
        currentWeekNumber += 1
        
        self.currentWeekStartDate = weekDateFormmater.stringFromDate(shiftDate.addDays(7))
        
        let event1: MSEvent = MSEvent.make(shiftDate.addDays(7), duration: 0, title: "", location: "")
        
        let event2: MSEvent = MSEvent.make(shiftDate.addDays(8), duration: 0, title: "", location: "")
        
        let event3: MSEvent = MSEvent.make(shiftDate.addDays(9), duration: 0, title: "", location: "")
        let event4: MSEvent = MSEvent.make(shiftDate.addDays(10), duration: 0, title: "", location: "")
        let event5: MSEvent = MSEvent.make(shiftDate.addDays(11), duration: 0, title: "", location: "")
        let event6: MSEvent = MSEvent.make(shiftDate.addDays(12), duration: 0, title: "", location: "")
        let event7: MSEvent = MSEvent.make(shiftDate.addDays(13), duration: 0, title: "", location: "")
        
        weeklyView.events = [event1,event2,event3,event4,event5,event6,event7]

        
        nextWeekButton.enabled = false
        previousWeekButton.enabled = true
        
        
        observeData()
        loadData(currentWeekNumber * 7)
        
        

    }
    @IBAction func showPreviousWeek(sender: UIBarButtonItem) {
        var weekDateFormmater = NSDateFormatter()
        
        weekDateFormmater.dateFormat = "yyyy-M-dd"
        
        
        currentWeekNumber -= 1
        
        self.currentWeekStartDate = weekDateFormmater.stringFromDate(shiftDate.addDays(-7))
        nextWeekButton.enabled = true
        previousWeekButton.enabled = false
        
        observeData()
        
        
        loadData(currentWeekNumber * 7)

    }
    
    func observeData(){
        
        let eventDBRef = FIRDatabase.database().reference()
        eventDBRef.child("employeeShift").child(self.currentSID).child(self.currentWeekStartDate).child(self.currentUID).observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            self.loadData(0)
        })
        
        eventDBRef.child("employeeShift").child(self.currentSID).child(self.currentWeekStartDate).child(self.currentUID).observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            self.loadData(0)
            
        })
        

    }
    
    
 
    func loadData(addDateNumber: Int){
        
        let weekDateFormatter = NSDateFormatter()
        let shiftDateFormatter = NSDateFormatter()
        
        
        shiftDateFormatter.dateFormat = "yyyy-M-dd"
        weekDateFormatter.dateFormat = "MMM d"
        
        var shiftStartDateString: String!
        var shiftEndDateString: String!
        
        self.shiftDate = shiftDateFormatter.dateFromString(self.currentWeekStartDate)
        
        self.nextWeekStartDate = shiftDateFormatter.stringFromDate(self.shiftDate.addDays(7))
        
        shiftStartDateString = weekDateFormatter.stringFromDate(self.shiftDate)
        
        shiftEndDateString = weekDateFormatter.stringFromDate(self.shiftDate.addDays(6))
        
        self.titleItem.title = "\(shiftStartDateString) - \(shiftEndDateString)"

        
        var newEventArray = [MSEvent]()
        
        newEventArray = []
        
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeShift").child(self.currentSID).child(self.nextWeekStartDate).child("announcementSwitch").observeEventType(.Value, withBlock: {
        
        snapshot in
            
            self.announcementSwitch = snapshot.value as? Bool
            
            if self.announcementSwitch == true{
                self.nextWeekButton.enabled = true
            }else{
                self.nextWeekButton.enabled = false
            }
            
            print("ANOUN",self.announcementSwitch)
        
        })
        eventDBRef.child("employeeShift").child(self.currentSID).child(self.currentWeekStartDate).child(self.currentUID).queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            
            
            snapshot in
            
            
            
            let startDateString = snapshot.value!["startDate"] as! String
            
            let endDateString = snapshot.value!["endDate"] as! String
            
            let late = snapshot.value!["late"] as? String
            
            let eventKey = snapshot.key
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            
            
            let newEvent = MSEvent.makeEmployeeShiftEvent(startDate, end: endDate, title: "\(shortStartDateString)", location: "\(shortEndDateString)", key: eventKey, late: late)
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



