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
    var sleepRange:Array<ISleepDateReport> = Array<ISleepDateReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = ISleepQualityReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var reportList = doc.nodesForXPath("//SleepDateReport", error:nil) as! [DDXMLElement]
        for report in reportList {
            var dateReport = ISleepDateReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            dateReport.ReportDate = report.elementForName("ReportDate").stringValue()
            dateReport.DeepSleepTimespan = report.elementForName("DeepSleepTimespan").stringValue()
            dateReport.LightSleepTimespan = report.elementForName("LightSleepTimespan").stringValue()
            
            result.sleepRange.append(dateReport)
        }
        return result
    }
}

class ISleepDateReport:BaseMessage {
    
    var ReportDate:String = ""
    var DeepSleepTimespan:String = ""
    var LightSleepTimespan:String = ""
}