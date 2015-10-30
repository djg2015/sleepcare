//
//  QueryAlarmViewMode.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class QueryAlarmViewModel:BaseViewModel
{
    
}

class QueryAlarmItem
{
    //属性定义
    var _number:Int = 0
    // 序号
    dynamic var Number:Int{
        get
        {
            return self._number
        }
        set(value)
        {
            self._number=value
        }
    }
    
    var _schemaCode:String = ""
    // 报警类型
    dynamic var SchemaCode:String{
        get
        {
            return self._schemaCode
        }
        set(value)
        {
            self._schemaCode = value
        }
    }
    
    var _alarmTime:String = ""
    // 报警时间
    dynamic var AlarmTime:String{
        get
        {
            return self._alarmTime
        }
        set(value)
        {
            self._alarmTime = value
        }
    }

    var _alarmContent:String = ""
    // 报警内容
    dynamic var AlarmContent:String{
        get
        {
            return self._alarmContent
        }
        set(value)
        {
            self._alarmContent = value
        }
    }
    
    var _userName:String = ""
    // 用户姓名
    dynamic var UserName:String{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName = value
        }
    }
    
}
