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
    var tableView:UITableView = UITableView()
    override init()
    {
        super.init()
        
        // 初始化时间
        self.AlarmDateBeginCondition = Date.today().addDays(-7).description(format: "yyyy-MM-dd")
        self.AlarmDateEndCondition = Date.today().description(format: "yyyy-MM-dd")
        
        self.searchAlarm = RACCommand(){
            
            (any:AnyObject!) -> RACSignal in
            return self.SearchAlarm()
        }
        // 初始加载数据
        self.SearchAlarm()
    }
    
    //获取报警信息
    func SearchAlarm() -> RACSignal{
        try {
            ({
                //清空报警列表
                self.AlarmInfoList.removeAll(keepCapacity: true)
                //获取最新在离床报警
                var sleepCareBLL = SleepCareBussiness()
                var alarmList:AlarmList = sleepCareBLL.GetAlarmByUser(Session.GetSession().CurPartCode, userCode: "", userNameLike: self.UserNameCondition, bedNumberLike: self.BedNumberCondition, schemaCode: self.SelectedAlarmTypeCode, alarmTimeBegin:self.AlarmDateBeginCondition, alarmTimeEnd: self.AlarmDateEndCondition, from: nil, max: nil)
                
                var index:Int = 0
                for alarmItem in alarmList.alarmInfoList
                {
                    //放入报警列表
                    var item:QueryAlarmItem = QueryAlarmItem()
                    item.UserName = alarmItem.UserName
                    item.BedNumber = alarmItem.BedNumber
                    item.Number = index
                    item.SchemaCode = alarmItem.SchemaCode
                    item.AlarmTime = (alarmItem.AlarmTime as NSString).substringFromIndex(5)
                    item.AlarmContent = alarmItem.SchemaContent
                    item.AlarmCode = alarmItem.AlarmCode
                    index++
                    self.AlarmInfoList.append(item)
                }
                self.tableView.reloadData()
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
    
    //处理报警：删除对应的todoitem，删除服务端的这条报警信息，从alarmlist中删除
    func HandleAlarm(alarmCode:String,handType:String)
    {
        try {
            ({
                TodoList.sharedInstance.removeItemByID(alarmCode)
                
                var sleepCareBLL = SleepCareBussiness()
                sleepCareBLL.HandleAlarm(alarmCode, transferType: handType)

                self.SearchAlarm()
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
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
    
    var _alarmDateBeginCondition:String = ""
    // 报警日期起始查询条件
    dynamic var AlarmDateBeginCondition:String{
        get
        {
            return self._alarmDateBeginCondition
        }
        set(value)
        {
            self._alarmDateBeginCondition = value
        }
    }
    
    var _alarmDateEndCondition:String = ""
    // 报警日期结束查询条件
    dynamic var AlarmDateEndCondition:String{
        get
        {
            return self._alarmDateEndCondition
        }
        set(value)
        {
            self._alarmDateEndCondition = value
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
    
    var _selectedAlarmTypeCode:String = ""
    // 选择的报警类型编号
    dynamic var SelectedAlarmTypeCode:String{
        get
        {
            return self._selectedAlarmTypeCode
        }
        set(value)
        {
            self._selectedAlarmTypeCode = value
        }
    }

    
    // 属性定义
    var _alarmInfoList:Array<QueryAlarmItem> = Array<QueryAlarmItem>()
    // 报警信息列表
    dynamic var AlarmInfoList:Array<QueryAlarmItem>{
        get
        {
            return self._alarmInfoList
        }
        set(value)
        {
            self._alarmInfoList = value
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
    
    var _alarmCode:String = ""
    // 报警编号
    dynamic var AlarmCode:String{
        get
        {
            return self._alarmCode
        }
        set(value)
        {
            self._alarmCode = value
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
    
    var _bedNumber:String = ""
    // 床位号
    dynamic var BedNumber:String{
        get
        {
            return self._bedNumber
        }
        set(value)
        {
            self._bedNumber = value
        }
    }
    
}
