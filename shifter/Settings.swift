//
//  Settings.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/15.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class Settings: UITableViewController {
    
    var settingsArray = ["帳號設定","更改密碼","提醒設定","About Us"]
    
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = settingsArray[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        self.title = "設定"
    }

}
