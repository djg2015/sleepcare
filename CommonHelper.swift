//
//  CommonHelper.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
let USERID:String = "userId"
let PASS:String = "Pass"
let SERVER:String = "Server"

func getCurrentTime() -> String{
    
    var nowUTC:NSDate  = NSDate()
    
    var dateFormatter:NSDateFormatter  = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    dateFormatter.dateStyle = .MediumStyle
    dateFormatter.timeStyle = .MediumStyle
    
    return dateFormatter.stringFromDate(nowUTC)
    
}