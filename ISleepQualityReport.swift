//
//  ISleepQualityReport.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class ISleepQualityReport: BaseMessage {
    
    var SleepQuality:String = ""
    var OnBedTimespan:String = ""
    var DeepSleepTimespan:String = ""
    var LightSleepTimespan:String = ""
    var AwakeningTimespan:String = ""
    var sleepRange:Array<ISleepDateReport> = Array<ISleepDateReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = ISleepQualityReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var qualityReport = doc.rootElement() as DDXMLElement!
        result.SleepQuality = qualityReport.elementForName("SleepQuality") == nil ? "" : qualityReport.elementForName("SleepQuality").stringValue()
        result.OnBedTimespan = qualityReport.elementForName("OnBedTimespan") == nil ? "" : qualityReport.elementForName("OnBedTimespan").stringValue()
        result.DeepSleepTimespan = qualityReport.elementForName("DeepSleepTimespan") == nil ? "" : qualityReport.elementForName("DeepSleepTimespan").stringValue()
        result.LightSleepTimespan = qualityReport.elementForName("LightSleepTimespan") == nil ? "" : qualityReport.elementForName("LightSleepTimespan").stringValue()
        result.AwakeningTimespan = qualityReport.elementForName("AwakeningTimespan") == nil ? "" : qualityReport.elementForName("AwakeningTimespan").stringValue()
        
        var reportList = doc.nodesForXPath("//SleepDateReport", error:nil) as! [DDXMLElement]
        for report in reportList {
            var dateReport = ISleepDateReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            dateReport.ReportDate = report.elementForName("ReportDate").stringValue()
            dateReport.WeekDay = report.elementForName("WeekDay").stringValue()
            dateReport.OnBedTimespan = report.elementForName("OnBedTimespan").stringValue()
            dateReport.SleepTimespan = report.elementForName("SleepTimespan").stringValue()
            
            result.sleepRange.append(dateReport)
        }
        return result
    }
}

class ISleepDateReport:BaseMessage {
    
    var ReportDate:String = ""
    var WeekDay:String = ""
    var OnBedTimespan:String = ""
    var SleepTimespan:String = ""
}