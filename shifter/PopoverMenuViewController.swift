//
//  PopoverMenuViewController.swift
//  shifter
//
//  Created by mac on 2016/10/29.
//  Copyright © 2016年 Chlorophyll. All rights reserved.
//

import UIKit


protocol MenuButtonDelegate {
    func buttonTapped(buttonTapped : String)
    func setDeadlineDate()
    func dropEvent()
    }
class PopoverMenuViewController: UIViewController {
    
    var delegate : MenuButtonDelegate?

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendEvent(sender: UIButton) {
        if self.delegate != nil {
            delegate?.buttonTapped("send")
            print("Send")
            self.dismissViewControllerAnimated(true, completion: {self.delegate?.setDeadlineDate()})
        }
        
    }
    
    @IBAction func dropEvent(sender: UIButton) {
        if self.delegate != nil {
            delegate?.buttonTapped("drop")
            print("Drop")
            self.dismissViewControllerAnimated(true, completion: {self.delegate?.dropEvent()})

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

