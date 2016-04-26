//
//  SleepCareBussiness.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class SleepCareBussiness: SleepCareBussinessManager {
   
    func GetAlarmByUser(partCode:String,userCode:String,userNameLike:String,bedNumberLike:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String, from:Int32?,max:Int32?)-> AlarmList
    {
        var subject = MessageSubject(opera: "GetAlarmByUser")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("partCode", value: partCode)
        post.AddKeyValue("userCode", value: userCode)
        post.AddKeyValue("userNameLike", value: userNameLike)
        post.AddKeyValue("bedNumberLike", value: bedNumberLike)
        post.AddKeyValue("schemaCode", value: schemaCode)
        post.AddKeyValue("alarmTimeBegin", value: alarmTimeBegin)
        post.AddKeyValue("alarmTimeEnd", value: alarmTimeEnd)
        if(from != nil)
        {
            post.AddKeyValue("from", value: String(from!))
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: String(max!))
        }
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! AlarmList
    }
    
      
    // 处理报警信息
    // 参数：alarmCode-> 报警编号
    //      transferType-> 处理类型 002:处理 003:误警报
    func HandleAlarm(alarmCode:String,transferType:String)->ServerResult
    {
        var subject = MessageSubject(opera: "TransferAlarmMessage")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("alarmCode", value: alarmCode)
        post.AddKeyValue("transferType", value: transferType)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    //根据当前登录用户、报警类型、报警时间段、报警处理状态等多条件获取关注老人的报警信息
    //   mainCode 医院/养老院编号
    //   loginName 登录账户
    //   schemaCode 报警类型
    //   alarmTimeBegin 报警时间起始时间 //年-月-日 格式
    //   alarmTimeEnd 报警时间结束时间//年-月-日 格式
    //   transferTypeCode 报警处理类型
    //   from 开始记录序号(nil表示查询全部)
    //   max  返回最大记录数量(nil表示查询全部)
    func GetAlarmByLoginUser(mainCode:String,loginName:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String,transferTypeCode:String,from:String?,max:String?)-> AlarmList{
        
        var subject = MessageSubject(opera: "GetAlarmByLoginUser")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("mainCode", value:mainCode )
        post.AddKeyValue("loginName", value:loginName )
        post.AddKeyValue("schemaCode", value:schemaCode )
        post.AddKeyValue("alarmTimeBegin", value: alarmTimeBegin)
        post.AddKeyValue("alarmTimeEnd", value: alarmTimeEnd)
        post.AddKeyValue("transferTypeCode", value:transferTypeCode )
        if(from != nil)
        {
            post.AddKeyValue("from", value: from!)
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: max!)
        }
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
            
        }
        return message as! AlarmList
    }
    
    //删除报警信息（已读）
    //alarmCodes 报警编号(多个以半角逗号隔开)
    //loginName 登录用户名
    func DeleteAlarmMessage(alarmCodes:String,loginName:String)->ServerResult{
    
        var subject = MessageSubject(opera: "DeleteAlarmMessage")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("alarmCodes", value: alarmCodes)
        post.AddKeyValue("loginName", value: loginName)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }


}