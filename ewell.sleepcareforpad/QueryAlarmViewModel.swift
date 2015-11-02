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
    var searchAlarm: RACCommand?
    
    override init()
    {
        super.init()
        
        self.searchAlarm = RACCommand(){
            
            (any:AnyObject!) -> RACSignal in
            return self.SearchAlarm()
        }
    }
    
    //自定义方法
    func SearchAlarm() -> RACSignal{
        try {
            ({
                
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        return RACSignal.empty()
    }
    
    
    var _userNameCondition:String = ""
    // 用户姓名查询条件
    dynamic var UserNameCondition:String{
        get
        {
            return self._userNameCondition
        }
        set(value)
        {
            self._userNameCondition = value
        }
    }
    
    var _bedNumberCondition:String = ""
    // 床位号查询条件
    dynamic var BedNumberCondition:String{
        get
        {
            return self._bedNumberCondition
        }
        set(value)
        {
            self._bedNumberCondition = value
        }
    }
    
    var _selectedAlarmType:String = ""
    // 选择的报警类型编号
    dynamic var SelectedAlarmType:String{
        get
        {
            return self._selectedAlarmType
        }
        set(value)
        {
            self._selectedAlarmType = value
        }
    }
    
    // 属性定义
    var _alarmList:Array<QueryAlarmItem> = Array<QueryAlarmItem>()
    // 报警信息列表
    dynamic var AlarmList:Array<QueryAlarmItem>{
        get
        {
            return self._alarmList
        }
        set(value)
        {
            self._alarmList = value
        }
    }
    
    var _alarmTypeList:Array<DownListModel> = Array<DownListModel>()
    dynamic var AlarmTypeList:Array<DownListModel>{
        get
        {
            var item:DownListModel = DownListModel()
            item.key = ""
            item.value = "全部"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_TEMPERATURE"
            item.value = "体温报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_HEARTBEAT"
            item.value = "心率报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BREATH"
            item.value = "呼吸报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BEDSTATUS"
            item.value = "在离床报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_FALLINGOUTOFBED"
            item.value = "坠床风险报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BEDSORE"
            item.value = "褥疮风险报警"
            _alarmTypeList.append(item)
            
            return _alarmTypeList
        }
    }
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
