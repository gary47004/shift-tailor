//
//  TimeInputTableViewCell.swift
//  shifter
//
//  Created by Frank Wang on 2016/9/10.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

public class TimeInputTableViewCell: UITableViewCell {
        
    @IBOutlet weak var timeInput: UITextField!
        
    public func configure(text text: String?, placeholder: String) {
        timeInput.text = text
        timeInput.placeholder = placeholder
        
        timeInput.accessibilityValue = text
        timeInput.accessibilityLabel = placeholder
        
    }
}
