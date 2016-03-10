//
//  CommonHelper.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

//获取当前时间
func getCurrentTime() -> String{

   return DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy年MM月dd日 HH:mm:ss")
}

func getDateTime(data:String,dateFormat:String = "yyyy-MM-dd") -> NSDate{
    

    return DateFormatterHelper.GetInstance().GetDateFromString(data,style:"yyyy-MM-dd")
}

//获取指定格式时间
func getCurrentTime(dateFormat:String) -> String{

    return DateFormatterHelper.GetInstance().GetStringDateFromCurrent(dateFormat)
}


//基本弹窗
func showDialogMsg(msg:String,title:String? = "提示"){
    if("ipad" == deviceType){
        SweetAlert().showAlert(msg,subTitle: title, style: .None)
    }
    else{
        SweetAlert(contentHeight: 300).showAlert(msg,subTitle: title, style: .None)
    }
}
//弹窗带返回处理
func showDialogMsg(msg:String,title:String?,buttonTitle:String? = "确定", action: ((isOtherButton: Bool) -> Void)? = nil){
    var inTitle:String?
    if(title == nil){
        inTitle = "提示"
    }
    if("ipad" == deviceType){
        SweetAlert().showAlert(msg, subTitle: inTitle, style: .None, buttonTitle: buttonTitle!, action: action)
    }
    else{
        SweetAlert(contentHeight: 300).showAlert(msg, subTitle: inTitle, style: .None, buttonTitle: buttonTitle!, action: action)
    }
}




//入口处理总入口
func handleException(ex:NSObject, showDialog:Bool = false,msg:String = ""){
    if(showDialog){
        if(msg == ""){
            showDialogMsg((ex as! NSException).reason!)
        }
        else{
            showDialogMsg(msg)
        }
    }
}



//截取指定参数字符串
extension String {
    func subString(begin:Int,length:Int) -> String{
        var s = self as NSString
        return s.substringWithRange(NSMakeRange(begin,length))
    }
}

extension String {
    func toUInt() -> UInt? {
        if contains(self, "-") {
            return nil
        }
        return self.withCString { cptr -> UInt? in
            var endPtr : UnsafeMutablePointer<Int8> = nil
            errno = 0
            let result = strtoul(cptr, &endPtr, 10)
            if errno != 0 || endPtr.memory != 0 {
                return nil
            } else {
                return result
            }
        }
    }
    
    //分割字符
    func split(s:String)->[String]{
        if s.isEmpty{
            var x=[String]()
            for y in self{
                x.append(String(y))
            }
            return x
        }
        return self.componentsSeparatedByString(s)
    }
}
