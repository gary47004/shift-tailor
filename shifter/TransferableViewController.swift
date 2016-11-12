//
//  TransferableViewController.swift
//  shifter
//
//  Created by Frank Wang on 2016/11/10.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TransferableViewController: UITableViewController {
    var storeArray = [String]()
    var distantArray = [AnyObject]()
    
    override func viewDidLoad() {
        self.title = "調撥門市"
                
        let tabBarVC = self.tabBarController as! TabBarViewController
        let currentSID = tabBarVC.currentSID
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("store/\(currentSID)/transferable").observeEventType(.ChildAdded, withBlock: { snapshot in
            let store = snapshot.key
            
            self.storeArray.insert(store, atIndex: 0)
            self.tableView.reloadData()
        })

//        databaseRef.child("store/\(currentSID)/transferable").observeEventType(.ChildAdded, withBlock: { snapshot in
//            let store = snapshot.key
//
//            self.storeArray.insert(store, atIndex: 0)
//            self.tableView.reloadData()
//        })
        
        databaseRef.child("store/\(currentSID)/distant").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            print(snapshot)
//            let store = snapshot.key
//            print(store)
            let distant = snapshot.value!["020"] as? String
//
            print(distant)
            
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = storeArray[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
}