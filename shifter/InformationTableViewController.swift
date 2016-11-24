//
//  InformationTableViewController.swift
//  shifter
//
//  Created by gary on 2016/11/23.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct informationStruct {
    let id : String
    let district : String
    let name : String
    let phone : String
    let rank : String
    let store : String
    var late = 0
    var leaveEarly = 0
    var profession = [String]()
    var payment : Int?
}
//global


class InformationTableViewController: UITableViewController {
        var id = String()
        var rank = String()
        var store = String()
    
    
        var infor = [informationStruct]()
        struct attendanceStruct{
            let startDate : String!
            let endDate : String!
            let arrivalTime : String?
            let departureTime : String?
        }
        var attendance = [attendanceStruct]()
        let now = NSDate()
        var formatter = NSDateFormatter()
        let myCalendar = NSCalendar.currentCalendar()
        var firstDay = ""
        
        
        override func viewDidLoad() {
            
            let tabBarVC = self.tabBarController as! TabBarViewController
            id = tabBarVC.currentUID
            rank = tabBarVC.currentRank
            store = tabBarVC.currentSID
            super.viewDidLoad()
            
            // Do any additional setup after loading the view, typically from a nib.
            
            
            let addingNumber = 1-Int(myCalendar.component(.Weekday, fromDate: now))
            
            let firstDayOfWeek = myCalendar.dateByAddingUnit(.Day, value: addingNumber, toDate: now, options: [])
            //現在日期加上addingNumber的日期
            formatter.dateFormat = "yyyy-M-dd"
            firstDay = formatter.stringFromDate(firstDayOfWeek!)
            
            
            if(rank=="storeManager"){
                let membersStoragePlace = "store/"+"\(store)"+"/members"
                var members = [String]()
                //宣告陣列方法
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child(membersStoragePlace).observeEventType(.ChildAdded, withBlock: {
                    snapshot in
                    
                    members.append(snapshot.key)
                    let i = members.count-1
                    //View.reloadData()
                    self.id = members[i]
                    self.managerDownload(i)
                    print("a")
                    self.tableView.reloadData()
                    
                })
                
                
            }else {
                download(0)
                self.tableView.reloadData()
            }
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        func managerDownload(i:Int){
            let emid = id
            var emdistrict : String?
            var emname : String?
            var emphone : String?
            var emrank : String?
            let emstore = store
            var lateAndLeaveEarly = ["late":0, "leaveEarly":0]
            var emprofession = [String]()
            var empaymentKey : String?
            var empaymentRate : String?
            var empayment : Int!
            var emstoragePlace = ""
            var empersonalStoragePlace = ""
            var emprofessionStoragePlace = ""
            var empaymentStoragePlace = ""
            emstoragePlace = "employeeShift/"+"\(emstore)"+"/"+"\(firstDay)"+"/"+"\(emid)"
            empersonalStoragePlace = "employee/"+"\(emid)"
            emprofessionStoragePlace = "\(empersonalStoragePlace)"+"/profession"
            empaymentStoragePlace = "\(empersonalStoragePlace)"+"/payment"
            
            
            let databaseRef = FIRDatabase.database().reference()
            
            //順序很重要
            databaseRef.child(empersonalStoragePlace).observeEventType(.Value, withBlock: {
                snapshot in
                
                emdistrict = snapshot.value!["district"] as? String
                emname = snapshot.value!["name"] as? String
                emphone = snapshot.value!["phone"] as? String
                emrank = snapshot.value!["rank"] as? String
                print("b")
            })
            
            databaseRef.child(emprofessionStoragePlace).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                emprofession.append(snapshot.key)
                print("c")
            })
            
