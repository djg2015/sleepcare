//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

let tag_realtimedata:String="<RealTimeReport"
let tag_alarmList:String="<EPAlarmInfoList"
let tag_EMServiceException:String="<EMServiceException"
let tag_Result:String="<Result"
let tag_IP_loginUser:String="<LoginUser"
let tag_IP_serverResult:String="<ServerResult"
let tag_IP_bedUserList:String="<EPBedUserList"
let tag_IP_hrRange:String="<EPHRRange"
let tag_IP_rrRange:String="<EPRRRange"
let tag_IP_sleepQuality:String="<SleepQualityReport"
let tag_IP_mainInfoList:String="<EPMainInfoList"
let tag_IP_weekReport:String="<WeekSleep"
let tag_IP_mainInfo:String="<MainInfo"

class MessageFactory {
    //xmpp字符串节点
    
    class func GetMessageModel(message:Message) -> BaseMessage {
        if(message.content.hasPrefix(tag_realtimedata)){
            return RealTimeReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
               else if(message.content.hasPrefix(tag_EMServiceException))
        {
            return EMServiceException.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_alarmList)){
            return AlarmList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_loginUser))
        {
            return ILoginUser.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_Result))
        {
            return ServerResult.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_serverResult))
        {
            return ServerResult.XmlToMessage(message.subject, bodyXMl: message.content)
        }
       
        else if(message.content.hasPrefix(tag_IP_bedUserList))
        {
            return IBedUserList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_hrRange))
        {
            return HRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_rrRange))
        {
            return RRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_sleepQuality))
        {
            return SleepQualityReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_weekReport))
        {
            return WeekSleep.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        
        else if(message.content.hasPrefix(tag_IP_mainInfo))
        {
            return IMainInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else
        {
            throw("-1", "请求发生错误，请重试！")
        }
        return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
    }
}
