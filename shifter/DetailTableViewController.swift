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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
        if(indexPath.row==0){cell.textLabel?.text = "id:"+"\(infor[rowSelected!].id)"}
        else if(indexPath.row==1){cell.textLabel?.text = "district:"+"\(infor[rowSelected!].district)"}
        else if(indexPath.row==2){cell.textLabel?.text = "name:"+"\(infor[rowSelected!].name)"}
        else if(indexPath.row==3){cell.textLabel?.text = "phone:"+"\(infor[rowSelected!].phone)"}
        else if(indexPath.row==4){cell.textLabel?.text = "rank:"+"\(infor[rowSelected!].rank)"}
        else if(indexPath.row==5){cell.textLabel?.text = "store:"+"\(infor[rowSelected!].store)"}
        else if(indexPath.row==6){cell.textLabel?.text = "late:"+"\(String(infor[rowSelected!].late))"}
        else if(indexPath.row==7){cell.textLabel?.text = "leaveEarly:"+"\(String(infor[rowSelected!].leaveEarly))"}
        else if(indexPath.row==8){cell.textLabel?.text = "profession:"+"\(infor[rowSelected!].profession)"}
        else if(indexPath.row==9){cell.textLabel?.text = "payment:"+"\(String(infor[rowSelected!].payment!))"}
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}