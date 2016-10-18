//
//  WeekSleep.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/23/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class WeekSleep: BaseMessage {
    
    var BeginDate:String = ""
    var EndDate:String = ""
    var WeekMaxRR:String = ""
    var WeekMinRR:String = ""
    var WeekAvgRR:String = ""
    var WeekMaxHR:String = ""
    var WeekMinHR:String = ""
    var WeekAvgHR:String = ""
    // 当前周心率呼吸报表
    var HRRRRange:Array<HRRRReport> = Array<HRRRReport>()
    var LeaveBedSum:String = ""
    //当前周离床报表
    var LeaveBedRange:Array<LeaveBedReport> = Array<LeaveBedReport>()
    var WeekWakeHours:String = ""
    var WeekLightSleepHours:String = ""
    var WeekDeepSleepHours:String = ""
    var WeekSleepHours:String = ""
    var OnbedBeginTime:String = ""
    var OnbedEndTime:String = ""
    //当前周睡眠报表
    var SleepRange:Array<SleepReport> = Array<SleepReport>()
    
    var AvgLeaveBedSum:String = ""
    var AvgTurnTimes:String = ""
    var MaxLeaveBedHours:String = ""
    var TurnsRate:String = ""
    var SleepSuggest:String = ""
    
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = WeekSleep(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var weekReport = doc.rootElement() as DDXMLElement!
        result.BeginDate = weekReport.elementForName("BeginDate").stringValue()
        result.EndDate = weekReport.elementForName("EndDate").stringValue()
        
        result.WeekMaxRR = weekReport.elementForName("WeekMaxRR") == nil ? "" : weekReport.elementForName("WeekMaxRR").stringValue()
        result.WeekMinRR = weekReport.elementForName("WeekMinRR") == nil ? "" : weekReport.elementForName("WeekMinRR").stringValue()
        result.WeekAvgRR = weekReport.elementForName("WeekAvgRR") == nil ? "" : weekReport.elementForName("WeekAvgRR").stringValue()
        result.WeekMaxHR = weekReport.elementForName("WeekMaxHR") == nil ? "" : weekReport.elementForName("WeekMaxHR").stringValue()
        result.WeekMinHR = weekReport.elementForName("WeekMinHR") == nil ? "" :  weekReport.elementForName("WeekMinHR").stringValue()
        result.WeekAvgHR = weekReport.elementForName("WeekAvgHR") == nil ? "" : weekReport.elementForName("WeekAvgHR").stringValue()
        
        var tempHRRRReportList = doc.nodesForXPath("//HRRRReport", error:nil) as! [DDXMLElement]
       
        for tempHRRR in tempHRRRReportList {
            var hrrrReport = HRRRReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            hrrrReport.ReportDate = tempHRRR.elementForName("ReportDate") == nil ? "" : tempHRRR.elementForName("ReportDate").stringValue()
            hrrrReport.WeekDay = tempHRRR.elementForName("WeekDay") == nil ? "" : tempHRRR.elementForName("WeekDay").stringValue()
            hrrrReport.HR = tempHRRR.elementForName("HR") == nil ? "" : tempHRRR.elementForName("HR").stringValue()
            hrrrReport.RR = tempHRRR.elementForName("RR") == nil ? "" : tempHRRR.elementForName("RR").stringValue()
            result.HRRRRange.append(hrrrReport)
        }
      
        
        result.LeaveBedSum = weekReport.elementForName("LeaveBedSum") == nil ? "" : weekReport.elementForName("LeaveBedSum").stringValue()
        
        var tempLeaveBedReportList = doc.nodesForXPath("//LeaveBedReport", error:nil) as! [DDXMLElement]
        for tempLeaveBed in tempLeaveBedReportList {
            var leavebedReport = LeaveBedReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            leavebedReport.ReportDate = tempLeaveBed.elementForName("ReportDate") == nil ? "" : tempLeaveBed.elementForName("ReportDate").stringValue()
            leavebedReport.WeekDay = tempLeaveBed.elementForName("WeekDay") == nil ? "" : tempLeaveBed.elementForName("WeekDay").stringValue()
            leavebedReport.LeaveBedTimes = tempLeaveBed.elementForName("LeaveBedTimes") == nil ? "" : tempLeaveBed.elementForName("LeaveBedTimes").stringValue()
            result.LeaveBedRange.append(leavebedReport)
        }
        
        result.WeekWakeHours = weekReport.elementForName("WeekWakeHours") == nil ? "" : weekReport.elementForName("WeekWakeHours").stringValue()
        result.WeekLightSleepHours = weekReport.elementForName("WeekLightSleepHours") == nil ? "" : weekReport.elementForName("WeekLightSleepHours").stringValue()
        result.WeekDeepSleepHours = weekReport.elementForName("WeekDeepSleepHours") == nil ? "" : weekReport.elementForName("WeekDeepSleepHours").stringValue()
        result.WeekSleepHours = weekReport.elementForName("WeekSleepHours") == nil ? "" : weekReport.elementForName("WeekSleepHours").stringValue()
        result.OnbedBeginTime = weekReport.elementForName("OnbedBeginTime") == nil ? "" : weekReport.elementForName("OnbedBeginTime").stringValue()
        result.OnbedEndTime = weekReport.elementForName("OnbedEndTime") == nil ? "" : weekReport.elementForName("OnbedEndTime").stringValue()
        
        
        
        var tempSleepReportList = doc.nodesForXPath("//SleepReport", error:nil) as! [DDXMLElement]
        for tempSleep in tempSleepReportList {
            var sleepReport = SleepReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            sleepReport.ReportDate = tempSleep.elementForName("ReportDate") == nil ? "" : tempSleep.elementForName("ReportDate").stringValue()
            sleepReport.WeekDay = tempSleep.elementForName("WeekDay") == nil ? "" : tempSleep.elementForName("WeekDay").stringValue()
            sleepReport.WakeHours = tempSleep.elementForName("WakeHours") == nil ? "" : tempSleep.elementForName("WakeHours").stringValue()
            sleepReport.DeepHours = tempSleep.elementForName("DeepHours") == nil ? "" : tempSleep.elementForName("DeepHours").stringValue()
            sleepReport.LightHours = tempSleep.elementForName("LightHours") == nil ? "" : tempSleep.elementForName("LightHours").stringValue()
            result.SleepRange.append(sleepReport)
        }
        
        result.AvgLeaveBedSum = weekReport.elementForName("AvgLeaveBedSum") == nil ? "" : weekReport.elementForName("AvgLeaveBedSum").stringValue()
        result.AvgTurnTimes = weekReport.elementForName("AvgTurnTimes") == nil ? "" : weekReport.elementForName("AvgTurnTimes").stringValue()
        result.MaxLeaveBedHours = weekReport.elementForName("MaxLeaveBedHours") == nil ? "" : weekReport.elementForName("MaxLeaveBedHours").stringValue()
        result.TurnsRate = weekReport.elementForName("TurnsRate") == nil ? "" : weekReport.elementForName("TurnsRate").stringValue()
        result.SleepSuggest = weekReport.elementForName("SleepSuggest") == nil ? "" : weekReport.elementForName("SleepSuggest").stringValue()
        
        return result
    }
}


// 体征明细
class HRRRReport:BaseMessage{
    var ReportDate:String = ""
    var WeekDay:String = ""
    var HR:String = ""
    var RR:String = ""
}



class LeaveBedReport: BaseMessage {
    var ReportDate:String = ""
    var WeekDay:String = ""
    var LeaveBedTimes:String = ""
}

class SleepReport: BaseMessage {
    var ReportDate:String = ""
    var WeekDay:String = ""
    var WakeHours:String = ""
    var DeepHours:String = ""
    var LightHours:String = ""
    
}


