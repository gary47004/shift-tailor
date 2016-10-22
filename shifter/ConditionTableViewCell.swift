//
//  ConditionTableViewCell.swift
//  RVCalendarView
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 ssiang1627. All rights reserved.
//

import UIKit

class ConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var totalEmployeeLabel: UILabel!
   
    @IBOutlet weak var lackingEmployeeLabel: UILabel!
    
    @IBOutlet weak var deploymentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
