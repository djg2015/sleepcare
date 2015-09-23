//
//  TurnOverAnalysList.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class TurnOverAnalysList:BaseMessage{
    var turnOverAnalysReportList = Array<TurnOverAnalysReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{        
        
        let result = TurnOverAnalysList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var sleepCareReports = doc.nodesForXPath("//TurnOverAnalysReport", error:nil) as! [DDXMLElement]
        for sleepCare in sleepCareReports {
            var turnOverAnalysReport = TurnOverAnalysReport()
            turnOverAnalysReport.ReportDate = sleepCare.elementForName("ReportDate").stringValue()
            turnOverAnalysReport.BedCode = sleepCare.elementForName("BedCode").stringValue()
            turnOverAnalysReport.BedNumber = sleepCare.elementForName("BedNumber").stringValue()
            turnOverAnalysReport.UserCode = sleepCare.elementForName("UserCode").stringValue()
            turnOverAnalysReport.UserName = sleepCare.elementForName("UserName").stringValue()
            turnOverAnalysReport.TurnOverTime = sleepCare.elementForName("TurnOverTime").stringValue()
            turnOverAnalysReport.TurnOverRate = sleepCare.elementForName("TurnOverRate").stringValue()
            turnOverAnalysReport.AvgMV = sleepCare.elementForName("AvgMV").stringValue()
            result.turnOverAnalysReportList.append(turnOverAnalysReport)
        }
        return result
    }
    
}