

import UIKit
import Firebase
import FirebaseDatabase


class AlarmClockViewController: UIViewController{
    var currentUID = String()
    var alarmStoragePlace = String()
    var post = [String : String]()
    var hour = Int()
    var minute = Int()
    
    //宣告手機應用程式儲存空間
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmOutlet: UISwitch!
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        
        //set default time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if defaults.objectForKey("timeString") != nil{
            let time = dateFormatter.dateFromString(defaults.objectForKey("timeString") as! String)
            datePicker.date = time!
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提醒設定"
        let tabBarVC = self.tabBarController as? TabBarViewController
        currentUID = tabBarVC!.currentUID
        
        let databaseRef = FIRDatabase.database().reference()
        alarmStoragePlace = "employee/"+"\(currentUID)"+"/alarmClock"
        
        //UI
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.datePickerMode = .CountDownTimer
        
        //get time from DB
        databaseRef.child(alarmStoragePlace).observeEventType(.Value, withBlock: {snapshot in
            let interval = Int(snapshot.value!["interval"] as! String)
            
            self.minute = interval!%60
            self.hour = (interval!-self.minute)/60
            
            self.minuteLabel.text = String(self.minute)
            self.hourLabel.text = String(self.hour)
            
            
        })
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        if defaults.boolForKey("switchState") == true {
            alarmOutlet.on = true
        }else if defaults.boolForKey("switchState") == false {
            alarmOutlet.on = false
        }

        
    }
    
    @IBAction func alarmSwitch(alarmOutlet: UISwitch) {
        let databaseRef = FIRDatabase.database().reference()
        
        if(alarmOutlet.on==true){
            post = ["switch" : "on"]
            databaseRef.child(alarmStoragePlace).updateChildValues(post)
            defaults.setBool(true, forKey: "switchState")
        }else{
            post = ["switch" : "off"]
            databaseRef.child(alarmStoragePlace).updateChildValues(post)
            defaults.setBool(false, forKey: "switchState")
        }
    }
    
    @IBAction func pickerChange(sender: UIDatePicker) {
        let dateFormatter1 = NSDateFormatter()
        let dateFormatter2 = NSDateFormatter()
        let dateFormatter0 = NSDateFormatter()
        
        dateFormatter1.dateFormat = "HH"
        dateFormatter2.dateFormat = "mm"
        dateFormatter0.dateFormat = "HH:mm"
        
        let hourString = dateFormatter1.stringFromDate(sender.date)
        let minuteString = dateFormatter2.stringFromDate(sender.date)
        let timeString = dateFormatter0.stringFromDate(sender.date)
        
        defaults.setObject(timeString, forKey: "timeString")
        
        
        let hour = Int(hourString)
        let minute = Int(minuteString)
        
        let time = String(hour!*60 + minute!)
        
        let timeStruct = ["interval" : time]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(alarmStoragePlace).updateChildValues(timeStruct)
        
    }
    
}
