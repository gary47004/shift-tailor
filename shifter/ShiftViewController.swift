//
//  HomeViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/15.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class ShiftViewController: UIViewController {

    @IBOutlet weak var employeeContainerView: UIView!
    @IBOutlet weak var managerContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var currentRank = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentRank = tabBarVC.currentRank
        
        if currentRank == "partTime"{
            segmentedControl.selectedSegmentIndex = 1
            self.managerContainerView.alpha = 0
            self.employeeContainerView.alpha = 1
            let employeeSeg = UIImageView(frame: CGRect(x: 0, y: 20, width: 375, height: 45))
            employeeSeg.image = UIImage(named: "employeeSegment")
            self.view.addSubview(employeeSeg)
            self.reloadInputViews()
        }
        
        
        
        //UI
        view.subviews[0].backgroundColor = UIColor(red: 40, green: 40, blue: 40)
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.setWidth(189, forSegmentAtIndex: 0)
        segmentedControl.setWidth(189, forSegmentAtIndex: 1)
        segmentedControl.setBackgroundImage(UIImage(named: "selected segment"), forState: .Selected, barMetrics: .Default)
        segmentedControl.setBackgroundImage(UIImage(named: "deselected segment"), forState: .Normal, barMetrics: .Default)
        segmentedControl.setDividerImage(UIImage(named: "divider segment image - left"), forLeftSegmentState: .Selected, rightSegmentState: .Normal, barMetrics: .Default)
        segmentedControl.setDividerImage(UIImage(named: "divider segment image - right"), forLeftSegmentState: .Normal, rightSegmentState: .Selected, barMetrics: .Default)
        
    }
    
    @IBAction func showShiftView(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.managerContainerView.alpha = 1
                self.employeeContainerView.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.managerContainerView.alpha = 0
                self.employeeContainerView.alpha = 1
            })
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
