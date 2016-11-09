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
    
    var newNotification = Int()
    
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    
    var selectedSection = Int()
    var selectedRow = Int()

    override func viewDidLoad() {                                                               
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        currentUID = defaults.objectForKey("currentUID") as! String
        currentSID = defaults.objectForKey("currentSID") as! String
        currentDID = defaults.objectForKey("currentDID") as! String
        currentRank = defaults.objectForKey("currentRank") as! String
        print("TTTTTTTTTTTTTTT",currentUID,currentSID,currentDID,currentRank)
        
        print("tabBar Loaded")
        
        //set Firebase listener
        let databaseRef = FIRDatabase.database().reference()
        
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
                        self.newNotification += 1
                        self.tabBar.items?[2].badgeValue = String(self.newNotification)
                    }
                }else{
                    //posted district post
                    self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: 0)
                    self.section1Refs.insert(postRef, atIndex: 0)
                    
                    if employee != self.currentUID{
                        self.newNotification += 1
                        self.tabBar.items?[2].badgeValue = String(self.newNotification)
                    }
                }
            }else{
                //posted by other store
                if district == self.currentDID{
                    //other store posted district post
                    if section == 1{
                        self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee, store: store, district: district), atIndex: 0)
                        self.section1Refs.insert(postRef, atIndex: 0)
                        
                        if employee != self.currentUID{
                            self.newNotification += 1
                            self.tabBar.items?[2].badgeValue = String(self.newNotification)
                        }
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
                                    self.newNotification += 1
                                    self.tabBar.items?[2].badgeValue = String(self.newNotification)
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
