

import UIKit
import Firebase
import FirebaseDatabase


class AlarmClockViewController: UIViewController{
    var currentUID = String()
    var alarmStoragePlace = String()
    var post = [String : String]()
    var hour = String()
    
    
    
    //宣告手機應用程式儲存空間
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmOutlet: UISwitch!
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        
//        //set default time
//        let timeLabel:String = "\(hourLabel)" +":" + "\(minuteLabel)"
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "hh:mm"
//        let time = dateFormatter.dateFromString(timeLabel)
//        print("ttttttt", timeLabel)
//        print(time)
//        datePicker.date = time!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提醒設定"
        let tabBarVC = self.tabBarController as? TabBarViewController
        currentUID = tabBarVC!.currentUID
        alarmStoragePlace = "employee/"+"\(currentUID)"+"/alarmClock"
        
        //UI
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.datePickerMode = .CountDownTimer
        
        
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
        var dateFormatter1 = NSDateFormatter()
        var dateFormatter2 = NSDateFormatter()
        dateFormatter1.dateFormat = "hh"
        dateFormatter2.dateFormat = "mm"
        
        self.hourLabel.text = dateFormatter1.stringFromDate(sender.date)
        self.minuteLabel.text = dateFormatter2.stringFromDate(sender.date)
        
//        let databaseRef = FIRDatabase.database().reference()
//        let post = ["interval" : String(minutes)]
//        databaseRef.child(alarmStoragePlace).updateChildValues(post)
    }
    
}
