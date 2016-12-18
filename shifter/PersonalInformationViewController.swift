//
//  PersonalInformationViewController.swift
//  shifter
//
//  Created by gary on 2016/12/19.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class PersonalInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var dTableView: UITableView!
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
        //要在viewdidload裡執行
        
        
        //let addingNumber = 1-Int(myCalendar.component(.Weekday, fromDate: now))
        
        //let firstDayOfWeek = myCalendar.dateByAddingUnit(.Day, value: addingNumber, toDate: now, options: [])
        //現在日期加上addingNumber的日期
        formatter.dateFormat = "yyyy-M-dd"
        //firstDay = formatter.stringFromDate(firstDayOfWeek!)
        firstDay = "2016-12-12"
        
        download(0)
        self.dTableView.reloadData()
    }
    func download(i:Int){
        let emid = id
        var emdistrict : String?
        var emname : String?
        var emphone : String?
        var emrank : String?
        let emstore = store
        var lateAndLeaveEarly = ["late":0, "leaveEarly":0]
        var emprofession : String?
        var empaymentKey : String?
        var empaymentRate : String?
        var empayment : Int!
        var emstoragePlace = ""
        var empersonalStoragePlace = ""
        var empaymentStoragePlace = ""
        emstoragePlace = "employeeShift/"+"\(emstore)"+"/"+"\(firstDay)"+"/"+"\(emid)"
        empersonalStoragePlace = "employee/"+"\(emid)"
        empaymentStoragePlace = "\(empersonalStoragePlace)"+"/payment"
        
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child(empersonalStoragePlace).observeEventType(.Value, withBlock: {
            snapshot in
            
            emdistrict = snapshot.value!["district"] as? String
            emname = snapshot.value!["name"] as? String
            emphone = snapshot.value!["phone"] as? String
            emrank = snapshot.value!["rank"] as? String
            emprofession = snapshot.value!["profession"] as? String
            print("b")
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
                
                let start = snapshot.value!["startDate"] as? String
                let end = snapshot.value!["endDate"] as? String
                let arrival = snapshot.value!["arrivalTime"] as? String
                let departure = snapshot.value!["departureTime"] as? String
                
                self.attendance.insert(attendanceStruct(startDate: start, endDate: end, arrivalTime: arrival, departureTime: departure), atIndex: 0)
                print("g")
                
                
                empayment = self.pay(empaymentKey, rate: empaymentRate)
                lateAndLeaveEarly["late"] = self.lateOrLeaveEarly()["late"]
                lateAndLeaveEarly["leaveEarly"] = self.lateOrLeaveEarly()["leaveEarly"]
                print("f")
                if(self.infor.count==i){
                    self.infor.insert(informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession!, payment: empayment), atIndex: i)
                }else{
                    self.infor[i] = informationStruct(id: emid, district: emdistrict!, name: emname!, phone: emphone!, rank: emrank!, store: emstore, late: lateAndLeaveEarly["late"]!, leaveEarly: lateAndLeaveEarly["leaveEarly"]!, profession: emprofession!, payment: empayment)
                }
                print(self.infor)
                self.dTableView.reloadData()
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
                if(interval>0){
                    lateCount += 1
                }
            }
            if(attendance[i].departureTime != nil){
                let a = formatter.dateFromString(attendance[i].endDate!)
                let b = formatter.dateFromString(attendance[i].departureTime!)
                
                let compareResult = b!.compare(a!)
                let interval = b!.timeIntervalSinceDate(a!)
                if(interval<0){
                    leaveEarlyCount += 1
                }
            }
            
        }
        let array = ["late":lateCount, "leaveEarly":leaveEarlyCount]
        return array
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(infor.count>0){
            return 3
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 7
        }else if(section == 1){
            return 3
        }else if(section == 2){
            return 3
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "id:"+"\(infor[0].id)"}
            else if(indexPath.row==1){cell.textLabel?.text = "district:"+"\(infor[0].district)"}
            else if(indexPath.row==2){cell.textLabel?.text = "name:"+"\(infor[0].name)"}
            else if(indexPath.row==3){cell.textLabel?.text = "phone:"+"\(infor[0].phone)"}
            else if(indexPath.row==4){cell.textLabel?.text = "rank:"+"\(infor[0].rank)"}
            else if(indexPath.row==5){cell.textLabel?.text = "store:"+"\(infor[0].store)"}
            else if(indexPath.row==6){cell.textLabel?.text = "profession:"+"\(infor[0].profession)"}
            
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "late:"+"\(String(infor[0].late))"}
            else if(indexPath.row==1){cell.textLabel?.text = "leaveEarly:"+"\(String(infor[0].leaveEarly))"}
            else if(indexPath.row==2){cell.textLabel?.text = "payment:"+"\(String(infor[0].payment!))"}
            
            return cell
        }else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if(indexPath.row==0){cell.textLabel?.text = "late:"+"2"}
            else if(indexPath.row==1){cell.textLabel?.text = "leaveEarly:"+"0"}
            else if(indexPath.row==2){
                if(infor[0].payment! < 10000){
                    cell.textLabel?.text = "payment:"+"2880"
                }else{
                    cell.textLabel?.text = "payment:"+"45000"
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            return cell
        }
    }
    func tableView(tableView:UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return nil
        }else if(section == 1){
            return "2016-12-12~2016-12-18"
        }else{
            return "2016-12-5~2016-12-11"
        }
    }
}
