//
//  EmployeeAddEventViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EmployeeAddEventViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var employeeAddEventTableView: UITableView!
    
    var longPressDate: NSDate!
    
    var dateArray = Array<NSDate>()
    
    var jobArray = Array<Int>()
    
    let sectionArray = ["Select Date"]
    
    let itemArray = ["Start Date", "End Date"]
    
    var selectedIndexPath: NSIndexPath? = nil
    
    var shiftStartDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employeeAddEventTableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        print("LongPressDate: ",longPressDate)
        
        /*
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
         view.addGestureRecognizer(tap)
         */
        
    }
    
    /*
     func dismissKeyboard() {
     //Causes the view (or one of its embedded text fields) to resign the first responder status.
     view.endEditing(true)
     }
     */
    
 
    @IBAction func addEvent(sender: UIBarButtonItem) {
        getData()
    }
    
    func getData(){
        
        self.employeeAddEventTableView.reloadData()
        
        for i in 0...1 {
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let cell = self.employeeAddEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: indexPath) as! DatePickerCell
            
            if cell.dateData != nil{
                print(cell.dateData)
                dateArray.append(cell.dateData)
            }else{
                print(NSDate.now())
                dateArray.append(NSDate.now())
            }
            
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd-H:mm"
        
        let startDate = dateFormatter.stringFromDate(dateArray[0])
        let endDate = dateFormatter.stringFromDate(dateArray[1])
        
        
        
        
        let event : [String:AnyObject] = [itemArray[0]: startDate,
                                          itemArray[1] : endDate,
                            
        ]
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("employeeEvent").child(shiftStartDate).child("102306111").childByAutoId().setValue(event)
        
        for (var i = 0; i < self.navigationController?.viewControllers.count; i += 1) {
            if(self.navigationController?.viewControllers[i].isKindOfClass(EmployeeEventWeekViewController) == true) {
                
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! EmployeeEventWeekViewController, animated: true)
            }
        }

        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
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
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let dateCell = employeeAddEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        
        dateCell.titleLabel.text = itemArray[indexPath.row]
        
        if longPressDate != nil {
            
            dateCell.setLabel(longPressDate)
            dateCell.setDatePickerValue(longPressDate)
            
        }else{
            
            dateCell.setLabel(NSDate.now())
            
        }
        
        dateCell.clipsToBounds = true
            
            return dateCell
            
   
        
        
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
 
        
        employeeAddEventTableView.beginUpdates()
        
        employeeAddEventTableView.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
