//
//  MeTabLabel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 7/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
import UIKit


class MeTabLabel: UILabel {
     required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
 }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = NSTextAlignment.Left
        self.textColor = textGraycolor
        self.font = font16
    }

  
}
