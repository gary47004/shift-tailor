//
//  AlarmSwitchTableViewCell.swift
//  shifter
//
//  Created by gary on 2016/11/26.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class AlarmSwitchTableViewCell: UITableViewCell {
    
    //subclass 客製化cell
    @IBOutlet weak var alarmOutlet: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
