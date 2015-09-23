//
//  SleepCareReport.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class SleepCareReport:BaseMessage{
    var ReportDate:String = ""
    var BedCode:String = ""
    var BedNumber:String = ""
    var UserCode:String = ""
    var UserName:String = ""
    var AVGHR:String = ""
    var AVGRR:String = ""
    var TurnOverTime:String = ""
    var LightSleepTimeSpan:String = ""
    var DeepSleepTimeSpan:String = ""
    var OnBedTimeSpan:String = ""
    var AnalysisDateSection:String = ""
    var SleepQuality:String = ""
    var LeaveBedCount:String = ""
    var MaxLeaveTimeSpan:String = ""
    var LeaveBedSuggest:String = ""
    var SignReports = Array<SignReport>()
    
    override init(messageSubject: MessageSubject) {
        super.init(messageSubject: messageSubject)
    }
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = SleepCareReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var sleepCareReports = doc.nodesForXPath("//SleepCareReport", error:nil) as! [DDXMLElement]
        for sleepCareReport in sleepCareReports {
            result.ReportDate = sleepCareReport.elementForName("ReportDate").stringValue()
            result.UserCode = sleepCareReport.elementForName("UserCode").stringValue()
            result.UserName = sleepCareReport.elementForName("UserName").stringValue()
            result.AVGHR = sleepCareReport.elementForName("AVGHR").stringValue()
            result.AVGRR = sleepCareReport.elementForName("AVGRR").stringValue()
            result.TurnOverTime = sleepCareReport.elementForName("TurnOverTime").stringValue()
            result.LightSleepTimeSpan = sleepCareReport.elementForName("LightSleepTimeSpan").stringValue()
            result.OnBedTimeSpan = sleepCareReport.elementForName("OnBedTimeSpan").stringValue()
            result.DeepSleepTimeSpan = sleepCareReport.elementForName("DeepSleepTimeSpan").stringValue()
            result.LeaveBedCount = sleepCareReport.elementForName("LeaveBedCount").stringValue()
            result.MaxLeaveTimeSpan = sleepCareReport.elementForName("MaxLeaveTimeSpan").stringValue()
            result.LeaveBedSuggest = sleepCareReport.elementForName("LeaveBedSuggest").stringValue()
            result.AnalysisDateSection = sleepCareReport.elementForName("AnalysisDateSection").stringValue()

            
            //获取按小时体征节点的子节点
            let signReportList = sleepCareReport.nodesForXPath("//SignReport", error:nil) as! [DDXMLElement]
            for sign in signReportList {
                var newSignReport = SignReport()
                newSignReport.ReportHour = sign.elementForName("ReportHour").stringValue()
                newSignReport.BedCode = sign.elementForName("BedCode").stringValue()
                newSignReport.BedNumber = sign.elementForName("BedNumber").stringValue()
                newSignReport.PartCode = sign.elementForName("PartCode").stringValue()
                newSignReport.UserCode = sign.elementForName("UserCode").stringValue()
                newSignReport.UserName = sign.elementForName("UserName").stringValue()
                newSignReport.CaseCode = sign.elementForName("CaseCode").stringValue()
                newSignReport.AVGHR = sign.elementForName("AVGHR").stringValue()
                newSignReport.AVGRR = sign.elementForName("AVGRR").stringValue()
                newSignReport.AVGTemperature = sign.elementForName("AVGTemperature").stringValue()
                newSignReport.TurnOverTime = sign.elementForName("TurnOverTime").stringValue()
                newSignReport.AVGMV = sign.elementForName("AVGMV").stringValue()
                newSignReport.AnalysisDateSection = sign.elementForName("AnalysisDateSection").stringValue()
                result.SignReports.append(newSignReport)
            }

        }
        return result
    }
    
}