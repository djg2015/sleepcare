//
//  IAlarmHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/17/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import Foundation

class IAlarmHelper:NSObject, WaringAttentionDelegate {
    
    private static var alarmInstance: IAlarmHelper? = nil
    private var IsOpen:Bool = false
    private var wariningCaches:Array<AlarmInfo>!
     //本地缓存的警报信息,Dictionary<alarmcode,alarmInfo>
   // private var alarmCaches:Dictionary<String,AlarmInfo>?
    var alarmdelegate:ShowAlarmDelegate!
    
    private override init(){
       
    }
    
    class func GetAlarmInstance()->IAlarmHelper{
        if self.alarmInstance == nil {
            self.alarmInstance = IAlarmHelper()
            //实时数据处理代理设置
            var xmppMsgManager = XmppMsgManager.GetInstance()
            xmppMsgManager?._waringAttentionDelegate = self.alarmInstance
            //开启警告信息
            self.alarmInstance!.wariningCaches = Array<AlarmInfo>()
            //    self.alarmCaches = Dictionary<String,AlarmInfo>()
                    }
        return self.alarmInstance!
    }
    
    //开始报警提醒
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWariningAction", name: "TodoListShouldRefresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        self.IsOpen = true
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
    
    //线程处理报警信息alarmcaches
    func alarmTimerFireMethod(timer: NSTimer) {
        if(self.wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self.wariningCaches[0] as AlarmInfo
            var session = SessionForIphone.GetSession()!
            var bedusercodeList = session.BedUserCodeList!
            if bedusercodeList.count > 0 {
                for code in bedusercodeList {
                    if code == alarmInfo.BedCode{
                        let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.UserName + alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
                        TodoList.sharedInstance.addItem(todoItem)
                        // self.WariningCount = TodoList.sharedInstance.allItems().count
                        break
                    }
                }//for
                  self.wariningCaches.removeAtIndex(0)
            }
        }
    }
    
    //获取原始报警数据warningcaches
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                self.wariningCaches.append(alarmList.alarmInfoList[i])
            }//for

        }
    }
}

//代理，跳转alarm信息页面
protocol ShowAlarmDelegate{
    func ShowAlarm()
}


