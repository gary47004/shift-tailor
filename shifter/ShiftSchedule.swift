//
//  ShiftSchedule.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/13.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit


class ShiftSchedule: UIViewController {
    var currentUID = String()
    
    override func viewDidLoad() {
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
    }

}
