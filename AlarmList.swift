//
//  AlarmList.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class AlarmList:BaseMessage {
    
    var alarmInfoList = Array<AlarmInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = AlarmList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var alarmInfos = doc.nodesForXPath("//AlarmInfo", error:nil) as! [DDXMLElement]
        for alarmInfo in alarmInfos {
            var newalarmInfo = AlarmInfo()
            newalarmInfo.AlarmCode = alarmInfo.elementForName("AlarmCode").stringValue()
            newalarmInfo.UserCode = alarmInfo.elementForName("UserCode").stringValue()
            newalarmInfo.UserName = alarmInfo.elementForName("UserName").stringValue()
            if(nil != alarmInfo.elementForName("UserSex"))
            {
                newalarmInfo.UserSex = alarmInfo.elementForName("UserSex").stringValue()
            }
            if(nil != alarmInfo.elementForName("PartCode"))
            {
                newalarmInfo.PartCode = alarmInfo.elementForName("PartCode").stringValue()
            }
            if(nil != alarmInfo.elementForName("PartName"))
            {
                newalarmInfo.PartName = alarmInfo.elementForName("PartName").stringValue()
            }
            if(nil != alarmInfo.elementForName("BedCode"))
            {
                newalarmInfo.BedCode = alarmInfo.elementForName("BedCode").stringValue()
            }
            if(nil != alarmInfo.elementForName("BedNumber"))
            {
                newalarmInfo.BedNumber = alarmInfo.elementForName("BedNumber").stringValue()
            }
            if(nil != alarmInfo.elementForName("HandleFlag"))
            {
                newalarmInfo.HandleFlag = alarmInfo.elementForName("HandleFlag").stringValue()
            }
           
            newalarmInfo.SchemaCode = alarmInfo.elementForName("SchemaCode").stringValue()
            newalarmInfo.SchemaContent = alarmInfo.elementForName("SchemaContent").stringValue()
            newalarmInfo.AlarmDate = alarmInfo.elementForName("AlarmDate").stringValue()
            newalarmInfo.AlarmTime = alarmInfo.elementForName("AlarmTime").stringValue()
            if(alarmInfo.elementForName("FoobLevelCode") != nil)
            {
                newalarmInfo.FoobLevelCode = alarmInfo.elementForName("FoobLevelCode").stringValue()
            }
            if(alarmInfo.elementForName("BedSoreLevelCode") != nil)
            {
                newalarmInfo.BedSoreLevelCode = alarmInfo.elementForName("BedSoreLevelCode").stringValue()
            }
            result.alarmInfoList.append(newalarmInfo)
        }
        return result
    }
    
}