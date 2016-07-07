//
//  TitleLabel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 7/7/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
import UIKit


class TitleLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       self.textAlignment = NSTextAlignment.Center
        self.textColor = UIColor.whiteColor()
        self.font = UIFont.boldSystemFontOfSize(17)
    }
    
    
}
