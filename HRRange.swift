//
//  HRRange.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/22/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation


class HRRange:BaseMessage{
    
    var hrTimeReportList:Array<HRTimeReport> = Array<HRTimeReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = HRRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var reportList = doc.nodesForXPath("//HRTimeReport", error:nil) as! [DDXMLElement]
        for report in reportList{
            var timeReport = HRTimeReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            var time:String = report.elementForName("ReportHour") == "" ? "" : report.elementForName("ReportHour").stringValue()
            if time != ""{
            if count(time) > 10{
            timeReport.ReportHour = time.subString(11, length: 2) + "点"
            }
            else {
            timeReport.ReportHour = time.subString(8, length: 2) + "号"
            }
            }
            else{
            timeReport.ReportHour = ""
            }
                     
            timeReport.AvgHR = report.elementForName("AvgHR").stringValue()
            
            result.hrTimeReportList.append(timeReport)
        }
        result.hrTimeReportList = result.hrTimeReportList.reverse()
        return result
    }
    
}

class HRTimeReport:BaseMessage {
    
    var ReportHour:String = ""
    var AvgHR:String = ""
//        {
//        didSet{
//            self.AvgHRNumber = CGFloat((self.AvgHR as NSString).floatValue)
//        }
//    }
//    
    // 在床时长
    var AvgHRNumber:CGFloat = 0
}
