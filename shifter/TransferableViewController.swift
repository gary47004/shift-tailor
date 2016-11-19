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
    var distanceArray = [String]()
    var transferableArray = [Bool]()
    var currentSID = String()
    
    override func viewDidLoad() {
        self.title = "調撥門市"
                
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentSID = tabBarVC.currentSID
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("store/\(currentSID)/transferable").observeEventType(.ChildAdded, withBlock: { snapshot in
            let store = snapshot.key
            let transferable = snapshot.value as! Bool
            
            self.storeArray.append(store)
            self.transferableArray.append(transferable)
            self.tableView.reloadData()
            
        })

        
        databaseRef.child("store/\(currentSID)/distance").observeEventType(.ChildAdded, withBlock: { snapshot in
            let distance = snapshot.value as! String
            
            self.distanceArray.append(distance)
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = storeArray[indexPath.row]
        let distanceLabel = UILabel(frame: CGRectMake(284,11,60,21))
        if distanceArray != []{
            distanceLabel.text = distanceArray[indexPath.row] + " km"
            cell.addSubview(distanceLabel)
        }
        
        if transferableArray[indexPath.row] == true{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    //make transferable
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        transferableArray[indexPath.row] = true
        let databaseRef  = FIRDatabase.database().reference()
        let store = storeArray[indexPath.row]
        databaseRef.child("store/\(currentSID)/transferable/").updateChildValues([ store : true ])
    }
    
    //make untransferable
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        transferableArray[indexPath.row] = false
        let databaseRef  = FIRDatabase.database().reference()
        let store = storeArray[indexPath.row]
        databaseRef.child("store/\(currentSID)/transferable/").updateChildValues([ store : false ])
    }
    
}