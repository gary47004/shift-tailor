//
//  employeeCell.swift
//  RVCalendarView
//
//  Created by mac on 2016/9/29.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class employeeCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var empTitleLabel: UILabel!

    @IBOutlet weak var txtNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        addDoneButtonOnKeyboard()
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(employeeCell.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtNumber.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtNumber.resignFirstResponder()
    }

}
