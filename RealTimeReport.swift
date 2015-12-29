//
//  RealTimeReport.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class RealTimeReport:BaseMessage{
    //定义实时数据字段
    var BedCode:String = ""
    var BedNumber:String = ""
    var UserCode:String = ""
    var UserName:String = ""
    var CaseCode:String = ""
    var HR:String = ""
    var RR:String = ""
    var BodyTemperature:String = ""
    var OnBedStatus:String = ""
    var MsgTime:String = ""
    var LastedLeaveTime:String = ""
     var LastedAvgHR:String = ""
     var LastedAvgRR:String = ""
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = RealTimeReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var realTimeReports = doc.nodesForXPath("//RealTimeReport", error:nil) as! [DDXMLElement]
        for realTimeReport in realTimeReports {
            result.BedCode = realTimeReport.elementForName("BedCode").stringValue()
            result.BedNumber = realTimeReport.elementForName("BedNumber").stringValue()
            result.UserCode = realTimeReport.elementForName("UserCode").stringValue()
            result.UserName = realTimeReport.elementForName("UserName").stringValue()
            if(realTimeReport.elementForName("CaseCode") != nil){
                result.CaseCode = realTimeReport.elementForName("CaseCode").stringValue()
            }
            result.HR = realTimeReport.elementForName("HR").stringValue()
            result.RR = realTimeReport.elementForName("RR").stringValue()
            result.BodyTemperature = realTimeReport.elementForName("BodyTemperature") != nil ?realTimeReport.elementForName("BodyTemperature").stringValue() : ""
            if realTimeReport.elementForName("OnBedStatus") != nil{
            result.OnBedStatus = realTimeReport.elementForName("OnBedStatus").stringValue()
            }
            result.MsgTime = realTimeReport.elementForName("MsgTime").stringValue()
            result.LastedLeaveTime = realTimeReport.elementForName("LastedLeaveTime") != nil ?realTimeReport.elementForName("LastedLeaveTime").stringValue() : ""
            result.LastedAvgHR = realTimeReport.elementForName("LastedAvgHR") != nil ?realTimeReport.elementForName("LastedAvgHR").stringValue() : ""
            result.LastedAvgRR = realTimeReport.elementForName("LastedAvgRR") != nil ?realTimeReport.elementForName("LastedAvgRR").stringValue() : ""
        }
        
        return result
    }
}