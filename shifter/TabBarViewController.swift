//
//  TabBarViewController.swift
//  shifter
//
//  Created by Frank Wang on 2016/10/13.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TabBarViewController: UITabBarController {
    var currentUID = String()
    var currentSID = String()
    var currentDID = String()
    var currentRank = String()
    var currentPro = String()
    
    var newNotifications = Int()
    var oldNotifications = Int()
    var notifications = Int()
    
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    
    var selectedSection = Int()
    var selectedRow = Int()
    
    
    //GY
    let now = NSDate()
    var formatter = NSDateFormatter()
    let myCalendar = NSCalendar.currentCalendar()
    var firstDay = ""
    var interval:String?
    let notification:UILocalNotification = UILocalNotification()
    
    
    func alarmClock() {
        let addingNumber = 1-Int(myCalendar.component(.Weekday, fromDate: now))
        let firstDayOfWeek = myCalendar.dateByAddingUnit(.Day, value: addingNumber, toDate: now, options: [])
        //現在日期加上addingNumber的日期
        formatter.dateFormat = "yyyy-M-dd"
        firstDay = formatter.stringFromDate(firstDayOfWeek!)
        let storagePlace = "employeeShift/"+"\(currentSID)"+"/"+"\(firstDay)"+"/"+"\(currentUID)"
        
        formatter.dateFormat = "yyyy-M-dd-H:mm"
        let counterInterval = 0-Int(interval!)!
        var alarmTime = [NSDate]()
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(storagePlace).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let start = snapshot.value!["Start Date"] as? String
            if(start != nil){
                
                let date = self.formatter.dateFromString(start!)
                let time = self.myCalendar.dateByAddingUnit(.Minute, value: counterInterval, toDate: date!, options: [])
                
                alarmTime.insert(time!, atIndex: 0)
                print(alarmTime)
                
                
                self.notification.alertBody = "該上班囉"
                self.notification.alertAction = "該準備去上班囉"
                self.notification.fireDate = alarmTime[0]
                self.notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(self.notification)
                
            }
        })
    }
    //GY
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        tabBar.barTintColor = UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 100/255)
        tabBar.tintColor = UIColor.whiteColor()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        currentUID = defaults.objectForKey("currentUID") as! String
        currentSID = defaults.objectForKey("currentSID") as! String
        currentDID = defaults.objectForKey("currentDID") as! String
        currentRank = defaults.objectForKey("currentRank") as! String
        currentPro = defaults.objectForKey("currentProfession") as! String
        
        
        //set Firebase listener
        let databaseRef = FIRDatabase.database().reference()
        
        
        //GY
        let alarmStoragePlace = "employee/"+"\(currentUID)"+"/alarmClock"
        databaseRef.child(alarmStoragePlace).observeEventType(.Value, withBlock: {
            snapshot in
            
            let alarmState = snapshot.value!["switch"] as? String
            self.interval = snapshot.value!["interval"] as? String
            
            UIApplication.sharedApplication().cancelLocalNotification(self.notification)
            
            if( alarmState == "on" ){
                self.alarmClock()
            }
        })
        
        //GY

        
        //child added
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in 
            let title = snapshot.value!["title"] as? String
            let time = snapshot.value!["time"] as? String
            let content = snapshot.value!["content"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["employee"] as? String
            let store = snapshot.value!["store"] as? String
            let district = snapshot.value!["district"] as? String
            let postRef = snapshot.key  //set keys for each post for removing
            
            //save to local array
            if store == self.currentSID{
                //posted by store member
                if section == 0{
                    // posted store post
                    self.section0Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: 0)
                    self.section0Refs.insert(postRef, atIndex: 0)
                                        
                    //notification
                    if employee != self.currentUID{
                        self.notifications += 1
                        let defaults = NSUserDefaults.standardUserDefaults()
                        if defaults.objectForKey("oldNotifications") != nil{
                            self.oldNotifications = defaults.objectForKey("oldNotifications") as! Int
                        }
                        self.newNotifications = self.notifications - self.oldNotifications
                        if self.newNotifications > 0{
                            self.tabBar.items?[2].badgeValue = String(self.newNotifications)
                        }
                    }
                }else{
                    //posted district post
                    self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: 0)
                    self.section1Refs.insert(postRef, atIndex: 0)
                    
                    if employee != self.currentUID{
                        self.notifications += 1
                        let defaults = NSUserDefaults.standardUserDefaults()
                        if defaults.objectForKey("oldNotifications") != nil{
                            self.oldNotifications = defaults.objectForKey("oldNotifications") as! Int
                        }
                        self.newNotifications = self.notifications - self.oldNotifications
                        if self.newNotifications > 0{
                            self.tabBar.items?[2].badgeValue = String(self.newNotifications)
                        }                    }
                }
            }else{
                //posted by other store
                if district == self.currentDID{
                    //other store posted district post
                    if section == 1{
                        self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: 0)
                        self.section1Refs.insert(postRef, atIndex: 0)
                        
                        if employee != self.currentUID{
                            self.notifications += 1
                            let defaults = NSUserDefaults.standardUserDefaults()
                            if defaults.objectForKey("oldNotifications") != nil{
                                self.oldNotifications = defaults.objectForKey("oldNotifications") as! Int
                            }
                            self.newNotifications = self.notifications - self.oldNotifications
                            if self.newNotifications > 0{
                                self.tabBar.items?[2].badgeValue = String(self.newNotifications)
                            }                        }
                    }
                }
            }
        })
        
        //child removed
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildRemoved, withBlock: {snapshot in
            let section = snapshot.value!["section"] as? Int
            let store = snapshot.value!["store"] as? String
            let district = snapshot.value!["district"] as? String
            let postRef = snapshot.key
            
            if store == self.currentSID{
                //posted by self
                if section == 0{
                    //self removed store post
                    if let index = self.section0Refs.indexOf({ $0 as! String == postRef }){
                        self.section0Refs.removeAtIndex(index)
                        self.section0Posts.removeAtIndex(index)
                    }
                }else{
                    //self removed district post
                    if let index = self.section1Refs.indexOf({ $0 as! String == postRef }){
                        self.section1Refs.removeAtIndex(index)
                        self.section1Posts.removeAtIndex(index)
                    }
                }
            }else{
                //posted by other store
                if district == self.currentDID{
                    //other store removed their district post
                    if let index = self.section1Refs.indexOf({ $0 as! String == postRef }){
                        self.section1Refs.removeAtIndex(index)
                        self.section1Posts.removeAtIndex(index)
                    }
                }
            }
        })
        
        //child changed
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildChanged, withBlock: {snapshot in
            let title = snapshot.value!["title"] as? String
            let time = snapshot.value!["time"] as? String
            let content = snapshot.value!["content"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["employee"] as? String
            let store = snapshot.value!["store"] as? String
            let district = snapshot.value!["district"] as? String
            let postRef = snapshot.key
            
            if store == self.currentSID{
                //posted by self
                if section == 0{
                    //is in self's section 0
                    if self.section0Refs.contains({ $0 as? String == postRef }) == true{
                        //already in self's section 0(self edited self's store post)
                        if let index = self.section0Refs.indexOf({ $0 as? String == postRef}){
                            self.section0Refs[index] = postRef
                            self.section0Posts[index] = post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district)
                        }
                    }else{
                        //not in self's section 0(self changed self's district post to store)
                        if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                            self.section0Refs.removeAtIndex(index)
                            self.section0Posts.removeAtIndex(index)
                            self.section1Refs.insert(postRef , atIndex: index)
                            self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: index)
                        }
                    }
                }else{
                    //is in self's section 2
                    if self.section1Refs.contains({ $0 as? String == postRef }){
                        //already in self's section 2(self edited self's district post)
                        if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                            self.section1Refs[index] = postRef
                            self.section1Posts[index] = post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district)
                        }
                    }else{
                        //not in self's section 2(self changed self's store post to district)
                        if let index = self.section0Refs.indexOf({ $0 as? String == postRef }){
                            self.section0Refs.removeAtIndex(index)
                            self.section0Posts.removeAtIndex(index)
                            self.section1Refs.insert(postRef , atIndex: index)
                            self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: index)
                        }
                    }
                }
            }else{
                if district == self.currentDID{
                    //other store posted
                    if self.section1Refs.contains({ $0 as? String == postRef }){
                        //already in self's section 2(other store edited district post)
                        if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                            self.section1Refs[index] = postRef
                            self.section1Posts[index] = post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district)
                        }
                    }else{
                        //not in self's section 2
                        if section == 0{
                            //not in other store's section2(other store changed their district post to store)
                            if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                                self.section1Refs.removeAtIndex(index)
                                self.section1Posts.removeAtIndex(index)
                            }
                        }else{
                            //is in other store's section 2(other store cganged their store post to district)
                            if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                                self.section1Refs.insert(postRef , atIndex: index)
                                self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: index)
                                
                                if employee != self.currentUID{
                                    self.notifications += 1
                                    let defaults = NSUserDefaults.standardUserDefaults()
                                    if defaults.objectForKey("oldNotifications") != nil{
                                        self.oldNotifications = defaults.objectForKey("oldNotifications") as! Int
                                    }
                                    self.newNotifications = self.notifications - self.oldNotifications
                                    if self.newNotifications > 0{
                                        self.tabBar.items?[2].badgeValue = String(self.newNotifications)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
