
//
//  Settings.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/15.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentName = String()
    var currentUID = String()
    var currentSID = String()
    
    var settingsArray = [String]()
    
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        //UI
        self.tableView.backgroundColor = UIColor(red: 43, green: 43, blue: 50)
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentName = tabBarVC.currentName
        
        settingsArray = ["    提醒設定","    調撥門市","    更改密碼","    登出"]
        
        IDLabel.text = "ID：" + currentUID
        nameLabel.text = "姓名：" + currentName
        storeLabel.text = "門市：" + currentSID
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "設定"
        self.navigationController?.title = ""
        self.tabBarController?.tabBar.hidden = false
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = settingsArray[indexPath.row]
        
        //UI
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: ".PingFan TC", size: 18)
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(18)
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 14, green: 14, blue: 14).CGColor
        if indexPath.row == 0{
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else if indexPath.row == 1{
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //GY
        if indexPath.row == 0{
            performSegueWithIdentifier("showAlarmClock", sender: nil)
        //GY
        
        }else if indexPath.row == 1{
            performSegueWithIdentifier("showTransferable", sender: nil)
            self.title = "Back"
    
        }else if indexPath.row == 2{
            
            let alertController = UIAlertController(title: "Change Password", message: "please enter new password", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField) in
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) in
            })
            let enterAction = UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                let textField = alertController.textFields![0] as UITextField
                let defaults = NSUserDefaults.standardUserDefaults()
                let currentUID = defaults.objectForKey("currentUID") as! String
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("employee/\(currentUID)").updateChildValues([ "password" : textField.text! ])
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(enterAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else if indexPath.row == 3{
            //logout alert
            let alertController = UIAlertController(title: "Logout", message: "logout from account \(currentUID)", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) in
            })
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                //save status
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: "loggedin")
                let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewContoller
                self.presentViewController(loginVC, animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
           
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
