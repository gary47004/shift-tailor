//
//  Bulletin2.swift
//  shifter
//
//  Created by Frank Wang on 2016/10/24.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct post {
    let title : String!
    let time : String!
    let content : String!
    let section : Int!
    let employee : String!
}

class Bulletin: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sectionSelected = Int()
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var currentUID = String()
    
    @IBOutlet weak var tableView0: UITableView!
    @IBOutlet weak var tableView1: UITableView!
   
    
    override func viewDidLoad() {
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        
//        //set obsever for notification
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Bulletin.tableView(_:didSelectRowAtIndexPath:)), name: notificationKey, object: nil)
        
        //set listener
        let databaseRef = FIRDatabase.database().reference()
        
        //child added
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            //this func runs after tableView
            let title = snapshot.value!["title"] as? String
            let time = snapshot.value!["time"] as? String
            let content = snapshot.value!["content"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["employee"] as? String
            let postRef = snapshot.key  //get keys for each post(for deleting)
            
            //save to local array
            if section == 0{
                self.section0Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section0Refs.insert(postRef, atIndex: 0)
                self.tableView0.reloadData()
            }else{
                self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section1Refs.insert(postRef, atIndex: 0)
                self.tableView1.reloadData()
            }
            
        })
        
        //child removed
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildRemoved, withBlock: {snapshot in
            let section = snapshot.value!["section"] as? Int
            let postRef = snapshot.key
            
            if section == 0{
                if let index = self.section0Refs.indexOf({ $0 as! String == postRef }){
                    self.section0Refs.removeAtIndex(index)
                    self.section0Posts.removeAtIndex(index)
                    self.tableView0.reloadData()
                }
            }else{
                if let index = self.section1Refs.indexOf({ $0 as! String == postRef }){
                    self.section1Refs.removeAtIndex(index)
                    self.section1Posts.removeAtIndex(index)
                    self.tableView1.reloadData()
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
            self.tableView0.reloadData()
            self.tableView1.reloadData()
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "公告欄"
        self.tabBarController?.tabBar.hidden = false
    }

    //set tableViews
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView0{
            return section0Posts.count
        }else{
            return section1Posts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if tableView == self.tableView0{
            cell.textLabel?.text = self.section0Posts[indexPath.row].title
        }else{
            cell.textLabel?.text = self.section1Posts[indexPath.row].title
        }
        return cell
    }
    
    //pressed cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.title = "Back" //set back button
        if tableView == tableView0{
            sectionSelected = 0
        }else{
            sectionSelected = 1
        }
        performSegueWithIdentifier("bulletinDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
    
    //pressed compose
    @IBAction func composeButton(sender: UIBarButtonItem) {
        self.title = "Cancel"
        performSegueWithIdentifier("bulletinCompose", sender: nil)
    }
    
    //pass value to DetailVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "bulletinDetail"{
            var indexPath = NSIndexPath()
            if sectionSelected == 0{
                indexPath = self.tableView0.indexPathForSelectedRow!
            }else{
                indexPath = self.tableView1.indexPathForSelectedRow!
            }
            
            let detailVC = segue.destinationViewController as! BulletinDetail
            detailVC.selectedSection = sectionSelected
            detailVC.selectedRow = indexPath.row
            detailVC.section0Posts = section0Posts
            detailVC.section1Posts = section1Posts
            detailVC.section0Refs = section0Refs
            detailVC.section1Refs = section1Refs
            detailVC.currentUID = currentUID
        }else{
            let composeVC = segue.destinationViewController as! BulletinCompose
            composeVC.currentUID = currentUID
        }
    }


    

}
