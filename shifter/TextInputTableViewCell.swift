//
//  TextInputTableViewCell.swift
//  shifter
//
//  Created by Frank Wang on 2016/9/10.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

public class TextInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textInput: UITextField!
    
    public func configure(text text: String?, placeholder: String) {
        textInput.text = text
        textInput.placeholder = placeholder
        
        textInput.accessibilityValue = text
        textInput.accessibilityLabel = placeholder
    }
    
}