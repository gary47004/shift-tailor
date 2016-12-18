//
//  NotificationTableViewCell.swift
//  shifter
//
//  Created by Frank Wang on 2016/10/25.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var ImageIcon: UIImageView!
    
//    func setType(type: String){
//        typeLabel.text = "[\(type)]"
//    }
    
    func setTitle(title: String){
        titleLabel.text = title
    }
    
    func setNotificationImage(image: String){
        ImageIcon.image = UIImage(named: image)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
