//
//  WeekreportLabel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 7/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
import UIKit


class WeekreportLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = NSTextAlignment.Center
        self.textColor = UIColor.lightGrayColor()
        self.font = font14
    }
    
    
}
