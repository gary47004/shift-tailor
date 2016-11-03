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
    let store : String!
    let district : String!
}

class Bulletin: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var currentUID = String()
    var currentSID = String()
    var currentRank = String()
    
    @IBOutlet weak var tableView0: UITableView!
    @IBOutlet weak var tableView1: UITableView!
   
    
    override func viewDidLoad() {
        //get values when loaded first time
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        section0Posts = tabBarVC.section0Posts
        section1Posts = tabBarVC.section1Posts
        section0Refs = tabBarVC.section0Refs
        section1Refs = tabBarVC.section1Refs
        currentSID = tabBarVC.currentSID
        currentRank = tabBarVC.currentRank
        
        //only manager can compose
        if currentRank != "storeManager"{
            navigationItem.rightBarButtonItem = nil
        }
        
        //update arrays and reload tableView when detected changes
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in //things in block run after tableView
            self.section0Posts = tabBarVC.section0Posts
            self.section1Posts = tabBarVC.section1Posts
            self.section0Refs = tabBarVC.section0Refs
            self.section1Refs = tabBarVC.section1Refs
            self.tableView0.reloadData()
            self.tableView1.reloadData()
        })
        
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.section0Posts = tabBarVC.section0Posts
            self.section1Posts = tabBarVC.section1Posts
            self.section0Refs = tabBarVC.section0Refs
            self.section1Refs = tabBarVC.section1Refs
            self.tableView0.reloadData()
            self.tableView1.reloadData()
        })

        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildChanged, withBlock: { snapshot in
            self.section0Posts = tabBarVC.section0Posts
            self.section1Posts = tabBarVC.section1Posts
            self.section0Refs = tabBarVC.section0Refs
            self.section1Refs = tabBarVC.section1Refs
            self.tableView0.reloadData()
            self.tableView1.reloadData()
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "公告欄"
        self.tabBarController?.tabBar.hidden = false
        tableView0.reloadData()
        tableView1.reloadData()
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
        let tabBarVC = self.tabBarController as! TabBarViewController

        if tableView == tableView0{
            tabBarVC.selectedSection = 0
            tabBarVC.selectedRow = indexPath.row
        }else{
            tabBarVC.selectedSection = 1
            tabBarVC.selectedRow = indexPath.row
        }
        performSegueWithIdentifier("bulletinDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
    
    //pressed compose
    @IBAction func composeButton(sender: UIBarButtonItem) {
        self.title = "Cancel"
        performSegueWithIdentifier("bulletinCompose", sender: nil)
    }

}
