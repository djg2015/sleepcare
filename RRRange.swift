//
//  RRRange.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/23/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class RRRange:BaseMessage{
    
    var rrTimeReportList:Array<RRTimeReport> = Array<RRTimeReport>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = RRRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var reportList = doc.nodesForXPath("//RRTimeReport", error:nil) as! [DDXMLElement]
        for report in reportList{
            var timeReport = RRTimeReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            var time:String = report.elementForName("ReportHour") == "" ? "" : report.elementForName("ReportHour").stringValue()
            if time != ""{
                if count(time) > 10{
                    timeReport.ReportHour = time.subString(11, length: 2) + "点"
                }
                else {
                    timeReport.ReportHour = time.subString(8, length: 2) 
                }
            }
            else{
                timeReport.ReportHour = ""
            }

            timeReport.AvgRR = report.elementForName("AvgRR").stringValue()
            
            result.rrTimeReportList.append(timeReport)
        }
        result.rrTimeReportList = result.rrTimeReportList.reverse()
        return result
    }
    
}

class RRTimeReport:BaseMessage {
    
    var ReportHour:String = ""
    var AvgRR:String = ""
//        {
//        didSet{
//            self.AvgRRNumber = CGFloat((self.AvgRR as NSString).floatValue)
//        }
//    }
    

    var AvgRRNumber:CGFloat = 0
}
