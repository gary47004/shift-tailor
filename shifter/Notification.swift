//
//  Notification.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/15.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
let notificationArray = ["[開會提醒] 明天早上十一點要開會噢"]//[String]()

class Notification: UITableViewController {
   
    //set tableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = notificationArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("notificationDetail")
        self.navigationController?.pushViewController(notificationDetailVC, animated: true)
        self.title = "Back"
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "通知"
    }
    
   
}
