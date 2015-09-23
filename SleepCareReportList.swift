//
//  SleepCareReportList.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class SleepCareReportList:BaseMessage{
    var sleepCareReportList = Array<SleepCareReport>()
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
         let a:Int = 1
        let result = SleepCareReportList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var sleepCareReports = doc.nodesForXPath("//SleepCareReport", error:nil) as! [DDXMLElement]
        for sleepCare in sleepCareReports {
            var sc = SleepCareReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            sc.ReportDate = sleepCare.elementForName("ReportDate").stringValue()
            sc.BedCode = sleepCare.elementForName("BedCode").stringValue()
            sc.BedNumber = sleepCare.elementForName("BedNumber").stringValue()
            sc.UserCode = sleepCare.elementForName("UserCode").stringValue()
            sc.UserName = sleepCare.elementForName("UserName").stringValue()
            sc.AVGHR = sleepCare.elementForName("AVGHR").stringValue()
            sc.AVGRR = sleepCare.elementForName("AVGRR").stringValue()
            sc.TurnOverTime = sleepCare.elementForName("TurnOverTime").stringValue()
            sc.LightSleepTimeSpan = sleepCare.elementForName("LightSleepTimeSpan").stringValue()
            sc.DeepSleepTimeSpan = sleepCare.elementForName("DeepSleepTimeSpan").stringValue()
            sc.OnBedTimeSpan = sleepCare.elementForName("OnBedTimeSpan").stringValue()
            sc.AnalysisDateSection = sleepCare.elementForName("AnalysisDateSection").stringValue()
            sc.SleepQuality = sleepCare.elementForName("SleepQuality").stringValue()
            result.sleepCareReportList.append(sc)
        }
        return result
    }

}