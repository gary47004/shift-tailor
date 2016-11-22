//
//  BulletinCompose.swift
//  shifter
//
//  Created by Frank Wang on 20/11/2016.
//  Copyright © 2016 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BulletinCompose: UIViewController, UITextFieldDelegate {
    var inputTitle = String()
    var inputTime = String()
    var inputContent = String()
    var indexPathArray = [NSIndexPath]()
    var sectionPressed = Int()
    var editMode = Bool()
    var selectedSection = Int()
    var selectedRow = Int()
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var didSelectDateCell = Bool()
    var firstLoad = Bool()
    var currentUID = String()
    var currentSID = String()
    var currentDID = String()
    
    //UI frame
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    let storeButton = UIButton(frame: CGRect(x: 18, y: 84, width: 161, height: 38))
    let districtButton = UIButton(frame: CGRect(x: 197, y: 84, width: 161, height: 38))
    let deleteButton = UIButton(frame: CGRect(x: 0, y: 618, width: 375, height: 49))



    func setButtons(){
        if sectionPressed == 0{
            storeButton.setImage(UIImage(named: "store button - selected"), forState: .Normal)
            districtButton.setImage(UIImage(named: "district button"), forState: .Normal)

        }else{
            storeButton.setImage(UIImage(named: "store button"), forState: .Normal)
            districtButton.setImage(UIImage(named: "district button - selected"), forState: .Normal)
        }
        
        storeButton.addTarget(self, action: #selector(BulletinCompose.storeButtonPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(storeButton)
        
        districtButton.addTarget(self, action: #selector(BulletinCompose.districtButtonPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(districtButton)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(BulletinCompose.donePressed))
                doneButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(BulletinCompose.cancelPressed))
        cancelButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = cancelButton
        
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.setTitleColor(.whiteColor(), forState: .Normal)
        deleteButton.backgroundColor = .grayColor()
        deleteButton.addTarget(self, action: #selector(BulletinCompose.deletePressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(deleteButton)
        
        if editMode == false{
            deleteButton.hidden = true
        }else{
            deleteButton.hidden = false
        }
       
    }
    
    func getCurrentTime(){
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, HH:MM"
        inputTime = formatter.stringFromDate(date)
        
    }
    
    func donePressed(){
        //save inputs
        inputTitle = titleTextField.text!
        inputContent = contentTextField.text!
        getCurrentTime()
        
        if editMode == false{
            //save input to post
            let post : [String : AnyObject] = ["title" : inputTitle, "time" : inputTime, "content" : inputContent, "section" : sectionPressed, "employee" : currentUID, "store" : currentSID, "district" : currentDID]
            
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("bulletin").childByAutoId().setValue(post)//add child "Posts" and upload post with auto ID
        }else{
            //update database
            if selectedSection == 0{
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("bulletin").child(section0Refs[selectedRow] as! String).updateChildValues(["title" : inputTitle, "time" : inputTime, "content" : inputContent, "section" : sectionPressed, "employee" : currentUID, "store" : currentSID, "district" : currentDID])
            }else{
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("bulletin").child(section1Refs[selectedRow] as! String).updateChildValues(["title" : inputTitle, "time" : inputTime, "content" : inputContent, "section" : sectionPressed, "employee" : currentUID, "store" : currentSID, "district" : currentDID])
            }
        }
        
        //go back to bulletin without losing tab bar and navigation controller
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func cancelPressed(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func deletePressed(){
        let databaseRef = FIRDatabase.database().reference()
        
        if selectedSection == 0{
            databaseRef.child("bulletin").child(section0Refs[selectedRow] as! String).removeValue() //remove from database
        }else{
            
            databaseRef.child("bulletin").child(section1Refs[selectedRow] as! String).removeValue()
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setTextField(){
        titleTextField.text = inputTitle
        contentTextField.text = inputContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isFirstResponder() == true{
            textField.placeholder = nil
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""{
            if textField == titleTextField{
                textField.placeholder = "Title"
            }else{
                textField.placeholder = "Content"
            }
        }
    }
    
    
    
    func setInitValue(){
        //get value from tab bar VC
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        currentSID = tabBarVC.currentSID
        currentDID = tabBarVC.currentDID
        
        if editMode == true{
            section0Posts = tabBarVC.section0Posts
            section1Posts = tabBarVC.section1Posts
            section0Refs = tabBarVC.section0Refs
            section1Refs = tabBarVC.section1Refs
            selectedSection = tabBarVC.selectedSection
            selectedRow = tabBarVC.selectedRow
            
            if selectedSection == 0{
                inputTitle = section0Posts[selectedRow].title
                inputTime = section0Posts[selectedRow].time
                inputContent = section0Posts[selectedRow].content
            }else{
                inputTitle = section1Posts[selectedRow].title
                inputTime = section1Posts[selectedRow].time
                inputContent = section1Posts[selectedRow].content
            }
        }
    }
    
    override func viewDidLoad() {
        setButtons()
        setInitValue()
        setTextField()
        
        firstLoad = true
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "新增公告")!)
        self.title = "新增公告"

        
    }
    
    override func viewWillAppear(animated: Bool) {
        if editMode == false{
            sectionPressed = 0
        }else{
            sectionPressed = selectedSection
        }
    }
    
    func storeButtonPressed(){
        sectionPressed = 0
        setButtons()
    }
    
    func districtButtonPressed(){
        sectionPressed = 1
        setButtons()
    }
}
