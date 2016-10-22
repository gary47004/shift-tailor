//
//  ManagerShiftDetailViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class ManagerShiftDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    var selectedEvent = MSEvent()
    
    var sectionTitleArray = [String]()
    
    let jobArray = ["","Coding","Cleaning","Dancing"]
    
    
    
    
    @IBOutlet weak var managerShiftDetailTableView: UITableView!
    
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sectionTitleArray = ["排班概況","Coding: \(selectedEvent.codingList.count) 位", "Cleaning: \(selectedEvent.cleaningList.count) 位", "Dancing: \(selectedEvent.dancingList.count) 位"]
        
        let titleFormatter = NSDateFormatter()
        titleFormatter.dateFormat = "MMM dd eee"
        
        self.titleItem.title = titleFormatter.stringFromDate(selectedEvent.StartDate) + "  " + selectedEvent.shiftType

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitleArray[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let conditionCell = self.managerShiftDetailTableView.dequeueReusableCellWithIdentifier("ConditionCell") as! ConditionTableViewCell
        let employeeCell = self.managerShiftDetailTableView.dequeueReusableCellWithIdentifier("EmployeeCell") as! ShiftEmployeeTableViewCell
        
        conditionCell.totalEmployeeLabel.text = "總共： 人"
        conditionCell.lackingEmployeeLabel.text = "缺少： 人"
        
        let empStartDate: NSDate
        let empEndDate: NSDate
        
        let shortFormatter = NSDateFormatter()
        shortFormatter.dateFormat = "H:mm"
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateFormat = "yyyy-M-dd-H:mm"
        if indexPath.section == 1{
            employeeCell.employeeNameLabel.text = selectedEvent.codingList[indexPath.row][0] as? String
            
        
            
            
        }else if indexPath.section == 2 {
            employeeCell.employeeNameLabel.text = selectedEvent.cleaningList[indexPath.row][0] as? String
            
            print(selectedEvent.cleaningList[indexPath.row][1])
            
            empStartDate = dateformatter.dateFromString((selectedEvent.cleaningList[indexPath.row][1] as? String)!)!
            empEndDate = dateformatter.dateFromString((selectedEvent.cleaningList[indexPath.row][2] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
            
        }else if indexPath.section == 3 {
            employeeCell.employeeNameLabel.text = selectedEvent.dancingList[indexPath.row][0] as? String
        }
        
        
        
        //employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.StartDate)
        //employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.EndDate)
        
        
        
        if indexPath.section == 0{
            return conditionCell
            
        }else{
            return employeeCell
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return selectedEvent.codingList.count
        }else if section == 2{
            return selectedEvent.cleaningList.count
        }else if section == 3{
            return selectedEvent.dancingList.count
        }else{
            return 0
        }
    }
    @IBAction func deploymentEmployee(sender: UIButton) {
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
