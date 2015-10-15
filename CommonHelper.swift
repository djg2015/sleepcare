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
//获取当前时间
func getCurrentTime() -> String{
    
    var nowUTC:NSDate  = NSDate()
    
    var dateFormatter:NSDateFormatter  = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//    dateFormatter.timeZone = NSTimeZone.localTimeZone()
//    dateFormatter.dateStyle = .MediumStyle
//    dateFormatter.timeStyle = .MediumStyle
    
    return dateFormatter.stringFromDate(nowUTC)
    
}

var alert = SweetAlert()
//弹窗
func showDialogMsg(msg:String){
    SweetAlert().showAlert(msg)
}

//入口处理总入口
func handleException(ex:NSObject, showDialog:Bool = false,msg:String = ""){
    if(showDialog){
        if(msg == ""){
            showDialogMsg(ex.description)
        }
        else{
            showDialogMsg(msg)
        }
    }
}