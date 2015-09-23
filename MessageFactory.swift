//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

let tag_realtimedata:String="<RealTimeData"
let tag_userinfo:String="<EBRealTimeSummary"
class MessageFactory {
    //xmpp字符串节点
    
    class func GetMessageModel(message:Message) -> BaseMessage {
        if(message.content.hasPrefix(tag_realtimedata)){
            return RealTimeReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_userinfo)){
            return UserInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else
        {
            return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
        }
    }
}
