//
//  DatePickerCell.swift
//  RVCalendarView
//
//  Created by mac on 2016/9/28.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var dateData: NSDate!
    override func awakeFromNib() {
        super.awakeFromNib()
//        dateLabel.text = NSDateFormatter.localizedStringFromDate(NSDate.now(), dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
//
//               datePickerChanged()
    
        // Initialization code
    }
    
    func setLabel(date: NSDate) {
        dateLabel.text = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        dateData = date
        

    }
    
    func setDatePickerValue(date:NSDate){
        self.datePicker.date = date
    }
   
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        dateLabel.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        dateData = datePicker.date
        
        print("Date: ", dateData)

    }
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
