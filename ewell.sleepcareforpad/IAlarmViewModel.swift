//
//  AlarmViewModel.swift
//
//
//  Created by Qinyuan Liu on 4/21/16.
//
//

import Foundation

class IAlarmViewModel: BaseViewModel {
    var _alarmArray:Array<AlarmTableCell>!
    dynamic var AlarmArray:Array<AlarmTableCell>{
        get
        {
            return self._alarmArray
        }
        set(value)
        {
            self._alarmArray=value
        }
    }
    
    var codeList:Array<String>=Array<String>()
    
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
                
                var tempAlarmArray = Array<AlarmTableCell>()
                var warningList = IAlarmHelper.GetAlarmInstance().WarningList
                for (var i = 0 ; i < warningList.count ; i++){
                    var tempAlarm = AlarmTableCell()
                    var info = warningList[i]
                    tempAlarm.AlarmCode = info.AlarmCode
                    switch(info.AlarmType){
                    case "ALM_TEMPERATURE":
                        tempAlarm.AlarmType = "体温"
                    case "ALM_HEARTBEAT":
                        tempAlarm.AlarmType = "心率"
                    case "ALM_BREATH":
                        tempAlarm.AlarmType = "呼吸"
                    case "ALM_BEDSTATUS":
                        tempAlarm.AlarmType = "在离床"
                    case  "ALM_FALLINGOUTOFBED":
                        tempAlarm.AlarmType = "坠床风险"
                    case  "ALM_BEDSORE":
                        tempAlarm.AlarmType = "褥疮风险"
                    case   "ALM_CALL":
                        tempAlarm.AlarmType = "呼叫"
                    default:
                        tempAlarm.AlarmType = ""
                        
                        
                    }
                    
                    tempAlarm.EquipmentCode = info.EquipmentID
                    tempAlarm.UserCode = info.UserCode
                    tempAlarm.UserGender = info.Sex
                    tempAlarm.UserName = info.UserName
                    tempAlarm.UserBedNumber =  info.BedNumber
                    tempAlarm.AlarmTime = info.AlarmTime
                    tempAlarm.AlarmContent = info.AlarmContent
                    tempAlarm.deleteAlarmHandler = self.DeleteAlarm
                    
                    tempAlarmArray.append(tempAlarm)
                    self.codeList.append(info.AlarmCode)
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
    
    
    
    
    //alarmcell单个删除操作（滑动删除）
    func DeleteAlarm(alarmViewModel:AlarmTableCell){
        let code = alarmViewModel.AlarmCode
        self.DeleteToServer(code)
        self.DeleteFromTodolist(code)
    }
    
    //    //alarmcell多个删除操作（edit模式下）
    //    func DeleteMutipleAlarms(codes:String){
    //
    //        self.DeleteToServer(codes)
    //        let codeList = split(codes){$0 == ","}
    //        for code in codeList{
    //        self.DeleteFromTodolist(code)
    //        }
    //
    //    }
    
    
    //调用服务器接口同步报警信息，标志为已读
    func DeleteToServer(codes:String){
        try {
            ({
                SleepCareForIPhoneBussiness().DeleteAlarmMessage(codes, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
    func DeleteFromTodolist(code:String){
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

class AlarmTableCell:NSObject{
    //属性定义
    var _alarmCode:String = ""
    dynamic var AlarmCode:String{
        get
        {
            return self._alarmCode
        }
        set(value)
        {
            self._alarmCode=value
        }
    }
    
    var _equipmentCode:String = ""
    dynamic var EquipmentCode:String{
        get
        {
            return self._equipmentCode
        }
        set(value)
        {
            self._equipmentCode=value
        }
    }
    
    var _userGender:String?
    dynamic var UserGender:String?{
        get
        {
            return self._userGender
        }
        set(value)
        {
            self._userGender=value
        }
    }
    
    var _userName:String?
    dynamic var UserName:String?{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName=value
        }
    }
    var _userCode:String?
    dynamic var UserCode:String?{
        get
        {
            return self._userCode
        }
        set(value)
        {
            self._userCode=value
        }
    }
    
    var _userBedNumber:String?
    dynamic var UserBedNumber:String?{
        get
        {
            return self._userBedNumber
        }
        set(value)
        {
            self._userBedNumber=value
        }
    }
    
    var _alarmTime:String?
    dynamic var AlarmTime:String?{
        get
        {
            return self._alarmTime
        }
        set(value)
        {
            self._alarmTime=value
        }
    }
    
    
    var _alarmContent:String?
    dynamic var AlarmContent:String?{
        get
        {
            return self._alarmContent
        }
        set(value)
        {
            self._alarmContent=value
        }
    }
    
    var _alarmType:String?
    dynamic var AlarmType:String?{
        get
        {
            return self._alarmType
        }
        set(value)
        {
            self._alarmType=value
        }
    }
    
    //操作定义
    var deleteAlarmHandler: ((alarmcell:AlarmTableCell) -> ())?
    
}