            databaseRef.child(empaymentStoragePlace).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                empaymentKey = snapshot.key
                print("d")
                self.attendance.removeAll()
                print("check")
            })
            
            databaseRef.child(empaymentStoragePlace).observeEventType(.Value, withBlock: {
                snapshot in
                
                empaymentRate = snapshot.value![empaymentKey!] as? String
                print("e")
            })
            
            databaseRef.child(emstoragePlace).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                let start = snapshot.value!["Start Date"] as? String
                let end = snapshot.value!["End Date"] as? String
                let arrival = snapshot.value!["arrivalTime"] as? String
                let departure = snapshot.value!["departureTime"] as? String
                
                self.attendance.insert(attendanceStruct(startDate: start, endDate: end, arrivalTime: arrival, departureTime: departure), atIndex: 0)
                print("g")
                
                
                empayment = self.pay(empaymentKey, rate: empaymentRate)
                lateAndLeaveEarly["late"] = self.lateOrLeaveEarly()["late"]
                lateAndLeaveEarly["leaveEarly"] = self.lateOrLeaveEarly()["leaveEarly"]
                print("f")
                if(self.infor.count==i){
                    self.infor.insert(informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession, payment: empayment), atIndex: i)
                }else{
                    self.infor[i] = informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession, payment: empayment)}
                print(self.infor)
                self.tableView.reloadData()
            })
        }
        
        
        func download(i:Int){
            let emid = id
            var emdistrict : String?
            var emname : String?
            var emphone : String?
            var emrank : String?
            let emstore = store
            var lateAndLeaveEarly = ["late":0, "leaveEarly":0]
            var emprofession = [String]()
            var empaymentKey : String?
            var empaymentRate : String?
            var empayment : Int!
            var emstoragePlace = ""
            var empersonalStoragePlace = ""
            var emprofessionStoragePlace = ""
            var empaymentStoragePlace = ""
            emstoragePlace = "employeeShift/"+"\(emstore)"+"/"+"\(firstDay)"+"/"+"\(emid)"
            empersonalStoragePlace = "employee/"+"\(emid)"
            emprofessionStoragePlace = "\(empersonalStoragePlace)"+"/profession"
            empaymentStoragePlace = "\(empersonalStoragePlace)"+"/payment"
            
            
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child(empersonalStoragePlace).observeEventType(.Value, withBlock: {
                snapshot in
                
                emdistrict = snapshot.value!["district"] as? String
                emname = snapshot.value!["name"] as? String
                emphone = snapshot.value!["phone"] as? String
                emrank = snapshot.value!["rank"] as? String
                print("b")
            })
            
            databaseRef.child(emprofessionStoragePlace).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                emprofession.append(snapshot.key)
                print("c")
            })
            
            databaseRef.child(empaymentStoragePlace).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                
                empaymentKey = snapshot.key
                print("d")
                self.attendance.removeAll()
                print("check")
            })
            
            databaseRef.child(empaymentStoragePlace).observeEventType(.Value, withBlock: {
                snapshot in
                
                empaymentRate = snapshot.value![empaymentKey!] as? String
                print("e")
                
                
                databaseRef.child(emstoragePlace).observeEventType(.ChildAdded, withBlock: {
                    snapshot in
                    
                    let start = snapshot.value!["Start Date"] as? String
                    let end = snapshot.value!["End Date"] as? String
                    let arrival = snapshot.value!["arrivalTime"] as? String
                    let departure = snapshot.value!["departureTime"] as? String
                    
                    self.attendance.insert(attendanceStruct(startDate: start, endDate: end, arrivalTime: arrival, departureTime: departure), atIndex: 0)
                    print("g")
                    
                    
                    empayment = self.pay(empaymentKey, rate: empaymentRate)
                    lateAndLeaveEarly["late"] = self.lateOrLeaveEarly()["late"]
                    lateAndLeaveEarly["leaveEarly"] = self.lateOrLeaveEarly()["leaveEarly"]
                    print("f")
                    if(self.infor.count==i){
                        self.infor.insert(informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession, payment: empayment), atIndex: i)
                    }else{
                        self.infor[i] = informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession, payment: empayment)}
                    print(self.infor)
                    self.tableView.reloadData()
                })
            })
        }
        
        
        func pay(key:String?, rate:String?)->Int{
            print("h")
            if(key=="hourly"){
                var hours = 0
                formatter.dateFormat = "yyyy-M-dd-H:mm"
                for(var i=0;i<attendance.count;i += 1){
                    
                    if(attendance[i].arrivalTime != nil && attendance[i].departureTime != nil){
                        let a = formatter.dateFromString(attendance[i].arrivalTime!)
                        let b = formatter.dateFromString(attendance[i].departureTime!)
                        
                        let compareResult = b!.compare(a!)
                        let interval = b!.timeIntervalSinceDate(a!)
                        hours += Int(interval)/3600
                    }
                }
                let emPayment = Int(rate!)!*hours
                return emPayment
            }else{
                let emPayment = Int(rate!)
                return emPayment!
            }
        }
        
        
        func lateOrLeaveEarly()->[String:Int]{
            print("i")
            var lateCount = 0
            var leaveEarlyCount = 0
            formatter.dateFormat = "yyyy-M-dd-H:mm"
            for(var i=0;i<attendance.count;i += 1){
                
                if(attendance[i].arrivalTime != nil){
                    let a = formatter.dateFromString(attendance[i].startDate!)
                    let b = formatter.dateFromString(attendance[i].arrivalTime!)
                    
                    let compareResult = b!.compare(a!)
                    let interval = b!.timeIntervalSinceDate(a!)
                    if(interval>0){lateCount += 1}
                }
                if(attendance[i].departureTime != nil){
                    let a = formatter.dateFromString(attendance[i].endDate!)
                    let b = formatter.dateFromString(attendance[i].departureTime!)
                    
                    let compareResult = b!.compare(a!)
                    let interval = b!.timeIntervalSinceDate(a!)
                    if(interval<0){leaveEarlyCount += 1}
                }
                
            }
            let array = ["late":lateCount, "leaveEarly":leaveEarlyCount]
            return array
        }
        
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return infor.count
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath)
            cell.textLabel?.text = infor[indexPath.row].id
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        }
        
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.performSegueWithIdentifier("showDetail", sender: indexPath.row)
        }
        
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let number = sender as! Int
            let vc = segue.destinationViewController as! DetailTableViewController
            vc.navigationItem.title = infor[number].id
            
            vc.rowSelected = number
            vc.infor = infor
            //傳資料
            
            //        let idLabel = vc.view.viewWithTag(1) as! UILabel
            //        idLabel.text = "id:"+"\(infor[number].id)"
            //        let districtLabel = vc.view.viewWithTag(2) as! UILabel
            //        districtLabel.text = "district:"+"\(infor[number].district)"
            //        let nameLabel = vc.view.viewWithTag(3) as! UILabel
            //        nameLabel.text = "name:"+"\(infor[number].name)"
            //        let phoneLabel = vc.view.viewWithTag(4) as! UILabel
            //        phoneLabel.text = "phone:"+"\(infor[number].phone)"
            //        let rankLabel = vc.view.viewWithTag(5) as! UILabel
            //        rankLabel.text = "rank:"+"\(infor[number].rank)"
            //        let storeLabel = vc.view.viewWithTag(6) as! UILabel
            //        storeLabel.text = "store:"+"\(infor[number].store)"
            //        let lateLabel = vc.view.viewWithTag(7) as! UILabel
            //        lateLabel.text = "late:"+"\(String(infor[number].late))"
            //        let leaveEarlyLabel = vc.view.viewWithTag(8) as! UILabel
            //        leaveEarlyLabel.text = "leaveEarly:"+"\(String(infor[number].leaveEarly))"
            //        let professionLabel = vc.view.viewWithTag(9) as! UILabel
            //        professionLabel.text = "profession:"+"\(infor[number].profession)"
            //        let paymentLabel = vc.view.viewWithTag(10) as! UILabel
            //        paymentLabel.text = "payment:"+"\(String(infor[number].payment))"
        }
        
    }

