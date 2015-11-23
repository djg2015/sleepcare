//
//  IRRRange.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IRRRange:BaseMessage{
    
    var rrTimeReportList:Array<IRRTimeReport> = Array<IRRTimeReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IRRRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var reportList = doc.nodesForXPath("//RRTimeReport", error:nil) as! [DDXMLElement]
        for report in reportList {
            var timeReport = IRRTimeReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            timeReport.ReportHour = report.elementForName("ReportHour").stringValue().subString(11, length:2)
            timeReport.AvgRR = report.elementForName("AvgRR").stringValue()
            
            result.rrTimeReportList.append(timeReport)
        }
        result.rrTimeReportList = result.rrTimeReportList.reverse()
        return result
    }
    
}

class IRRTimeReport:BaseMessage {
    
    var ReportHour:String = ""
    var AvgRR:String = "" {
        didSet{
            self.AvgRRNumber = CGFloat((self.AvgRR as NSString).floatValue)
        }
    }
    
    // 在床时长
    var AvgRRNumber:CGFloat = 0
    
}