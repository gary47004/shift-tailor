//
//  DateTableViewCell.swift
//  shifter
//
//  Created by Frank Wang on 2016/10/11.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

//    var dateString = String()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(defaultDate: String){
        dateLabel.text = defaultDate
    }
    
    
    @IBAction func setDateInPicker(sender: UIDatePicker) {
        dateLabel.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle) //turn NSDate into String and save in dateLabel
//        dateString = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle) //save in dateString
    }
   

}
