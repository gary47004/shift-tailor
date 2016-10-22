//
//  editEventTableViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/6.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class editEventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var event = MSEvent()
    var eventseleted :eventStruct!
    //var isEditing: Bool = false
    
    var isExpandable = false
    
    
    @IBOutlet weak var editEventTableViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var deleteEventButton: UIButton!
    
    
    
    @IBOutlet weak var editEventButton: UIBarButtonItem!
    
    //var selectedEvent : eventStruct
    
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var editEventTableView: UITableView!
    
    var dateArray = Array<NSDate>()
    
    var jobArray = Array<Int>()
    
    let sectionArray = ["Select Date", "Select Employee"]
    
    let itemArray = [["Start Date", "End Date"],["Coding","Cleaning","Dancing"]]
    
    var selectedIndexPath: NSIndexPath? = nil
    
    @IBAction func deleteEvent(sender: UIButton) {
        let eventDBRef = FIRDatabase.database().reference()
        eventDBRef.child("managerEvent").child("010").child("2016-10-16").child(event.key).removeValue()
        //print(editEventButton.title)
        
        for (var i = 0; i < self.navigationController?.viewControllers.count; i = i + 1) {
            if(self.navigationController?.viewControllers[i].isKindOfClass(ManagerSetEventViewController) == true) {
                
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! ManagerSetEventViewController, animated: true)
            }
        }
        

    }
      
    @IBAction func editEvent(sender: UIBarButtonItem) {
        if self.editing{
            //listTableView.editing = false;
            self.setEditing(false, animated: false)
            self.editEventButton.style = UIBarButtonItemStyle.Plain
            self.editEventButton.title = "Edit"
            
            self.deleteEventButton.accessibilityElementsHidden = false
            
            editEventTableViewHeight.constant = 0
            deleteView.hidden = true
            
            
            saveData()
            print("a")
            isExpandable = false
            
            //listTableView.reloadData();
        }
        else{
            //listTableView.editing = true;
            
            self.setEditing(true, animated: false)
            self.editEventButton.title = "Done"
            self.editEventButton.style =  UIBarButtonItemStyle.Done
            editEventTableViewHeight.constant = -40
            deleteView.hidden = false
            
            
            
            print(editEventButton.title)
            isExpandable = true
            
            
            self.editEventTableView.reloadData()
            
            print("b")
            
            
            
            
        }

    }
   
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editEventTableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        
                
 
      
    }
    
      
    func saveData(){
        
        self.editEventTableView.reloadData()
        
        for i in 0...1 {
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let cell = self.editEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: indexPath) as! DatePickerCell
            
            if cell.dateData != nil{
                print(cell.dateData)
                dateArray.append(cell.dateData)
                print(dateArray)
            }else{
                print(NSDate.now())
                dateArray.append(NSDate.now())
            }
            
        }
        
        for j in 0...itemArray[1].count - 1{
            
            let indexPath = NSIndexPath(forRow: j, inSection: 1)
            
            let cell = self.editEventTableView.dequeueReusableCellWithIdentifier("empCell", forIndexPath: indexPath) as! employeeCell
            
            
            if cell.txtNumber.text != "" {
                print(Int(cell.txtNumber.text!))
                jobArray.append(Int(cell.txtNumber.text!)!)
            }else{
                jobArray.append(0)
                
            }
            
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd-H:mm"
        
        let startDate = dateFormatter.stringFromDate(dateArray[0])
        let endDate = dateFormatter.stringFromDate(dateArray[1])
        
        
        
        let editedEvent : [String:AnyObject] = [itemArray[0][0] : startDate,
                                          itemArray[0][1] : endDate,
                                          itemArray[1][0] : jobArray[0],
                                          itemArray[1][1] : jobArray[1],
                                          itemArray[1][2] : jobArray[2]
        ]
        
        
        event.StartDate = dateArray[0]
        event.EndDate = dateArray[1]
        event.coding = jobArray[0]
        event.cleaning = jobArray[1]
        event.dancing = jobArray[2]
        
        
        dateArray = []
        jobArray = []
        
     
        print(event)
        
        let eventDBRef = FIRDatabase.database().reference()
        
        
        eventDBRef.child("managerEvent").child("010").child("2016-10-16").child(event.key).updateChildValues(["Start Date":startDate, "End Date": endDate, "Coding":event.coding, "Dancing":event.dancing, "Cleaning": event.cleaning])
        
        
    
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if isExpandable == true{
            if indexPath.section == 0{
            
                if selectedIndexPath != nil{
                
                    if indexPath == selectedIndexPath {
                    
                        return 270
                    }else{
                    
                        return 70
                    }
                
                }else{
                    return 70
                }
            }else{
                return 70
            }
        }else{
            return 70
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let empCell = editEventTableView.dequeueReusableCellWithIdentifier("empCell") as! employeeCell
        
        let dateCell = editEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        
        dateCell.titleLabel.text = itemArray[indexPath.section][indexPath.row]
        

        
        
        dateCell.clipsToBounds = true
        
        empCell.empTitleLabel.text = itemArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
            
                dateCell.setLabel(event.StartDate)
                dateCell.setDatePickerValue(event.StartDate)
            
            }else if indexPath.row == 1 {
            
                dateCell.setLabel(event.EndDate)
                dateCell.setDatePickerValue(event.EndDate)
                
            }
            
            
            
            return dateCell
            
        }else{
            
            for _ in 0...itemArray[1].count-1 {
                if empCell.empTitleLabel.text == "Coding"{
                    empCell.txtNumber.text = String(event.coding)
                }else if empCell.empTitleLabel.text == "Dancing"{
                    empCell.txtNumber.text = String(event.dancing)
                }else if empCell.empTitleLabel.text == "Cleaning"{
                    empCell.txtNumber.text = String(event.cleaning)
                }
            }
            
            if isExpandable == true{
                empCell.txtNumber.userInteractionEnabled = true
            }else{
                empCell.txtNumber.userInteractionEnabled = false
            }
            
            
            return empCell }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        
        switch selectedIndexPath {
            
        case nil:
            
            selectedIndexPath = indexPath
        default:
            
            if selectedIndexPath == indexPath{
                selectedIndexPath = nil
            }else{
                selectedIndexPath = indexPath
            }
        }
        
        
/*
        if indexPath.section == 0 { //點選 section one 時收起數字鍵盤
            
            for i in 0...itemArray[1].count-1 {
                
                let sectionTwoIndexPath = NSIndexPath(forRow: i,inSection: 1)
                
                let sectionTowCell = self.editEventTableView.cellForRowAtIndexPath(sectionTwoIndexPath) as! employeeCell
                
                sectionTowCell.txtNumber.resignFirstResponder()
            
            }
        }
*/

        
        
//        }else if indexPath.section == 1 {
//            
//            let sectionTwoCell = self.editEventTableView.cellForRowAtIndexPath(indexPath) as! employeeCell
//            
//            if isExpandable == true{
//                
//                sectionTwoCell.txtNumber.userInteractionEnabled = true
//            }else {
//                sectionTwoCell.txtNumber.userInteractionEnabled = false
//            }
//        }
//                
//        
        editEventTableView.beginUpdates()
        
        editEventTableView.endUpdates()

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
