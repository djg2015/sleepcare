//
//  HrRrSleepTabLabel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 7/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//


import Foundation
import UIKit


class HrRrSleepTabLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textAlignment = NSTextAlignment.Center
        self.textColor = textDarkgrey
        self.font = font14
    }
    
    
}