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
    let jobArray = ["beverage","cleaning","cashier"]
    
    var currentWeekStartDate: String!
    
    var currentUID = String()
    var currentSID = String()
    var currentRank = String()
    
    
    @IBOutlet weak var transferButton: UIBarButtonItem!

    @IBOutlet weak var managerShiftDetailTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        managerShiftDetailTableView.backgroundColor = UIColor(red: 43, green: 43, blue: 50)
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentRank = tabBarVC.currentRank
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("managerShift").child(self.currentSID).child(self.currentWeekStartDate).observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            //print("inside")
            
            let post = snapshot.value as! [String :AnyObject ]
            
            let startDateString = post["StartDate"] as! String
            
            let eventID = snapshot.key
            
            let endDateString = post["EndDate"] as! String
            
            let eventType = ""
            
            //print(snapshot.value)
            
            let beverageList = snapshot.childSnapshotForPath("beverage").value
            let cleaningList = snapshot.childSnapshotForPath("cleaning").value
            let cashierList = snapshot.childSnapshotForPath("cashier").value
            
            
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
            
            
            let startDate = dateformatter.dateFromString(startDateString)!
            
            let endDate = dateformatter.dateFromString(endDateString)!
            
            let shortFormatter = NSDateFormatter()
            
            shortFormatter.dateFormat = "H:mm"
            
            let shortStartDateString = shortFormatter.stringFromDate(startDate)
            
            let shortEndDateString = shortFormatter.stringFromDate(endDate)
            
            //self.eventList.append(eventStruct(startDate: startDate,endDate: endDate, beverage: beverage, cashier: cashier, cleaning: cleaning, key: eventID))
            
            
            
            let newEvent = MSEvent.makeManagerShiftEvent(startDate, end: endDate, title: "\(eventType)\n\(shortStartDateString)", location: "\(shortEndDateString)", key: eventID, beverageList: beverageList as! [[String:String]], cleaningList: cleaningList as! [[String:String]], cashierList: cashierList as![[String:String]], shiftType: eventType)
            
            self.selectedEvent = newEvent
            
            print("SNNNN",snapshot)
            
            self.managerShiftDetailTableView.reloadData()
            
            })
        
        self.sectionTitleArray = ["\(selectedEvent.beverageList.count) 位", "\(selectedEvent.cleaningList.count) 位", "\(selectedEvent.cashierList.count) 位"]
        
        let titleFormatter = NSDateFormatter()
        titleFormatter.dateFormat = "MMM dd eee"
        
        self.titleItem.title = titleFormatter.stringFromDate(selectedEvent.StartDate)

        // Do any additional setup after loading the view.
    }
    
    //UI
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIImageView()
        let label = UILabel(frame: CGRect(x: 76, y: 19, width: 40, height: 11))

        if section == 0{
            view.image = UIImage(named: "beverage header")
            label.text = sectionTitleArray[0]
        }else if section == 1{
            view.image = UIImage(named: "cashier header")
            label.text = sectionTitleArray[1]

        }else{
            view.image = UIImage(named: "cleaning header")
            label.text = sectionTitleArray[2]

        }
    
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)
        
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
        
        //UI
        employeeCell.backgroundColor = UIColor.clearColor()
        employeeCell.layer.borderWidth = 1
        employeeCell.layer.borderColor = UIColor(red: 95, green: 95, blue: 95).CGColor
        let redStatus = UIImage(named: "red status")
        let normalStatus = UIImage(named: "normal status")

        
        let empStartDate: NSDate
        let empEndDate: NSDate
        
        let late: String?
        let leaveEarly: String?
        
        let shortFormatter = NSDateFormatter()
        shortFormatter.dateFormat = "HH:mm"
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateFormat = "yyyy-M-dd-HH:mm"
        if indexPath.section == 0{
            employeeCell.employeeNameLabel.text = (selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["name"] as? String
            
            
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["startDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["endDate"] as? String)!)!
            
            late = (selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["late"] as? String
            leaveEarly = (selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["leaveEarly"] as? String
            
            if late != "0" && late != nil {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)
            }else {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                 employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)
            }
            
            if leaveEarly != "0" && leaveEarly != nil {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)

            }else {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)

            }
            
            
            
            
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
            
            
        }else if indexPath.section == 1 {
            employeeCell.employeeNameLabel.text = (selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["name"] as? String
            
            late = (selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["late"] as? String
            leaveEarly = (selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["leaveEarly"] as? String
            
            if late != "0" && late != nil {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)
            }else {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)
            }
            
            if leaveEarly != "0" && leaveEarly != nil {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)
                
            }else {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)
                
            }
            
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["startDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.cleaningList[indexPath.row] as? NSDictionary)!["endDate"] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
            
        }else if indexPath.section == 2 {
            employeeCell.employeeNameLabel.text = (selectedEvent.cashierList[indexPath.row] as? NSDictionary)!["name"] as? String
            
            late = (selectedEvent.cashierList[indexPath.row] as? NSDictionary)!["late"] as? String
            leaveEarly = (selectedEvent.cashierList[indexPath.row] as? NSDictionary)!["leaveEarly"] as? String
            
            if late != "0" && late != nil {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)
            }else {
                employeeCell.startTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.startTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)
            }
            
            if leaveEarly != "0" && leaveEarly != nil {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: redStatus!)
                
            }else {
                employeeCell.endTimeLabel.textColor = UIColor.whiteColor()
                employeeCell.endTimeLabel.backgroundColor = UIColor(patternImage: normalStatus!)
                
            }
            
            empStartDate = dateformatter.dateFromString(((selectedEvent.cashierList[indexPath.row] as? NSDictionary)!["startDate"] as? String)!)!
            empEndDate = dateformatter.dateFromString(((selectedEvent.cashierList[indexPath.row] as? NSDictionary)!["endDate"] as? String)!)!
            employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(empStartDate)
            employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(empEndDate)
        }
        
        
        
        //employeeCell.startTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.StartDate)
        //employeeCell.endTimeLabel.text = shortFormatter.stringFromDate(selectedEvent.EndDate)
        
        
        
        
        return employeeCell
        
    }
    @IBAction func changeEmp(sender: AnyObject) {
        let eventDBRef = FIRDatabase.database().reference()
        
        let empVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: "請選取欲更換員工", preferredStyle: .ActionSheet)
        
        let pickerView = UIPickerView.init(frame: CGRect(x: -20, y: 0, width: 400, height: 200))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        let okAction = UIAlertAction(title: "確認", style: .Default, handler : {(alert : UIAlertAction!) in
            
            
            
            if self.changeEmp == nil{
                
                self.changeEmp = self.changeEmployeeList[0]
            }
            
            print("ChangeEmp",self.changeEmp)
            
            
            eventDBRef.child("managerShift").child(self.currentSID).child(self.currentWeekStartDate).child(self.selectedEvent.key).child(self.jobArray[self.selectedIndexPath.section]).child("\(self.selectedIndexPath.row)").updateChildValues(["name":self.changeEmp])
            
            
            self.changeEmp = nil
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        empVC.view.addSubview(pickerView)
        empVC.addAction(okAction)
        empVC.addAction(cancelAction)
        print("還沒跳Alert")
        self.presentViewController(empVC, animated: true, completion:nil)

        
        

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        changeEmpButton.enabled = true
        
        //print((selectedEvent.beverageList[indexPath.row] as? NSDictionary)!["Name"] as? String)
        
        selectedIndexPath = indexPath
        
        changeEmployeeList = []
        
        let employeeCell = tableView.cellForRowAtIndexPath(indexPath) as! ShiftEmployeeTableViewCell
        
        let eventDBRef = FIRDatabase.database().reference()
        eventDBRef.child("employee").observeEventType(.ChildAdded, withBlock: {snapshot in
            
            if snapshot.childSnapshotForPath("profession").value as! String == self.jobArray[self.selectedIndexPath.section] && snapshot.childSnapshotForPath("store").value as! String == self.currentSID && snapshot.childSnapshotForPath("name").value as! String != employeeCell.employeeNameLabel.text{
                
                let employeeSnapshot = snapshot.value as! [String:AnyObject]
                
                self.changeEmployeeList.append(employeeSnapshot["name"] as! String)
                
                print("CEL",self.changeEmployeeList)
                
                
            }
        })
        
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
            return selectedEvent.beverageList.count
        }else if section == 1{
            return selectedEvent.cleaningList.count
        }else if section == 2{
            return selectedEvent.cashierList.count
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
