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
            if(sleepCare.elementForName("ReportDate") != nil)
            {
                turnOverAnalysReport.ReportDate = sleepCare.elementForName("ReportDate").stringValue()
            }
            if(sleepCare.elementForName("BedCode") != nil)
            {
                turnOverAnalysReport.BedCode = sleepCare.elementForName("BedCode").stringValue()
            }
            if(sleepCare.elementForName("BedNumber") != nil)
            {
                turnOverAnalysReport.BedNumber = sleepCare.elementForName("BedNumber").stringValue()
            }
            if(sleepCare.elementForName("UserCode") != nil)
            {
                turnOverAnalysReport.UserCode = sleepCare.elementForName("UserCode").stringValue()
            }
            if(sleepCare.elementForName("UserName") != nil)
            {
                turnOverAnalysReport.UserName = sleepCare.elementForName("UserName").stringValue()
            }
            if(sleepCare.elementForName("TurnOverTime") != nil)
            {
                turnOverAnalysReport.TurnOverTime = sleepCare.elementForName("TurnOverTime").stringValue()
            }
            if(sleepCare.elementForName("TurnOverRate") != nil)
            {
                turnOverAnalysReport.TurnOverRate = sleepCare.elementForName("TurnOverRate").stringValue()
            }
            if(sleepCare.elementForName("AvgMV") != nil)
            {
                turnOverAnalysReport.AvgMV = sleepCare.elementForName("AvgMV").stringValue()
            }
            result.turnOverAnalysReportList.append(turnOverAnalysReport)
        }
        return result
    }
    
}