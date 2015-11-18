//
//  IHRRange.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IHRRange:BaseMessage{
    
    var hrTimeReportList:Array<IHRTimeReport> = Array<IHRTimeReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IHRRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var reportList = doc.nodesForXPath("//HRTimeReport", error:nil) as! [DDXMLElement]
        for report in reportList {
            var timeReport = IHRTimeReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            timeReport.ReportHour = report.elementForName("ReportHour").stringValue()
            timeReport.AvgHR = report.elementForName("AvgHR").stringValue()
            
            result.hrTimeReportList.append(timeReport)
        }
        return result
    }
    
}

class IHRTimeReport:BaseMessage {
    
    var ReportHour:String = ""
    var AvgHR:String = "" {
        didSet{
            self.AvgHRNumber = CGFloat((self.AvgHR.subString(0, length: 2) as NSString).floatValue)
        }
    }
    
    // 在床时长
    var AvgHRNumber:CGFloat = 0
}
