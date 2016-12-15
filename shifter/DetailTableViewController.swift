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
        
        print(infor)
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "id:"+"\(infor[rowSelected!].id)"}
            else if(indexPath.row==1){cell.textLabel?.text = "district:"+"\(infor[rowSelected!].district)"}
            else if(indexPath.row==2){cell.textLabel?.text = "name:"+"\(infor[rowSelected!].name)"}
            else if(indexPath.row==3){cell.textLabel?.text = "phone:"+"\(infor[rowSelected!].phone)"}
            else if(indexPath.row==4){cell.textLabel?.text = "rank:"+"\(infor[rowSelected!].rank)"}
            else if(indexPath.row==5){cell.textLabel?.text = "store:"+"\(infor[rowSelected!].store)"}
            else if(indexPath.row==8){cell.textLabel?.text = "profession:"+"\(infor[rowSelected!].profession)"}
        
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "late:"+"\(String(infor[rowSelected!].late))"}
            else if(indexPath.row==1){cell.textLabel?.text = "leaveEarly:"+"\(String(infor[rowSelected!].leaveEarly))"}
            else if(indexPath.row==2){cell.textLabel?.text = "payment:"+"\(String(infor[rowSelected!].payment!))"}
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "late:"+"2"}
            else if(indexPath.row==1){cell.textLabel?.text = "leaveEarly:"+"0"}
            else if(indexPath.row==2){
                if(infor[rowSelected!].payment! < 10000){
                    cell.textLabel?.text = "payment:"+"2880"
                }else{
                    cell.textLabel?.text = "payment:"+"45000"
                }
            }
            
            return cell
        }
    }
    
    override func tableView(tableView:UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return nil
        }else if(section == 1){
            return "2016-12-19~2016-12-25"
        }else{
            return "2016-12-12~2016-12-18"
        }
    }    
}