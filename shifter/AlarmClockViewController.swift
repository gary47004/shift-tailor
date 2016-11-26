//
//  AlarmClockViewController.swift
//  shifter
//
//  Created by gary on 2016/11/26.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AlarmClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var id = ""
    var alarmStoragePlace = ""
    var minutes:Int = 0
    let defaults = NSUserDefaults.standardUserDefaults()
    //宣告手機應用程式儲存空間
    
    
    @IBAction func alarmSwitch(alarmOutlet: UISwitch) {
        let databaseRef = FIRDatabase.database().reference()
        
        if(alarmOutlet.on==true){
            let post : [String : String] = ["switch" : "on"]
            databaseRef.child(alarmStoragePlace).updateChildValues(post)
            defaults.setBool(true, forKey: "switchState")
        }else{
            let post : [String : String] = ["switch" : "off"]
            databaseRef.child(alarmStoragePlace).updateChildValues(post)
            defaults.setBool(false, forKey: "switchState")
        }
        
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func pickerChange(sender: UIDatePicker) {
        minutes = Int((datePicker.countDownDuration)/60)
        self.timeLabel.text = "在上班前"+"\(String(minutes))"+"分鐘提醒我"
        
        let databaseRef = FIRDatabase.database().reference()
        let post : [String : String] = ["interval" : String(minutes)]
        databaseRef.child(alarmStoragePlace).updateChildValues(post)
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提醒設定"
        let tabBarVC = self.tabBarController as? TabBarViewController
        id = tabBarVC!.currentUID
        alarmStoragePlace = "employee/"+"\(id)"+"/alarmClock"
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmSwitchCell") as! AlarmSwitchTableViewCell
        //as! alarmClockSwitchCell（class）
        cell.textLabel?.text = "上班提醒"
        if defaults.boolForKey("switchState") == true {
            cell.alarmOutlet.on = true
        }else if defaults.boolForKey("switchState") == false {
            cell.alarmOutlet.on = false
        }
        return cell
    }
}
