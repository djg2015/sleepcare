//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

let tag_realtimedata:String="<RealTimeReport"
let tag_userinfo:String="<User"
let tag_roleList:String="<EPRoleList"
let tag_partInfo:String="<PartInfo"
let tag_bedUser:String="<BedUser"
let tag_sleepCareReportList:String="<EPSleepCareReportList"
let tag_sleepCareReport:String="<SleepCareReport"
let tag_turnOverAnalysList:String="<EPTurnOverAnalysList"
let tag_alarmList:String="<EPAlarmInfoList"
let tag_bedReportList:String="<EPBedReportList"
let tag_EMServiceException:String="<EMServiceException"
let tag_Result:String="<Result"
let tag_IP_loginUser:String="<LoginUser"
let tag_IP_serverResult:String="<ServerResult"
let tag_IP_mainInfo:String="<MainInfo"
let tag_IP_bedUserList:String="<EPBedUserList"
let tag_IP_hrRange:String="<EPHRRange"
let tag_IP_rrRange:String="<EPRRRange"
let tag_IP_sleepQuality:String="<SleepQualityReport"
let tag_IP_equipmentInfo:String="<EquipmentInfo"
let tag_IP_mainInfoList:String="<EPMainInfoList"
let tag_IP_weekReport:String="<WeekReport"

class MessageFactory {
    //xmpp字符串节点
    
    class func GetMessageModel(message:Message) -> BaseMessage {
        if(message.content.hasPrefix(tag_realtimedata)){
            return RealTimeReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_userinfo)){
            return User.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_roleList)){
            return RoleList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_partInfo)){
            return PartInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_bedUser)){
            return BedUser.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_sleepCareReportList)){
            return SleepCareReportList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_sleepCareReport)){
            return SleepCareReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_turnOverAnalysList)){
            return TurnOverAnalysList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_alarmList)){
            return AlarmList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_bedReportList)){
            return LeaveBedReportList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_EMServiceException))
        {
            return EMServiceException.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_Result))
        {
            return ServerResult.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_loginUser))
        {
            return ILoginUser.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_serverResult))
        {
            return ServerResult.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_mainInfo))
        {
            return IMainInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_bedUserList))
        {
            return IBedUserList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_hrRange))
        {
            return IHRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_rrRange))
        {
            return IRRRange.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_sleepQuality))
        {
            return ISleepQualityReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_weekReport))
        {
            return IWeekReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_equipmentInfo))
        {
            return IEquipmentInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_IP_mainInfoList))
        {
            return IMainInfoList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else
        {
            throw("-1", "请求发生错误，请重试！")
        }
        return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
    }
}
