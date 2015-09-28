//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

let tag_realtimedata:String="<RealTimeData"
let tag_userinfo:String="<User"
let tag_roleList:String="<EPRoleList"
let tag_partInfo:String="<PartInfo"
let tag_bedUser:String="<BedUser"
let tag_sleepCareReportList:String="<EPSleepCareReportList"
let tag_sleepCareReport:String="<SleepCareReport"
let tag_turnOverAnalysList:String="<EPTurnOverAnalysList"
let tag_alarmList:String="<AlarmList"
let tag_EMServiceException:String="<EMServiceException"
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
        else if(message.content.hasPrefix(tag_EMServiceException))
        {
            return EMServiceException.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
    }
}
