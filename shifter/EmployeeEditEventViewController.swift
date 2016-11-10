//
//  EmployeeEditEventViewController.swift
//  shifter
//
//  Created by mac on 2016/11/2.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class EmployeeEditEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var isExpandable:Bool = false
    var shiftStartDate : String!
    var selectedEvent = MSEvent()

    @IBOutlet weak var employeeEditEventTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteEventButton: UIButton!
    @IBOutlet weak var employeeDeleteEventView: UIView!
    @IBOutlet weak var editEventButton: UIBarButtonItem!
    @IBOutlet weak var employeeEditEventTableView: UITableView!
    
    let sectionArray = ["Select Date","喜好度"]
    
    let itemArray = ["Start Date", "End Date"]
    
    var dateArray = Array<NSDate>()
    
    var selectedIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        employeeEditEventTableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        employeeEditEventTableView.registerNib(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "SliderCell")


        // Do any additional setup after loading the view.
    }
    
    @IBAction func editEvent(sender: UIBarButtonItem) {
        if self.editing{
            //listTableView.editing = false;
            self.setEditing(false, animated: false)
            self.editEventButton.style = UIBarButtonItemStyle.Plain
            self.editEventButton.title = "Edit"
            
            self.deleteEventButton.accessibilityElementsHidden = false
            
            employeeEditEventTableViewHeight.constant = 0
            employeeDeleteEventView.hidden = true
            

            
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
            employeeEditEventTableViewHeight.constant = -40
            employeeDeleteEventView.hidden = false
            
                        

            
            
            
            print(editEventButton.title)
            isExpandable = true
            
            
            self.employeeEditEventTableView.reloadData()
            
            print("b")
            
            
            
            
        }

    }
    @IBAction func deleteEvent(sender: UIButton) {
        let eventDBRef = FIRDatabase.database().reference()
        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").child(selectedEvent.key).removeValue()
        //print(editEventButton.title)
        
        for (var i = 0; i < self.navigationController?.viewControllers.count; i = i + 1) {
            if(self.navigationController?.viewControllers[i].isKindOfClass(EmployeeEventWeekViewController) == true) {
                
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! EmployeeEventWeekViewController, animated: true)
            }
        }
        

    }
    
    func saveData(){
        self.employeeEditEventTableView.reloadData()
        
        for i in 0...1 {
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            let cell = self.employeeEditEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: indexPath) as! DatePickerCell
            
            if cell.dateData != nil{
                print(cell.dateData)
                dateArray.append(cell.dateData)
                print(dateArray)
            }else{
                print(NSDate.now())
                dateArray.append(NSDate.now())
            }
            
        }
        
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd-HH:mm"
        
        let startDate = dateFormatter.stringFromDate(dateArray[0])
        let endDate = dateFormatter.stringFromDate(dateArray[1])
        
        
        let sliderCell = self.employeeEditEventTableView.dequeueReusableCellWithIdentifier("SliderCell") as! SliderCell
        
        let preference = lroundf(sliderCell.preferenceSlider.value)
        
        
        
        selectedEvent.StartDate = dateArray[0]
        selectedEvent.EndDate = dateArray[1]
        selectedEvent.coding = preference
        
        dateArray = []
        
        
        
        let eventDBRef = FIRDatabase.database().reference()
        
        
        eventDBRef.child("employeeEvent").child("010").child(shiftStartDate).child("102306111").child(selectedEvent.key).updateChildValues(["Start Date":startDate, "End Date": endDate,"Preference": preference])
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.itemArray.count
        }else{
            return 1
        }
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
            }else {
                return 150
            }

            
        }else{
            if indexPath.section == 0{
             return 70
            }else{
                return 150
            }
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sliderCell = employeeEditEventTableView.dequeueReusableCellWithIdentifier("SliderCell") as! SliderCell
        let dateCell = employeeEditEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        
        dateCell.titleLabel.text = itemArray[indexPath.row]
        
        
        dateCell.clipsToBounds = true
        
        
        
        if indexPath.section == 0{
            
            if indexPath.row == 0 {
                
                dateCell.setLabel(selectedEvent.StartDate)
                dateCell.setDatePickerValue(selectedEvent.StartDate)
                
            }else if indexPath.row == 1 {
                
                dateCell.setLabel(selectedEvent.EndDate)
                dateCell.setDatePickerValue(selectedEvent.EndDate)
                
            }
            
            
            
            return dateCell

            
            
        }else{
            sliderCell.preferenceLabel.text = String(selectedEvent.coding)
            sliderCell.preferenceSlider.value = selectedEvent.coding as Float
            
            if isExpandable == true{
                sliderCell.preferenceSlider.enabled = true
            }else{
                sliderCell.preferenceSlider.enabled = false
            }
            
            
            return sliderCell
        
        }

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
        
        
        employeeEditEventTableView.beginUpdates()
        
        employeeEditEventTableView.endUpdates()

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
