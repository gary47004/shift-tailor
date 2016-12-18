//
//  BulletinDetail.swift
//  shifter
//
//  Created by Frank Wang on 20/11/2016.
//  Copyright © 2016 Chlorophyll. All rights reserved.
//

import UIKit

class BulletinDetail: UIViewController {
    
    var selectedSection = Int()
    var selectedRow = Int()
    var section0Posts = [post]()
    var section1Posts = [post]()
    var section0Refs = [AnyObject]()
    var section1Refs = [AnyObject]()
    var editMode = Bool()
    var currentUID = String()
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setButton(){
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(BulletinDetail.editPressed))
        editButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = editButton
        self.navigationItem.rightBarButtonItem?.title = "編輯"
        
        let backButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(BulletinDetail.backPressed))
        backButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backPressed(){
        tabBarController?.selectedIndex = 1 //let path trough notification ends at bulletin
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func editPressed(){
        performSegueWithIdentifier("editPressed", sender: self)
        self.title = "取消"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let composeVC = segue.destinationViewController as! BulletinCompose
        if segue.identifier == "editPressed"{
            editMode = true
            composeVC.editMode = editMode
        }
    }


    
    func setValue(){
        //get value from tab bar VC
        let tabBarVC = self.tabBarController as! TabBarViewController
        currentUID = tabBarVC.currentUID
        section0Posts = tabBarVC.section0Posts
        section1Posts = tabBarVC.section1Posts
        section0Refs = tabBarVC.section0Refs
        section1Refs = tabBarVC.section1Refs
        selectedSection = tabBarVC.selectedSection
        selectedRow = tabBarVC.selectedRow
        
        if selectedSection == 0{
            titleLabel.text = section0Posts[selectedRow].title
            timeLable.text = section0Posts[selectedRow].time
            authorLabel.text = section0Posts[selectedRow].employee
            contentLabel.text = section0Posts[selectedRow].content
        }else{
            titleLabel.text = section1Posts[selectedRow].title
            timeLable.text = section1Posts[selectedRow].time
            authorLabel.text = section1Posts[selectedRow].employee
            contentLabel.text = section1Posts[selectedRow].content
        }

    }
    
    func checkEditQualification(){
        if selectedSection == 0{
            if currentUID != section0Posts[selectedRow].employee{
                navigationItem.rightBarButtonItem = nil
            }
        }else{
            if currentUID != section1Posts[selectedRow].employee{
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    override func viewDidLoad() {
        setButton()
        setValue()
        checkEditQualification()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "公告內容")!)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = ""
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    
}
