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

class Notification: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleArray = [String]()
    var typeArray = [String]()
    var sectionArray = [Int]()
    var section0Key = [String]()
    var section1Key = [String]()
    var keyArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.registerNib(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        //set listener
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            let title = snapshot.value!["title"] as? String
            let section = snapshot.value!["section"] as? Int
            let key = snapshot.key
            
            self.titleArray.insert(title!, atIndex: 0)
            self.typeArray.insert("公告欄", atIndex: 0)
            self.sectionArray.insert(section!, atIndex: 0)
            self.keyArray.insert(key, atIndex: 0)
            if section == 0{
                self.section0Key.insert(key, atIndex: 0)
            }else{
                self.section1Key.insert(key, atIndex: 0)
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "通知"
        tabBarController?.tabBar.items?[2].badgeValue = nil
        let tabBarVC = self.tabBarController as? TabBarViewController
        tabBarVC?.newNotification = 0
        
    }
    
    //set tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        cell?.setType(typeArray[indexPath.row])
        cell?.setTitle(titleArray[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if typeArray[indexPath.row] == "公告欄"{
            print("present post")
            
            let tabBarVC = self.tabBarController as! TabBarViewController
            
            //set selected section and row
            let selectedSection = sectionArray[indexPath.row]
            var selectedRow = Int()
            if selectedSection == 0{
                selectedRow = section0Key.indexOf(keyArray[indexPath.row])!
            }else{
                selectedRow = section1Key.indexOf(keyArray[indexPath.row])!
            }
            
            tabBarVC.selectedSection = selectedSection
            tabBarVC.selectedRow = selectedRow
            
            //go to bulletinDetail
            let bulletinDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("clockinVC")
            self.tabBarController?.
//            showViewController(bulletinDetailVC, sender: self)
//            self.presentViewController(bulletinDetailVC, animated: true, completion: nil)
        }
    }
    
    
    
   
}
