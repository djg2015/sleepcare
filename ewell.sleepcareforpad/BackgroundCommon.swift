//
//  BackgroundCommon.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//背景设置通用处理
@IBDesignable class BackgroundCommon: UIView {

    @IBInspectable var backgroundImage:UIImage? {
        didSet{
            self.layer.contents = backgroundImage?.CGImage
            self.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
