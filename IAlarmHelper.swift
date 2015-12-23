//
//  IAlarmHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/17/15.
//  Copyright (c) 2015 djg. All rights reserved.
//
import Foundation
import ObjectiveC

class IAlarmHelper:NSObject, WaringAttentionDelegate {
    
    private static var alarmInstance: IAlarmHelper? = nil
    private var IsOpen:Bool = false
    var alarmdelegate:ShowAlarmDelegate!
    var alarmcountdelegate:GetAlarmCountDelegate!
    private var _wariningCaches:Array<AlarmInfo>!
    
    var _warningcouts:Int = 0
    dynamic var Warningcouts:Int{
        get
        {
            return self._warningcouts
        }
        set(value)
        {
            self._warningcouts = value
        }
    }
    var _codes:Array<String> = []
    dynamic var Codes:Array<String>{
        get
        {
            return self._codes
        }
        set(value)
        {
            self._codes = value
        }
    }
    
    var _warningList:Array<WarningInfo>=[]
    dynamic var WarningList:Array<WarningInfo>{
        get
        {
            return self._warningList
        }
        set(value)
        {
            self._warningList = value
        }
    }
    
    private override init(){
        
    }
    
    class func GetAlarmInstance()->IAlarmHelper{
        if self.alarmInstance == nil {
            self.alarmInstance = IAlarmHelper()
            //实时数据处理代理设置
            var xmppMsgManager = XmppMsgManager.GetInstance()
            xmppMsgManager?._waringAttentionDelegate = self.alarmInstance
            //开启警告信息
            self.alarmInstance!._wariningCaches = Array<AlarmInfo>()
        }
        return self.alarmInstance!
    }
    
    //开始报警提醒
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWariningAction", name: "TodoListShouldRefresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        self.IsOpen = true
        
        //清除已经overdue的todoitem
        for item in TodoList.sharedInstance.allItems(){
            if item.isOverdue {
                TodoList.sharedInstance.removeItemByID(item.UUID)
            }
        }
        self.Warningcouts = TodoList.sharedInstance.allItems().count
        self.setAlarmTimer()
    }
    
    func showWariningAction(){
        if self.alarmdelegate != nil {
            self.alarmdelegate.ShowAlarm()
        }
    }
    
    //关闭报警提醒
    func CloseWaringAttention(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        TodoList.sharedInstance.removeItemAll()
    }
    
    //实时报警处理线程
    func setAlarmTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程处理报警信息，赋值给todolist
    func alarmTimerFireMethod(timer: NSTimer) {
        var tempWarningList = self.WarningList
        if(self._wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self._wariningCaches[0] as AlarmInfo
            let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
            let warningInfo = WarningInfo(alarmCode: alarmInfo.AlarmCode,userName: alarmInfo.UserName,partName: alarmInfo.PartName,bedNumber:alarmInfo.BedNumber,alarmContent: alarmInfo.SchemaContent,alarmDate: alarmInfo.AlarmTime)
            tempWarningList.append(warningInfo)
            
            TodoList.sharedInstance.addItem(todoItem)
            self._wariningCaches.removeAtIndex(0)
            self.WarningList = tempWarningList
        }
        
        self.Warningcouts = TodoList.sharedInstance.allItems().count
        if self.alarmcountdelegate != nil{
            self.alarmcountdelegate.GetAlarmCount(TodoList.sharedInstance.allItems().count)
        }
    }
    
    //获取原始报警数据warningcaches,通过bedcode过滤为需要的报警信息
    //检查是否已有alarmcode
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            var session = SessionForIphone.GetSession()!
            var bedusercodeList = session.BedUserCodeList!
            if bedusercodeList.count > 0 {
                for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                    for code in bedusercodeList {
                        if code == alarmList.alarmInfoList[i].UserCode{
                            if !self.IsCodeExist(alarmList.alarmInfoList[i].AlarmCode){
                                self._codes.append(alarmList.alarmInfoList[i].AlarmCode)
                                self._wariningCaches.append(alarmList.alarmInfoList[i])
                                break
                            }
                        }
                        
                    }
                }
            }
        }
    }//func
    
    func IsCodeExist(code:String)->Bool{
        if !self._codes.isEmpty{
            for cc in self._codes{
                if code == cc{
                    return true
                }
            }
        }
        return false
    }
    
}


//代理，跳转alarm信息页面
protocol ShowAlarmDelegate{
    func ShowAlarm()
}
////在imainframe页面中设置警告数
protocol GetAlarmCountDelegate{
    func GetAlarmCount(count:Int)
}
class WarningInfo{
    var AlarmCode:String = ""
    var UserName:String = ""
    var PartName:String = ""
    var BedNumber:String = ""
    var AlarmContent:String = ""
    var AlarmDate:String = ""
    init(alarmCode:String, userName:String, partName:String,bedNumber:String, alarmContent:String,alarmDate:String){
        self.AlarmCode = alarmCode
        self.AlarmContent = alarmContent
        self.UserName = userName
        self.BedNumber = bedNumber
        self.PartName = partName
        self.AlarmDate = alarmDate
        
    }
}
