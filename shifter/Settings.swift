
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

class Settings: UITableViewController {
    var currentUID = String()
    var settingsArray = [String]()
    
    override func viewDidLoad() {
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        settingsArray = ["ID: \(currentUID)","    提醒設定","    調撥門市","    更改密碼","    登出"]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "設定"
        self.navigationController?.title = ""
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }else{
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = settingsArray[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 74,green: 74,blue: 74)
        cell.textLabel?.font = UIFont(name: ".PingFan TC", size: 18)
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(18)
        
        if indexPath.row == 0{

            cell.imageView?.image = UIImage(named: "ID icon")
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //GY
        if indexPath.row == 1{
            performSegueWithIdentifier("showAlarmClock", sender: nil)
        //GY
        
        }else if indexPath.row == 2{
            performSegueWithIdentifier("showTransferable", sender: nil)
            self.title = "Back"
    
        }else if indexPath.row == 3{
            
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
            
        }else if indexPath.row == 4{
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
