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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
