//
//  BlueButtonForPhone.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/11.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class BlueButtonForPhone: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(named: "waneBg"), forState: UIControlState.Normal)
        UIButton.buttonWithType(UIButtonType.Custom)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
    }
    
    
}
