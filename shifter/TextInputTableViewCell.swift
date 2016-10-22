//
//  TextInputTableViewCell.swift
//  shifter
//
//  Created by Frank Wang on 2016/9/2.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//


import UIKit

public class TitleInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleInput: UITextField!
    
    public func configure(text text: String?, placeholder: String) {
        titleInput.text = text
        titleInput.placeholder = placeholder
        
        titleInput.accessibilityValue = text
        titleInput.accessibilityLabel = placeholder
        
    }
    
}

