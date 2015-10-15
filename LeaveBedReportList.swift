//
//  LeaveBedReportList.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/14.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class LeaveBedReportList:BaseMessage
{
    var reportList = Array<LeaveBedReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = LeaveBedReportList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var leaveBedReports = doc.nodesForXPath("//BedReport", error:nil) as! [DDXMLElement]
        for report in leaveBedReports {
            var newReport = LeaveBedReport()
            newReport.BedCode = report.elementForName("BedCode").stringValue()
            newReport.UserCode = report.elementForName("UserCode").stringValue()
            newReport.PartCode = report.elementForName("PartCode").stringValue()
            if(report.elementForName("CaseCode") != nil)
            {
                newReport.CaseCode = report.elementForName("CaseCode").stringValue()
            }
            newReport.BedNumber = report.elementForName("BedNumber").stringValue()
            newReport.UserName = report.elementForName("UserName").stringValue()
            newReport.StartTime = report.elementForName("StartTime").stringValue()
            newReport.EndTime = report.elementForName("EndTime").stringValue()
            newReport.LeaveBedTimespan = report.elementForName("LeaveBedTimespan").stringValue()
            result.reportList.append(newReport)
        }
        return result
    }
}