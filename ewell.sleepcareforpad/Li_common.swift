//
//  Li_common.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/20.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class Li_common {
    /*
    快速创建一种常用的button，state：normal，  backgroundcolor：white，  type：system    ControlEvents:TouchUpInside
    */
    func Li_createButton(title:String!,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,target: AnyObject!, action: Selector) ->UIButton{
        var buttonRect:CGRect = CGRect(x:x, y:y, width:width, height:height)
        var button:UIButton = UIButton.buttonWithType(.System) as! UIButton
        button.setTitle(title, forState: UIControlState.Normal)
        button.frame = buttonRect
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
}