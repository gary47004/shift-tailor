//
//  ShiftEmployeeTableViewCell.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class ShiftEmployeeTableViewCell: UITableViewCell {
   

    
    @IBOutlet weak var employeeNameLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
