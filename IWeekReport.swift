//
//  IWeekReport.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/26.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IWeekReport: BaseMessage {
    
    var WeekBeginDate:String = ""
    var WeekEndDate:String = ""
    var BedUserCode:String = ""
    var BedUserName:String = ""
    var BedCode:String = ""
    var BedNumber:String = ""
    
    var SignWeekReport:ISignWeekReport?
    var LeaveBedWeekReport:ILeaveBedWeekReport?
    var SleepWeekReport:ISleepWeekReport?
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IWeekReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var weekReport = doc.rootElement() as DDXMLElement!
        result.WeekBeginDate = weekReport.elementForName("WeekBeginDate").stringValue()
        result.WeekEndDate = weekReport.elementForName("WeekEndDate").stringValue()
        result.BedUserCode = weekReport.elementForName("BedUserCode").stringValue()
        result.BedUserName = weekReport.elementForName("BedUserName").stringValue()
        result.BedCode = weekReport.elementForName("BedCode") == nil ? "" : weekReport.elementForName("BedCode").stringValue()
        result.BedNumber = weekReport.elementForName("BedNumber") == nil ? "" : weekReport.elementForName("BedNumber").stringValue()
        
        // 获取生命体征报表
        var tempSignWeekReport:ISignWeekReport = ISignWeekReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        var signWeekReport = weekReport.elementForName("SignWeekReport") as DDXMLElement!
        var tempSignRangeList = Array<ISignRange>()
        if(nil != signWeekReport)
        {
            tempSignWeekReport.WeekMaxHR = signWeekReport.elementForName("WeekMaxHR") == nil ? "" : signWeekReport.elementForName("WeekMaxHR").stringValue()
            tempSignWeekReport.WeekMaxRR = signWeekReport.elementForName("WeekMaxRR") == nil ? "" : signWeekReport.elementForName("WeekMaxRR").stringValue()
            tempSignWeekReport.WeekMimHR = signWeekReport.elementForName("WeekMimHR") == nil ? "" : signWeekReport.elementForName("WeekMimHR").stringValue()
            tempSignWeekReport.WeekMimRR = signWeekReport.elementForName("WeekMimRR") == nil ? "" : signWeekReport.elementForName("WeekMimRR").stringValue()
            tempSignWeekReport.WeekAvgHR = signWeekReport.elementForName("WeekAvgHR") == nil ? "" : signWeekReport.elementForName("WeekAvgHR").stringValue()
            tempSignWeekReport.WeekAvgRR = signWeekReport.elementForName("WeekAvgRR") == nil ? "" : signWeekReport.elementForName("WeekAvgRR").stringValue()
            
            var signRange = signWeekReport.elementForName("SignRange").elementsForName("Range")
            for range in signRange{
                
                var tempRange = ISignRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
                tempRange.ReportDate = range.elementForName("ReportDate") == nil ? "" : range.elementForName("ReportDate").stringValue()
                tempRange.Weekday = range.elementForName("Weekday") == nil ? "" : range.elementForName("Weekday").stringValue()
                tempRange.AvgHR = range.elementForName("AvgHR") == nil ? "" : range.elementForName("AvgHR").stringValue()
                tempRange.AvgRR = range.elementForName("AvgRR") == nil ? "" : range.elementForName("AvgRR").stringValue()
                
                tempSignRangeList.append(tempRange)
            }
        }
        tempSignWeekReport.SignRangeList = tempSignRangeList
        result.SignWeekReport = tempSignWeekReport
        
        // 获取在离床报表
        var tempLeaveBedWeekReport:ILeaveBedWeekReport = ILeaveBedWeekReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        var leaveBedWeekReport = weekReport.elementForName("LeaveBedWeekReport") as DDXMLElement!
        var tempLeaveBedRangeList = Array<ILeaveBedRange>()
        if(nil != leaveBedWeekReport)
        {
            tempLeaveBedWeekReport.MaxWeekday = leaveBedWeekReport.elementForName("MaxWeekday") == nil ? "" : leaveBedWeekReport.elementForName("MaxWeekday").stringValue()
            var leaveBedRange = leaveBedWeekReport.elementForName("LeaveBedRange").elementsForName("Range")
            for range in leaveBedRange{
                
                var tempRange = ILeaveBedRange(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
                tempRange.ReportDate = range.elementForName("ReportDate") == nil ? "" : range.elementForName("ReportDate").stringValue()
                tempRange.Weekday = range.elementForName("Weekday") == nil ? "" : range.elementForName("Weekday").stringValue()
                tempRange.LeaveBedCount = range.elementForName("LeaveBedCount") == nil ? "" : range.elementForName("LeaveBedCount").stringValue()
                
                tempLeaveBedRangeList.append(tempRange)
            }
        }
        tempLeaveBedWeekReport.LeaveBedRangeList = tempLeaveBedRangeList
        result.LeaveBedWeekReport = tempLeaveBedWeekReport
        
        // 获取睡眠质量报表
        var tempSleepWeekReport:ISleepWeekReport = ISleepWeekReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        var sleepWeekReport = weekReport.elementForName("SleepWeekReport") as DDXMLElement!
        var tempSleepRangeList = Array<ISleepWeekReport>()
        if(nil != sleepWeekReport)
        {
            tempSleepWeekReport.ReportDate = sleepWeekReport.elementForName("ReportDate") == nil ? "" : sleepWeekReport.elementForName("ReportDate").stringValue()
            tempSleepWeekReport.Weekday = sleepWeekReport.elementForName("Weekday") == nil ? "" : sleepWeekReport.elementForName("Weekday").stringValue()
            tempSleepWeekReport.OnBedTimespan = sleepWeekReport.elementForName("OnBedTimespan") == nil ? "" : sleepWeekReport.elementForName("OnBedTimespan").stringValue()
            tempSleepWeekReport.SleepTimespan = sleepWeekReport.elementForName("SleepTimespan") == nil ? "" : sleepWeekReport.elementForName("SleepTimespan").stringValue()
            tempSleepWeekReport.AwakeningTimespan = sleepWeekReport.elementForName("AwakeningTimespan") == nil ? "" : sleepWeekReport.elementForName("AwakeningTimespan").stringValue()
            tempSleepWeekReport.DeepSleepTimespan = sleepWeekReport.elementForName("DeepSleepTimespan") == nil ? "" : sleepWeekReport.elementForName("DeepSleepTimespan").stringValue()
            tempSleepWeekReport.LightSleepTimespan = sleepWeekReport.elementForName("LightSleepTimespan") == nil ? "" : sleepWeekReport.elementForName("LightSleepTimespan").stringValue()
            tempSleepWeekReport.SleepBeginTime = sleepWeekReport.elementForName("SleepBeginTime") == nil ? "" : sleepWeekReport.elementForName("SleepBeginTime").stringValue()
            tempSleepWeekReport.SleepEndTime = sleepWeekReport.elementForName("SleepEndTime") == nil ? "" : sleepWeekReport.elementForName("SleepEndTime").stringValue()
            
            var tempSuggest = ISleepSuggest()
            var sleepSuggest = sleepWeekReport.elementForName("SleepSuggest")
            if(nil != sleepSuggest)
            {
                tempSuggest.LeaveBedCount = sleepSuggest.elementForName("LeaveBedCount") == nil ? "" : sleepSuggest.elementForName("LeaveBedCount").stringValue()
                tempSuggest.MaxLeaveBedTimespan = sleepSuggest.elementForName("MaxLeaveBedTimespan") == nil ? "" : sleepSuggest.elementForName("MaxLeaveBedTimespan").stringValue()
                tempSuggest.TurnOverCount = sleepSuggest.elementForName("TurnOverCount") == nil ? "" : sleepSuggest.elementForName("TurnOverCount").stringValue()
                tempSuggest.TurnOverRate = sleepSuggest.elementForName("TurnOverRate") == nil ? "" : sleepSuggest.elementForName("TurnOverRate").stringValue()
                tempSuggest.Suggest = sleepSuggest.elementForName("Suggest") == nil ? "" : sleepSuggest.elementForName("Suggest").stringValue()
            }
            tempSleepWeekReport.Suggest = tempSuggest
            
            var sleepRange = sleepWeekReport.elementForName("SleepRange").elementsForName("Range")
            for range in sleepRange{
                
                var tempRange = ISleepWeekReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
                tempRange.ReportDate = range.elementForName("ReportDate").stringValue()
                tempRange.Weekday = range.elementForName("Weekday").stringValue()
                tempRange.OnBedTimespan = range.elementForName("OnBedTimespan") == nil ? "": range.elementForName("OnBedTimespan").stringValue()
                tempRange.SleepTimespan = range.elementForName("SleepTimespan") == nil ? "" : range.elementForName("SleepTimespan").stringValue()
                tempRange.AwakeningTimespan = range.elementForName("AwakeningTimespan") == nil ? "" : range.elementForName("AwakeningTimespan").stringValue()
                tempRange.DeepSleepTimespan = range.elementForName("DeepSleepTimespan") == nil ? "" : range.elementForName("DeepSleepTimespan").stringValue()
                tempRange.LightSleepTimespan = range.elementForName("LightSleepTimespan") == nil ? "" : range.elementForName("LightSleepTimespan").stringValue()
                tempRange.SleepBeginTime = range.elementForName("SleepBeginTime") == nil ? "" : range.elementForName("SleepBeginTime").stringValue()
                tempRange.SleepEndTime = range.elementForName("SleepEndTime") == nil ? "" : range.elementForName("SleepEndTime").stringValue()
                
                var tempSuggest = ISleepSuggest()
                var sleepSuggest = range.elementForName("SleepSuggest")
                if(nil != sleepSuggest)
                {
                    tempSuggest.LeaveBedCount = sleepSuggest.elementForName("LeaveBedCount") == nil ? "" : sleepSuggest.elementForName("LeaveBedCount").stringValue()
                    tempSuggest.MaxLeaveBedTimespan = sleepSuggest.elementForName("MaxLeaveBedTimespan") == nil ? "" : sleepSuggest.elementForName("MaxLeaveBedTimespan").stringValue()
                    tempSuggest.TurnOverCount = sleepSuggest.elementForName("TurnOverCount") == nil ? "" : sleepSuggest.elementForName("TurnOverCount").stringValue()
                    tempSuggest.TurnOverRate = sleepSuggest.elementForName("TurnOverRate") == nil ? "" : sleepSuggest.elementForName("TurnOverRate").stringValue()
                    tempSuggest.Suggest = sleepSuggest.elementForName("Suggest") == nil ? "" : sleepSuggest.elementForName("Suggest").stringValue()
                }
                tempRange.Suggest = tempSuggest
                
                tempSleepRangeList.append(tempRange)
            }
        }
        tempSleepWeekReport.SleepRangeList = tempSleepRangeList
        result.SleepWeekReport = tempSleepWeekReport
        
        return result
    }
}

