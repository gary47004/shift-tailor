//
//  addEventTableViewController.swift
//  RVCalendarView
//
//  Created by mac on 2016/9/28.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class addEventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var addEventTableView: UITableView!
    
    var longPressDate: NSDate!

    var dateArray = Array<NSDate>()
    
    var jobArray = Array<Int>()
   
    let sectionArray = ["Select Date", "Select Employee"]
    
    let itemArray = [["Start Date", "End Date"],["beverage","cleaning","cashier"]]
    let titleArray = [["開始時間", "結束時間"],["吧台手","清潔工","收銀員"]]
    
    var selectedIndexPath: NSIndexPath? = nil
    
    var shiftStartDate: String!
    
    var currentUID = String()
    var currentSID = String()
    var currentRank = String()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tabBarVC = self.tabBarController as! TabBarViewController
        
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentRank = tabBarVC.currentRank

        
        addEventTableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
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
    
   
    //UI
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIImageView()
        if section == 0{
            view.image = UIImage(named: "time header")
        }else{
            view.image = UIImage(named: "demand header")
        }
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }
    
    
    @IBAction func addEvent(sender: UIBarButtonItem) {
        getData()
    }
    
    func getData(){
        
        self.addEventTableView.reloadData()
        
        for i in 0...1 {
            
             let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
             let cell = self.addEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: indexPath) as! DatePickerCell
            
            if cell.dateData != nil{
                print(cell.dateData)
                dateArray.append(cell.dateData)
            }else{
                print(NSDate.now())
                dateArray.append(NSDate.now())
            }
            
        }
        
        for j in 0...itemArray[1].count - 1{
            
            let indexPath = NSIndexPath(forRow: j, inSection: 1)
            
            let cell = self.addEventTableView.dequeueReusableCellWithIdentifier("empCell", forIndexPath: indexPath) as! employeeCell
            
            
            if cell.txtNumber.text != "" {
                print(Int(cell.txtNumber.text!))
                jobArray.append(Int(cell.txtNumber.text!)!)
            }else{
                jobArray.append(0)
                
            }
            
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd-HH:mm"
        
        let startDate = dateFormatter.stringFromDate(dateArray[0])
        let endDate = dateFormatter.stringFromDate(dateArray[1])
        
                
        
       
        
        let event : [String:AnyObject] = ["StartDate" : startDate,
                                          "EndDate" : endDate,
                                          itemArray[1][0] : jobArray[0],
                                          itemArray[1][1] : jobArray[1],
                                          itemArray[1][2] : jobArray[2]
                                                                         ]
        
        let eventDBRef = FIRDatabase.database().reference()
        
        eventDBRef.child("managerEvent").child(self.currentSID).child(shiftStartDate).childByAutoId().setValue(event)
        
        
        
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
        for (var i = 0; i < self.navigationController?.viewControllers.count; i = i + 1) {
            if(self.navigationController?.viewControllers[i].isKindOfClass(ManagerSetEventViewController) == true) {
                
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! ManagerSetEventViewController, animated: true)
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
        return self.itemArray[section].count
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
        
        let empCell = addEventTableView.dequeueReusableCellWithIdentifier("empCell") as! employeeCell
        
        let dateCell = addEventTableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        
        dateCell.titleLabel.text = titleArray[indexPath.section][indexPath.row]
//        dateCell.titleLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label background L")!)
        
        if longPressDate != nil {
            
            dateCell.setLabel(longPressDate)
            dateCell.setDatePickerValue(longPressDate)
            
        }else{
            
            dateCell.setLabel(NSDate.now())
            
        }
        
        
        dateCell.clipsToBounds = true
        
        empCell.empTitleLabel.text = titleArray[indexPath.section][indexPath.row]
        let textField = empCell.subviews[0].subviews[0] as! UITextField
        textField.underlined()
        
        if indexPath.section == 0{

            return dateCell
    
        }else{
          
            return empCell}
        
    
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
        
        print(indexPath.row)
        
/*        if indexPath.section == 0 { //點選 section one 時收起數字鍵盤
            
            for i in 0...itemArray[1].count-1 {
                
                let sectionTwoIndexPath = NSIndexPath(forRow: i,inSection: 1)
                
                print(sectionTwoIndexPath)
                
                let sectionTowCell = self.addEventTableView.cellForRowAtIndexPath(sectionTwoIndexPath) as? employeeCell
                
                print(sectionTowCell)
                
                sectionTowCell!.txtNumber.resignFirstResponder()
                
            }
            
        }
*/
        
//        if indexPath.section == 1 {
//            
//            let secetionTwoCell = self.addEventTableView.cellForRowAtIndexPath(indexPath) as! employeeCell
//            
//            textFieldDidBeginEditing(secetionTwoCell.txtNumber)
//        }
       
        addEventTableView.beginUpdates()

        addEventTableView.endUpdates()
    }
    
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        selectedIndexPath = nil
//        addEventTableView.beginUpdates()
//        addEventTableView.endUpdates()
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
