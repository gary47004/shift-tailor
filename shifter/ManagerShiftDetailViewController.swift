//
//  ManagerShiftDetailViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ManagerShiftDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    var selectedEvent = MSEvent()
    
    var selectedIndexPath : NSIndexPath!
    
    var changeEmployeeList = Array<String>()
    
    var changeEmp : String!

    var sectionTitleArray = [String]()
    
    @IBOutlet weak var changeEmpButton: UIBarButtonItem!
    let jobArray = ["Coding","Cleaning","Dancing"]
    
    var currentWeekStartDate: String!
    
    
    @IBOutlet weak var transferButton: UIBarButtonItem!
    
    
    @IBOutlet weak var managerShiftDetailTableView: UITableView!
    
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("managerShift").child("010").child(self.currentWeekStartDate).observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            //print("inside")
            
            let post = snapshot.value as! [String :AnyObject ]
            
            let startDateString = post["Start Date"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = post["End Date"] as! String
            
            let eventType = post["Type"] as! String
            
            //print(snapshot.value)
            
            let codingList = snapshot.childSnapshotForPath("Coding").value
            let cleaningList = snapshot.childSnapshotForPath("Cleaning").value
            let dancingList = snapshot.childSnapshotForPath("Dancing").value
            
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, coding: coding, dancing: dancing, cleaning: cleaning, key: eventID))
            
            let newEvent = MSEvent.make(startDate, end: endDate, title: "\(eventType)\n\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, codingList: codingList as! [[String:String]], cleaningList: cleaningList as! [[String:String]], dancingList:dancingList as![[String:String]] ,shiftType: eventType)
            
            self.selectedEvent = newEvent
            
            print("SNNNN",snapshot)
            
            self.managerShiftDetailTableView.reloadData()
            
            })
        
        self.sectionTitleArray = ["Coding: \(selectedEvent.codingList.count) 位", "Cleaning: \(selectedEvent.cleaningList.count) 位", "Dancing: \(selectedEvent.dancingList.count) 位"]
        
        let titleFormatter = NSDateFormatter()
        titleFormatter.dateFormat = "MMM dd eee"
        
        self.titleItem.title = titleFormatter.stringFromDate(selectedEvent.StartDate)

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitleArray[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    @IBAction func transferEmployee(sender: UIBarButtonItem) {
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let employeeCell = self.managerShiftDetailTableView.dequeueReusableCellWithIdentifier("EmployeeCell") as! ShiftEmployeeTableViewCell
        
        let empStartDate: NSDate
        let empEndDate: NSDate
        
        let shortFormatter = NSDateFormatter()
        shortFormatter.dateFormat = "H:mm"
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
        if indexPath.section == 0{
            employeeCell.employeeNameLabel.text = (selectedEvent.codingList[indexPath.row] as? NSDictionary)!["Name"] as? String
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.codingList[indexPath.row] as? NSDictionary)!["StartDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.codingList[indexPath.row] as? NSDictionary)!["EndDate"] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
            
            
        }else if indexPath.section == 1 {
            employeeCell.employeeNameLabel.text = (selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["Name"] as? String
            
            
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["StartDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["EndDate"] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
            
        }else if indexPath.section == 2 {
            employeeCell.employeeNameLabel.text = (selectedEvent.dancingList[indexPath.row] as? NSDictionary)!["Name"] as? String
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.dancingList[indexPath.row] as? NSDictionary)!["StartDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.dancingList[indexPath.row] as? NSDictionary)!["EndDate"] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
        }
        
        
        
        //employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.StartDate)
        //employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.EndDate)
        
        
        
        
        return employeeCell
        
    }
    @IBAction func changeEmp(sender: AnyObject) {
        let eventDBRef = FIRDatabase.database().reference()
        
        changeEmployeeList = []
        
        
        eventDBRef.child("employee").observeEventType(.ChildAdded, withBlock: {snapshot in
            
            if snapshot.childSnapshotForPath("profession").value as! String == self.jobArray[self.selectedIndexPath.section]{
                
                let employeeSnapshot = snapshot.value as! [String:AnyObject]
                
                self.changeEmployeeList.append(employeeSnapshot["name"] as! String)
                
                print("CEL",self.changeEmployeeList)
                
                let empVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: "請選取欲更換員工", preferredStyle: .ActionSheet)
                
                let pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
                
                pickerView.delegate = self
                pickerView.dataSource = self
                
                pickerView.showsSelectionIndicator = true
                
                
                
                
                
                let okAction = UIAlertAction(title: "確認", style: .Default, handler : {(alert : UIAlertAction!) in
                    
                    
                    
                    if self.changeEmp == nil{
                        
                        self.changeEmp = self.changeEmployeeList[0]
                    }
                    
                    print("ChangeEmp",self.changeEmp)
                    
                    
                    eventDBRef.child("managerShift").child("010").child(self.currentWeekStartDate).child(self.selectedEvent.key).child(self.jobArray[self.selectedIndexPath.section]).child("\(self.selectedIndexPath.row)").updateChildValues(["Name":self.changeEmp])
                    
                    
                    self.changeEmp = nil
                    
                })
                
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                
                empVC.view.addSubview(pickerView)
                
                empVC.addAction(okAction)
                
                empVC.addAction(cancelAction)
                
                self.presentViewController(empVC, animated: true, completion:nil)
                
                
                
                
                
            }
            
            
            
            
        })
        
        

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        changeEmpButton.enabled = true
        
        print((selectedEvent.codingList[indexPath.row] as? NSDictionary)!["Name"] as? String)
        
        selectedIndexPath = indexPath
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return changeEmployeeList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return changeEmployeeList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
            changeEmp = changeEmployeeList[row]
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return selectedEvent.codingList.count
        }else if section == 1{
            return selectedEvent.cleaningList.count
        }else if section == 2{
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