// 生命体征
class ISignWeekReport:BaseMessage{
    
    var WeekMaxHR:String = ""
    var WeekMaxRR:String = ""
    var WeekMimHR:String = ""
    var WeekMimRR:String = ""
    var WeekAvgHR:String = ""
    var WeekAvgRR:String = ""
    var SignRangeList:Array<ISignRange> = Array<ISignRange>()
}

// 体征明细
class ISignRange:BaseMessage{
    
    var ReportDate:String = ""
    var Weekday:String = ""
    var AvgHR:String = ""
    var AvgRR:String = ""
}

class ILeaveBedWeekReport: BaseMessage {
    
    var MaxWeekday:String = ""
    var LeaveBedRangeList:Array<ILeaveBedRange> = Array<ILeaveBedRange>()
}

class ILeaveBedRange: BaseMessage {
    
    var ReportDate:String = ""
    var Weekday:String = ""
    var LeaveBedCount:String = ""
}

class ISleepWeekReport: BaseMessage {
    
    var ReportDate:String = ""
    var Weekday:String = ""
    var OnBedTimespan:String = ""
    var SleepTimespan:String = ""
    var AwakeningTimespan:String = ""
    var DeepSleepTimespan:String = ""
    var LightSleepTimespan:String = ""
    var SleepBeginTime:String = ""
    var SleepEndTime:String = ""
    var Suggest:ISleepSuggest = ISleepSuggest()
    var SleepRangeList:Array<ISleepWeekReport> = Array<ISleepWeekReport>()
}

class ISleepSuggest {
    
    var LeaveBedCount:String = ""
    var MaxLeaveBedTimespan:String = ""
    var TurnOverCount:String = ""
    var TurnOverRate:String = ""
    var Suggest:String = ""
}


