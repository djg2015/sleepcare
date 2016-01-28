//
//  DateFormatterHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/28/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class DateFormatterHelper{
    private static var Instance: DateFormatterHelper? = nil
    var dateFormatter:NSDateFormatter?
    
    //创建单例
    class func GetInstance()->DateFormatterHelper{
        if self.Instance == nil {
            self.Instance = DateFormatterHelper()
            self.Instance!.dateFormatter  = NSDateFormatter()
            self.Instance!.dateFormatter!.dateStyle = .MediumStyle
            self.Instance!.dateFormatter!.timeStyle = .MediumStyle

            self.Instance!.dateFormatter!.timeZone = NSTimeZone.localTimeZone()
            
        }
        return self.Instance!
    }
   
    /**
    获取今天的日期
    :param: style	要转换的日期格式
    :returns: string型的日期
    */
    func GetStringDateFromCurrent(style:String)->String{
      self.dateFormatter!.dateFormat = style
      var curDate = NSDate()
      return  self.dateFormatter!.stringFromDate(curDate)
    }

    
    /**
    把string型日期转换为date型日期
    :param: data	string类型的日期
    :param: style	要转换的日期格式
    :returns: date型的日期
    */
    func GetDateFromString(data:String,style:String)->NSDate{
        self.dateFormatter!.dateFormat = style
        return  self.dateFormatter!.dateFromString(data)!
    
    }

}
