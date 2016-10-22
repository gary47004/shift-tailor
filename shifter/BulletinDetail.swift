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
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.hidden = true
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(BulletinDetail.editPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func editPressed(){
        performSegueWithIdentifier("editPressed", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPressed"{
            editMode = true
            let composeVC = segue.destinationViewController as! BulletinCompose
            composeVC.editMode = editMode
            composeVC.section0Posts = section0Posts
            composeVC.section1Posts = section1Posts
            composeVC.selectedSection = selectedSection
            composeVC.selectedRow = selectedRow
            composeVC.section0Refs = section0Refs
            composeVC.section1Refs = section1Refs
            
        }
    }
    
    //set tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
//        if editMode == false{
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

