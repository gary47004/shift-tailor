//
//  TabBarViewController.swift
//  shifter
//
//  Created by Frank Wang on 2016/10/13.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TabBarViewController: UITabBarController {
    var currentUID = String()
    var newNotification = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("bulletin").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            self.newNotification += 1
            self.tabBar.items?[2].badgeValue = String(self.newNotification)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
