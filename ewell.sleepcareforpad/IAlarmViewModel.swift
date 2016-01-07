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
        
        LoadData()
    }
    
    func LoadData(){
        try {
            ({
                //每次打开IAlarmView页面，从服务器获取未处理的信息，刷新table内容
                IAlarmHelper.GetAlarmInstance().ReloadUndealedWarning()
                
                var tempAlarmArray = Array<IAlarmTableCellViewModel>()
                var warningList = IAlarmHelper.GetAlarmInstance().WarningList
                for (var i = 0 ; i < warningList.count ; i++){
                    var tempAlarm = IAlarmTableCellViewModel()
                    var info = warningList[i]
                    tempAlarm.AlarmCode = info.AlarmCode
                    tempAlarm.PartName = info.PartName
                    tempAlarm.UserName = "姓名:" + info.UserName
                    tempAlarm.BedNumber = "床号:" + info.BedNumber
                    tempAlarm.AlarmDate = "报警时间：" + info.AlarmDate

                    tempAlarm.AlarmContent = info.AlarmContent
                    tempAlarm.deleteAlarmHandler = self.DeleteAlarm
                    tempAlarm.moreAlarmHandler = self.MoreAlarm
                    tempAlarmArray.append(tempAlarm)
                }//for i
                
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
    
     //处理服务器端的报警信息，002为处理，003为误报警.delete按钮对应的是误报警操作
    func DeleteAlarm(alarmViewModel:IAlarmTableCellViewModel){
        self.RemoveAlarm(alarmViewModel)
        var code = alarmViewModel.AlarmCode!
       
        try {
            ({
                var sleepCareBLL = SleepCareBussiness()
                sleepCareBLL.HandleAlarm(code, transferType: "003")
                println("误报警！！！！")
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
     //处理服务器端的报警信息，002为处理，003为误报警.more按钮对应的是处理操作
    func MoreAlarm(alarmViewModel:IAlarmTableCellViewModel){
       self.RemoveAlarm(alarmViewModel)
         var code = alarmViewModel.AlarmCode!
       
        try {
            ({
                var sleepCareBLL = SleepCareBussiness()
                sleepCareBLL.HandleAlarm(code, transferType: "002")
                println("已处理！！！！")
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}

    }
    
    //删除内存中当前的alarm信息，删除todolist中对应item信息
    func RemoveAlarm(alarmViewModel:IAlarmTableCellViewModel){
        var code = alarmViewModel.AlarmCode!
        TodoList.sharedInstance.removeItemByID(code)
        var tempwarningList = IAlarmHelper.GetAlarmInstance().WarningList
        var codes = IAlarmHelper.GetAlarmInstance().Codes
        for(var i = 0; i < tempwarningList.count; i++){
            if code == tempwarningList[i].AlarmCode{
                tempwarningList.removeAtIndex(i)
                IAlarmHelper.GetAlarmInstance().WarningList = tempwarningList
                break
            }
        }
        for (var i = 0; i < codes.count; i++){
            if code == codes[i]{
                codes.removeAtIndex(i)
                IAlarmHelper.GetAlarmInstance().Codes = codes
                break
            }
        }

    }
    
}
