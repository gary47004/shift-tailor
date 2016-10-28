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
    var newNotification = Int()
    
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    
    var selectedSection = Int()
    var selectedRow = Int()

    override func viewDidLoad() {                                                               
        super.viewDidLoad()
        
        //set Firebase listener
        let databaseRef = FIRDatabase.database().reference()
        
        //child added
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in 
            let title = snapshot.value!["title"] as? String
            let time = snapshot.value!["time"] as? String
            let content = snapshot.value!["content"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["employee"] as? String
            let postRef = snapshot.key  //set keys for each post for removing
            
            //save to local array
            if section == 0{
                self.section0Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section0Refs.insert(postRef, atIndex: 0)
            }else{
                self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section1Refs.insert(postRef, atIndex: 0)
            }
            
            //notification
            self.newNotification += 1
            self.tabBar.items?[2].badgeValue = String(self.newNotification)
            
        })
        
        //child removed
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildRemoved, withBlock: {snapshot in
            let section = snapshot.value!["section"] as? Int
            let postRef = snapshot.key
            
            if section == 0{
                if let index = self.section0Refs.indexOf({ $0 as! String == postRef }){
                    self.section0Refs.removeAtIndex(index)
                    self.section0Posts.removeAtIndex(index)
                }
            }else{
                if let index = self.section1Refs.indexOf({ $0 as! String == postRef }){
                    self.section1Refs.removeAtIndex(index)
                    self.section1Posts.removeAtIndex(index)
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
            let postRef = snapshot.key
            
            if section == 0{
                if self.section0Refs.contains({ $0 as? String == postRef }) == true{
                    if let index = self.section0Refs.indexOf({ $0 as? String == postRef}){
                        self.section0Refs[index] = postRef
                        self.section0Posts[index] = post(title: title, time: time, content: content, section: section, employee: employee)
                    }
                }else{
                    if let index = self.section1Refs.indexOf({ $0 as? String == postRef }){
                        self.section1Refs.removeAtIndex(index)
                        self.section1Posts.removeAtIndex(index)
                        self.section0Refs.insert(postRef , atIndex: index)
                        self.section0Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: index)
                    }
                }
            }else{
                if self.section1Refs.contains({ $0 as? String == postRef }){
                    if let index = self.section0Refs.indexOf({ $0 as? String == postRef }){
                        self.section1Refs[index] = postRef
                        self.section1Posts[index] = post(title: title, time: time, content: content, section: section, employee: employee)
                    }
                }else{
                    if let index = self.section0Refs.indexOf({ $0 as? String == postRef }){
                        self.section0Refs.removeAtIndex(index)
                        self.section0Posts.removeAtIndex(index)
                        self.section1Refs.insert(postRef , atIndex: index)
                        self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: index)
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
