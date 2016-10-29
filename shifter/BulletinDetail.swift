//
//  BulletinDetail.swift
//  shifter
//
//  Created by Frank Wang on 2016/8/21.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit


class BulletinDetail: UITableViewController {
    let subjectArray = ["標題：","時間：","內容"]
    var selectedSection = Int()
    var selectedRow = Int()
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var editMode = Bool()
    var currentUID = String()
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.hidden = true
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(BulletinDetail.editPressed))
        navigationItem.rightBarButtonItem = editButton
        
        //get value from tab bar VC
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        section0Posts = tabBarVC.section0Posts
        section1Posts = tabBarVC.section1Posts
        section0Refs = tabBarVC.section0Refs
        section1Refs = tabBarVC.section1Refs
        selectedSection = tabBarVC.selectedSection
        selectedRow = tabBarVC.selectedRow
        
        //check edit qualification
        if selectedSection == 0{
            if currentUID == section0Posts[selectedRow].employee{
                navigationItem.rightBarButtonItem = editButton
            }else{
                navigationItem.rightBarButtonItem = nil
            }
        }else{
            if currentUID == section1Posts[selectedRow].employee{
                navigationItem.rightBarButtonItem = editButton
            }else{
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = ""
    }
    
    func editPressed(){
        performSegueWithIdentifier("editPressed", sender: self)
        self.title = "Cancel"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let composeVC = segue.destinationViewController as! BulletinCompose
        if segue.identifier == "editPressed"{
            editMode = true
            composeVC.editMode = editMode
        }else{
            editMode = false
            composeVC.editMode = editMode
        }
    }
    
    //set tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("bulletinDetailCell")! as UITableViewCell
        let subjectLabel = UILabel(frame: CGRectMake(20,10,51,21))
        
        //set subject and content labels
        cell.addSubview(subjectLabel)
        subjectLabel.text = subjectArray[indexPath.row]
        let valueLabel = UILabel(frame: CGRectMake(60,10,400,21))
        cell.addSubview(valueLabel)
        
        
        if indexPath.row == 0 {
            if selectedSection == 0{
                valueLabel.text = section0Posts[selectedRow].title
            }else{
                valueLabel.text = section1Posts[selectedRow].title
            }
        }else if indexPath.row == 1 {
            if selectedSection == 0{
                valueLabel.text = section0Posts[selectedRow].time
            }else{
                valueLabel.text = section1Posts[selectedRow].time
            }
        }else{
            if selectedSection == 0{
                valueLabel.text = section0Posts[selectedRow].content
            }else{
                valueLabel.text = section1Posts[selectedRow].content
            }
        }
        
        return cell

    }
    
}

