//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

//singleiphone
let tag_realtimedata:String="<RealTimeReport"
let tag_single_loginUser:String="<LoginUser"
let tag_single_serverResult:String="<ServerResult"
let tag_single_bedUserInfo:String="<BedUserInfo"
let tag_single_equipmentList:String="<EPEquipmentInfoList"
let tag_single_hrRange:String="<EPHRRange"
let tag_single_rrRange:String="<EPRRRange"
let tag_single_sleepQualityReport:String="<SleepQualityReport"
let tag_single_weekSleep:String="<WeekSleep"
let tag_single_alarmList:String="<EPAlarmInfoList"
//异常编码如下：0：表示业务异常 -1：一般错误
let tag_EMServiceException:String="<EMServiceException"


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
        else if(message.content.hasPrefix(tag_single_alarmList)){
            return AlarmList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_loginUser))
        {
            return LoginUser.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_serverResult))
        {
            return ServerResult.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_bedUserInfo))
        {
            return BedUserInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_equipmentList))
        {
            return EquipmentList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_hrRange))
        {
            return HRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_rrRange))
        {
            return RRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_sleepQualityReport))
        {
            return SleepQualityReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_single_weekSleep))
        {
            return WeekSleep.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else
        {
            print(message.content)
            throw("-1", "请求发生错误，请重试！")
        }
        return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
    }
}
