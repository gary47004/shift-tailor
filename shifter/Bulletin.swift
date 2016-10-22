//
//  Bulletin.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/13.
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

class Bulletin: UITableViewController {
    var sectionSelected = Int()
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var currentUID = String()


    override func viewDidLoad() {
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        
        //set listener
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("posts").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            //this func runs after tableView
            let title = snapshot.value!["title"] as? String
            let time = snapshot.value!["time"] as? String
            let content = snapshot.value!["content"] as? String
            let section = snapshot.value!["section"] as? Int
            let employee = snapshot.value!["emplyee"] as? String
            let postRef = snapshot.key  //get keys for each post(for deleting)
            
            //save to local array
            if section == 0{
                self.section0Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section0Refs.insert(postRef, atIndex: 0)
            }else{
                self.section1Posts.insert(post(title: title, time: time, content: content, section: section, employee: employee), atIndex: 0)
                self.section1Refs.insert(postRef, atIndex: 0)
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "公告欄"
        self.tabBarController?.tabBar.hidden = false
    }
    
    //set tableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        
        if section == 0{
            count = section0Posts.count
        }else{
            count = section1Posts.count
        }

        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0{
            cell.textLabel?.text = self.section0Posts[indexPath.row].title
        }else{
            cell.textLabel?.text = self.section1Posts[indexPath.row].title
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "店公告"
        }else{
            return "區公告"
        }
    }

    //set delete function
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let databaseRef = FIRDatabase.database().reference()
        
        if editingStyle == .Delete{
            if indexPath.section == 0{
                databaseRef.child("Posts").child(section0Refs[indexPath.row] as! String).removeValue() //remove from database
                section0Posts.removeAtIndex(indexPath.row)
                section0Refs.removeAtIndex(indexPath.row) //remove from local array
            }else{
                
                databaseRef.child("Posts").child(section1Refs[indexPath.row] as! String).removeValue()
                section1Posts.removeAtIndex(indexPath.row)
                section1Refs.removeAtIndex(indexPath.row) //remove from local array
                //remove from database
            }
        }
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.title = "Back" //set back button
        performSegueWithIdentifier("bulletinDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func composeButton(sender: UIBarButtonItem) {
        self.title = "Cancel"
        performSegueWithIdentifier("bulletinCompose", sender: nil)
    }
    

    //pass value to DetailVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow

        if segue.identifier == "bulletinDetail"{
            let detailVC = segue.destinationViewController as! BulletinDetail
            detailVC.selectedSection = indexPath!.section
            detailVC.selectedRow = indexPath!.row
            detailVC.section0Posts = section0Posts
            detailVC.section1Posts = section1Posts
            detailVC.section0Refs = section0Refs
            detailVC.section1Refs = section1Refs
        }else{
            let composeVC = segue.destinationViewController as! BulletinCompose
            composeVC.currentUID = currentUID
        }
    }
    
}
