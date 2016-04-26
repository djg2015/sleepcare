//
//  AlarmViewModel.swift
//  
//
//  Created by Qinyuan Liu on 4/21/16.
//
//

import Foundation

class AlarmViewModel: BaseViewModel {
    var _alarmArray:Array<AlarmTableCellViewModel>!
    dynamic var AlarmArray:Array<AlarmTableCellViewModel>{
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
                //刷新todolist里信息
                IAlarmHelper.GetAlarmInstance().ReloadTodoList()
                
                var tempAlarmArray = Array<AlarmTableCellViewModel>()
                var warningList = IAlarmHelper.GetAlarmInstance().WarningList
                for (var i = 0 ; i < warningList.count ; i++){
                    var tempAlarm = AlarmTableCellViewModel()
                    var info = warningList[i]
                    tempAlarm.AlarmCode = info.AlarmCode
                    tempAlarm.PartName = info.PartName
                    tempAlarm.UserName = "姓名:" + info.UserName
                    tempAlarm.BedNumber = "床号:" + info.BedNumber
                    tempAlarm.AlarmDate = "报警时间：" + info.AlarmDate
                    tempAlarm.AlarmContent = info.AlarmContent
                    tempAlarm.deleteAlarmHandler = self.DeleteAlarm
                    
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
    
    
   //alarmcell删除操作
    func DeleteAlarm(alarmViewModel:AlarmTableCellViewModel){
         //调用服务器接口同步报警信息，标志为已读
        let code = alarmViewModel.AlarmCode!
        try {
            ({
                SleepCareBussiness().DeleteAlarmMessage(code, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        //从todolist和报警信息列表中删除这个老人相关的报警
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
