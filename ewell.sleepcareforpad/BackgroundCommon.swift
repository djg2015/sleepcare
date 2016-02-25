//
//  BackgroundCommon.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//背景设置通用处理
@IBDesignable class BackgroundCommon: UIView{

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var ImageName:String? {
        didSet{
            if ImageName != nil{
            var imgName = GetImg(ImageName!)
                self.layer.contents = UIImage(named:imgName)?.CGImage
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
    
    
 
    
}
