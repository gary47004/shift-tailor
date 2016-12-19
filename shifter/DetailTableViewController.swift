//
//  DetailTableViewController.swift
//  shifter
//
//  Created by gary on 2016/11/23.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var rowSelected:Int?
    var infor = [informationStruct]()
    //接資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 43, green: 43, blue: 50)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 7
        }else if(section == 1){
            return 3
        }else{
            return 3
        }
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIImageView()
//        if section == 1{
//            view.image = UIImage(named: "section header")
//        }else{
//            view.image = UIImage(named: "section header2")
//        }
//        
//        return view
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 53, green: 53, blue: 60)
        let label = UILabel(frame: CGRect(x: 16, y: 15, width: 200, height: 17))
        if section == 0{
            label.text = "員工資訊"
        }else if section == 1{
            label.text = "2016-12-12 ~ 2016-12-18"
        }else{
            label.text = "2016-12-5 ~ 2016-12-11"
        }
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)

        
        return view
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        if(indexPath.section == 0){
            if(indexPath.row==0){cell.textLabel?.text = "員工ID："+"\(infor[rowSelected!].id)"}
            else if(indexPath.row==1){cell.textLabel?.text = "區域："+"\(infor[rowSelected!].district)"}
            else if(indexPath.row==2){cell.textLabel?.text = "姓名："+"\(infor[rowSelected!].name)"}
            else if(indexPath.row==3){cell.textLabel?.text = "電話："+"\(infor[rowSelected!].phone)"}
            else if(indexPath.row==4){cell.textLabel?.text = "階級："+"\(infor[rowSelected!].rank)"}
            else if(indexPath.row==5){cell.textLabel?.text = "門市："+"\(infor[rowSelected!].store)"}
            else if(indexPath.row==6){cell.textLabel?.text = "職位："+"\(infor[rowSelected!].profession)"}
        
        }else if(indexPath.section == 1){
            if(indexPath.row==0){cell.textLabel?.text = "遲到次數："+"\(String(infor[rowSelected!].late))"}
            else if(indexPath.row==1){cell.textLabel?.text = "早退次數："+"\(String(infor[rowSelected!].leaveEarly))"}
            else if(indexPath.row==2){cell.textLabel?.text = "薪資："+"\(String(infor[rowSelected!].payment!))"}
            
        }else{
            if(indexPath.row==0){cell.textLabel?.text = "遲到次數："+"2"}
            else if(indexPath.row==1){cell.textLabel?.text = "早退次數："+"0"}
            else if(indexPath.row==2){
                if(infor[rowSelected!].payment! < 10000){
                    cell.textLabel?.text = "薪資："+"2880"
                }else{
                    cell.textLabel?.text = "薪資："+"45000"
                }
            }
            
        }
        
    
        return cell

    }
    
    override func tableView(tableView:UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return "員工資訊"
        }else if(section == 1){
            return "2016-12-12 ~ 2016-12-18"
        }else{
            return "2016-12-5 ~ 2016-12-11"
        }
    }    
}