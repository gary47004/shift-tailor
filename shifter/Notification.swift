//
//  Notification.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/15.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct notification {
    let title : String!
    let type : String!
    let key : String!
    let selectedSection : Int!
    let selectedRow : Int!
    let image : String!
}

class Notification: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var section0Key = [String]()
    var section1Key = [String]()
    var currentUID = String()
    var currentSID = String()
    var currentDID = String()
    
    var notificationArray = [notification]()
    var selectedRowIn0 = Int()
    var selectedRowIn1 = Int()
    
    var releaseDate = String()
    var currentWeekStartDateArray = [String]()
    var currentWeekEndDateArray = [String]()
    var currentWeekDate = Int()
    
    var nextWeekStartDateArray = [String]()
    var nextWeekEndDateArray = [String]()
    var nextWeekDate = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.rowHeight = 48
        tableView.registerNib(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentDID = tabBarVC.currentDID
        currentWeekStartDateArray = tabBarVC.currentWeekStartDateArray
        currentWeekEndDateArray = tabBarVC.currentWeekEndDateArray
        nextWeekStartDateArray = tabBarVC.nextWeekStartDateArray
        nextWeekEndDateArray = tabBarVC.nextWeekEndDateArray
        releaseDate = tabBarVC.releaseDate
        
    
        
        //set listener
        let databaseRef = FIRDatabase.database().reference()
        
        
        
        
        //bulletin new post
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            let title = snapshot.value!["title"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["employee"] as? String
            let store = snapshot.value!["store"] as? String
            let district = snapshot.value!["district"] as? String
            let key = snapshot.key
            
            if store == self.currentSID{
                if employee != self.currentUID{

                    if section == 0 {
                        //store's post
                        self.selectedRowIn0 += 1
                        self.notificationArray.insert(notification(title: title, type: "門市公告", key: key, selectedSection: section, selectedRow: self.selectedRowIn0, image: "bulletin noti"), atIndex: 0)
                        self.section0Key.insert(key, atIndex: 0)
                    }else{
                        //company's post
                        self.selectedRowIn1 += 1
                        self.notificationArray.insert(notification(title: title, type: "公司公告", key: key, selectedSection: section, selectedRow: self.selectedRowIn1, image: "bulletin noti"), atIndex: 0)
                        self.section1Key.insert(key, atIndex: 0)

                    }
                }
            }else{
                if district == self.currentDID{
                    //company's post
                    self.selectedRowIn1 += 1
                    print(self.selectedRowIn1)
                    self.notificationArray.insert(notification(title: title, type: "公司公告", key: key, selectedSection: section, selectedRow: self.selectedRowIn1, image: "bulletin noti"), atIndex: 0)
                }
            }
            
        self.tableView.reloadData()
            
        })
        
        //fill-in
        databaseRef.child("managerEvent/\(self.currentSID)/isSchedulingSwitch").observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.value as! Int == 1{
                self.nextWeekDate += 1
                self.fillInNotification()
                self.tableView.reloadData()
            }
            
        })
        
        //shift schedule released
        databaseRef.child("managerShift/\(self.currentSID)/\(self.releaseDate)/announcementSwitch").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value as! Int == 1{
                self.currentWeekDate += 1
                print("currentWeekDate",self.currentWeekDate)
                print("currentWeekStartDate",self.currentWeekStartDateArray)
                print("currentWeekEndDate",self.currentWeekEndDateArray)
                self.releasedNotification()
                self.tableView.reloadData()
            }
        })
    }
    
    func fillInNotification(){
        notificationArray.insert(notification(title: "\(nextWeekStartDateArray[nextWeekDate-1])-\(nextWeekEndDateArray[nextWeekDate-1])已開始填表", type: "開始填表", key: nil, selectedSection: nil, selectedRow: nil, image: "fill in"), atIndex: 0)
    }
    
    func releasedNotification() {
        if currentWeekDate > 0{
            notificationArray.insert(notification(title: "\(currentWeekStartDateArray[currentWeekDate-1])-\(currentWeekEndDateArray[currentWeekDate-1])班表已公布", type: "班表發佈", key: nil, selectedSection: nil, selectedRow: nil, image: "released"), atIndex: 0)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "通知"
        self.navigationController?.title = ""
        
        //checked new notifications: hide tab bar item badge, mark new notifcaitons
        tabBarController?.tabBar.items?[2].badgeValue = nil
        let tabBarVC = self.tabBarController as! TabBarViewController
        tabBarVC.oldNotifications += tabBarVC.newNotifications
        tabBarVC.newNotifications = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tabBarVC.oldNotifications, forKey: "oldNotifications")
        
    }
    
    //set tableView
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        cell!.setTitle(notificationArray[indexPath.row].title)
        cell!.setNotificationImage(notificationArray[indexPath.row].image)
//        cell?.ImageIcon.image = UIImage(named: notificationArray[indexPath.row].image)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if notificationArray[indexPath.row].type == "門市公告" || notificationArray[indexPath.row].type == "公司公告"{
            let tabBarVC = self.tabBarController as! TabBarViewController
            
            //set selected section and row
            tabBarVC.selectedSection = notificationArray[indexPath.row].selectedSection
            if tabBarVC.selectedSection == 0{
                tabBarVC.selectedRow = section0Key.indexOf(notificationArray[indexPath.row].key)!
            }else{
                tabBarVC.selectedRow = section1Key.indexOf(notificationArray[indexPath.row].key)!
            }
            
            
            //go to bulletinDetail
            performSegueWithIdentifier("showPost", sender: nil)

        }else if notificationArray[indexPath.row].type == "班表發佈"{
            //到發佈畫面
        }else if notificationArray[indexPath.row].type == "開始填表"{
            //到填表畫面
        }
    }
    
    
    
   
}
