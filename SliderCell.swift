//
//  SliderCell.swift
//  shifter
//
//  Created by mac on 2016/11/1.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var preferenceSlider: UISlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func preferenceSliderValue(sender: UISlider) {
        preferenceLabel.text = "\(lroundf(preferenceSlider.value))"
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
