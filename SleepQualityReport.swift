//
//  SleepQualityReport.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/23/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation


class SleepQualityReport: BaseMessage {
    
    var SleepQuality:String = ""
    var BedTimespan:String = ""
    var DeepSleepTimespan:String = ""
    var LightSleepTimespan:String = ""
    var AwakeningTimespan:String = ""
    var sleepRange:Array<SleepDateReport> = Array<SleepDateReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = SleepQualityReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var qualityReport = doc.rootElement() as DDXMLElement!
        result.SleepQuality = qualityReport.elementForName("SleepQuality") == nil ? "" : qualityReport.elementForName("SleepQuality").stringValue()
        result.BedTimespan = qualityReport.elementForName("BedTimespan") == nil ? "" : qualityReport.elementForName("BedTimespan").stringValue()
        result.DeepSleepTimespan = qualityReport.elementForName("DeepSleepTimespan") == nil ? "" : qualityReport.elementForName("DeepSleepTimespan").stringValue()
        result.LightSleepTimespan = qualityReport.elementForName("LightSleepTimespan") == nil ? "" : qualityReport.elementForName("LightSleepTimespan").stringValue()
        result.AwakeningTimespan = qualityReport.elementForName("AwakeningTimespan") == nil ? "" : qualityReport.elementForName("AwakeningTimespan").stringValue()
        
        var reportList = doc.nodesForXPath("//SleepDateReport", error:nil) as! [DDXMLElement]
        for report in reportList {
            var dateReport = SleepDateReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            dateReport.ReportDate = report.elementForName("ReportDate").stringValue()
            dateReport.WeekDay = report.elementForName("WeekDay").stringValue()
            dateReport.SleepTimespan = report.elementForName("SleepTimespan").stringValue()
            
            result.sleepRange.append(dateReport)
        }
        return result
    }
}

class SleepDateReport:BaseMessage {
    
    var ReportDate:String = ""
    var WeekDay:String = ""
    //睡眠时长
    var SleepTimespan:String = ""{
        didSet{
            var hours:CGFloat = CGFloat((self.SleepTimespan.subString(0, length: 2) as NSString).floatValue)
            var minutes:CGFloat = CGFloat((self.SleepTimespan.subString(3, length: 2) as NSString).floatValue)
            self.SleepTimespanHours = hours + minutes/60
        }
    }
    
    var SleepTimespanHours:CGFloat=0
   
}