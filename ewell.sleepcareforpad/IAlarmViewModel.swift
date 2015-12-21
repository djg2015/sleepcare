//
//  IAlarmViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/18/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import Foundation

class IAlarmViewModel: BaseViewModel {
    
    var _alarmArray:Array<IAlarmTableCellViewModel>!
    dynamic var AlarmArray:Array<IAlarmTableCellViewModel>{
        get
        {
            return self._alarmArray
        }
        set(value)
        {
            self._alarmArray=value
        }
    }
    
    //构造函数
    override init(){
        super.init()
        
        InitData()
    }
    
    func InitData(){
        try {
            ({
                var todolist:Array<TodoItem> = TodoList.sharedInstance.allItems()
                var tempAlarmArray = Array<IAlarmTableCellViewModel>()
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                for (var i = 0 ; i<todolist.count ; i++){
                var tempAlarm = IAlarmTableCellViewModel()
                    tempAlarm.AlarmCode = todolist[i].UUID
                    tempAlarm.AlarmDate = dateFormatter.stringFromDate(todolist[i].deadline)
                    tempAlarm.AlarmContent = todolist[i].title
                    tempAlarm.deleteAlarmHandler = self.DeleteAlarm
                    tempAlarmArray.append(tempAlarm)
                }
                self.AlarmArray = tempAlarmArray
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
    //根据code删除对应的todoitem
    func DeleteAlarm(alarmViewModel:IAlarmTableCellViewModel){
    
    TodoList.sharedInstance.removeItemByID(alarmViewModel.AlarmCode!)
        
    }
    
}
