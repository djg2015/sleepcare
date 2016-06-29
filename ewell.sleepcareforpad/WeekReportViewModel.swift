//
//  WeekReportViewModel.swift
//
//
//  Created by Qinyuan Liu on 6/27/16.
//
//

import UIKit

class WeekReportViewModel: BaseViewModel {
    
    //起始结束时间
    var _beginDate:String=""
    dynamic var BeginDate:String{
        get
        {
            return self._beginDate
        }
        set(value)
        {
            self._beginDate=value
        }
    }
    
    var _endDate:String=""
    dynamic var EndDate:String{
        get
        {
            return self._endDate
        }
        set(value)
        {
            self._endDate=value
        }
    }
    
    //心率呼吸分析
    var _weekMaxRR:String=""
    dynamic var WeekMaxRR:String{
        get
        {
            return self._weekMaxRR
        }
        set(value)
        {
            self._weekMaxRR=value
        }
    }
    var _weekMinRR:String=""
    dynamic var WeekMinRR:String{
        get
        {
            return self._weekMinRR
        }
        set(value)
        {
            self._weekMinRR=value
        }
    }
    var _weekAvgRR:String=""
    dynamic var WeekAvgRR:String{
        get
        {
            return self._weekAvgRR
        }
        set(value)
        {
            self._weekAvgRR=value
        }
    }
    var _weekMaxHR:String=""
    dynamic var WeekMaxHR:String{
        get
        {
            return self._weekMaxHR
        }
        set(value)
        {
            self._weekMaxHR=value
        }
    }
    var _weekMinHR:String=""
    dynamic var WeekMinHR:String{
        get
        {
            return self._weekMinHR
        }
        set(value)
        {
            self._weekMinHR=value
        }
    }
    var _weekAvgHR:String=""
    dynamic var WeekAvgHR:String{
        get
        {
            return self._weekAvgHR
        }
        set(value)
        {
            self._weekAvgHR=value
        }
    }
    var _hrrrRange:HRRRChart=HRRRChart()
    dynamic var HRRRRange:HRRRChart{
        get
        {
            return self._hrrrRange
        }
        set(value)
        {
            self._hrrrRange=value
        }
    }
    
    //离床分析
    var _leaveBedSum:String=""
    dynamic var LeaveBedSum:String{
        get
        {
            return self._leaveBedSum
        }
        set(value)
        {
            self._leaveBedSum=value
        }
    }
    
    var _leaveBedRange:LeaveBedChart = LeaveBedChart()
    dynamic var LeaveBedRange:LeaveBedChart{
        get
        {
            return self._leaveBedRange
        }
        set(value)
        {
            self._leaveBedRange=value
        }
    }
    
    
    //睡眠分析
    var _weekWakeHours:String=""
    dynamic var WeekWakeHours:String{
        get
        {
            return self._weekWakeHours
        }
        set(value)
        {
            self._weekWakeHours=value
        }
    }
    
    
    var _weekLightSleepHours:String=""
    dynamic var WeekLightSleepHours:String{
        get
        {
            return self._weekLightSleepHours
        }
        set(value)
        {
            self._weekLightSleepHours=value
        }
    }
    
    var _weekDeepSleepHours:String=""
    dynamic var WeekDeepSleepHours:String{
        get
        {
            return self._weekDeepSleepHours
        }
        set(value)
        {
            self._weekDeepSleepHours=value
        }
    }
    var _weekSleepHours:String=""
    dynamic var WeekSleepHours:String{
        get
        {
            return self._weekSleepHours
        }
        set(value)
        {
            self._weekSleepHours=value
        }
    }
    
    
    var _onbedBeginTime:String=""
    dynamic var OnbedBeginTime:String{
        get
        {
            return self._onbedBeginTime
        }
        set(value)
        {
            self._onbedBeginTime=value
        }
    }
    
    var _onbedEndTime:String=""
    dynamic var OnbedEndTime:String{
        get
        {
            return self._onbedEndTime
        }
        set(value)
        {
            self._onbedEndTime=value
        }
    }
    
    
    //睡眠建议
    
    var _sleepRange:SleepChart = SleepChart()
    dynamic var SleepRange:SleepChart{
        get
        {
            return self._sleepRange
        }
        set(value)
        {
            self._sleepRange=value
        }
    }
    var _avgLeaveBedSum:String=""
    dynamic var AvgLeaveBedSum:String{
        get
        {
            return self._avgLeaveBedSum
        }
        set(value)
        {
            self._avgLeaveBedSum=value
        }
    }
    
    var _avgTurnTimes:String=""
    dynamic var AvgTurnTimes:String{
        get
        {
            return self._avgTurnTimes
        }
        set(value)
        {
            self._avgTurnTimes=value
        }
    }
    
    var _maxLeaveBedHours:String=""
    dynamic var MaxLeaveBedHours:String{
        get
        {
            return self._maxLeaveBedHours
        }
        set(value)
        {
            self._maxLeaveBedHours=value
        }
    }
    
    var _turnsRate:String=""
    dynamic var TurnsRate:String{
        get
        {
            return self._turnsRate
        }
        set(value)
        {
            self._turnsRate=value
        }
    }
    
    var _sleepSuggest:String=""
    dynamic var SleepSuggest:String{
        get
        {
            return self._sleepSuggest
        }
        set(value)
        {
            self._sleepSuggest=value
        }
    }
    
    
    //选择的日期，默认昨天
    var _selectDate:String=""
    dynamic var SelectDate:String{
        get
        {
            return self._selectDate
        }
        set(value)
        {
            self._selectDate = value
        }
    }
    
    //日期标签
    var _dateLabel:String = ""
    dynamic var DateLabel:String{
        get
        {
            return self._dateLabel
        }
        set(value)
        {
            self._dateLabel = value
        }
    }
    
    var _bedusercode:String = ""
    dynamic var bedusercode:String{
        get
        {
            return self._bedusercode
        }
        set(value)
        {
            self._bedusercode = value
        }
    }
    
    
    override init(){
        super.init()
        
        let curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
        self.SelectDate = Date(string: curDateString, format: "yyyy-MM-dd").addDays(-1).description(format: "yyyy-MM-dd")
        self.bedusercode = SessionForSingle.GetSession()!.CurPatientCode
        
        LoadData()
        
    }
    
    func LoadData(){
        try {
            ({
                
                
                if self.bedusercode != ""{
                    //获取选择日期所在周的周睡眠
                    var weekreport:WeekSleep = SleepCareForSingle().GetWeekSleepofBedUser(self.bedusercode, reportDate: self.SelectDate)
                    
                    self.BeginDate = weekreport.BeginDate.subString(0, length: 4) +  "/" + weekreport.BeginDate.subString(5, length: 2) + "/" + weekreport.BeginDate.subString(8, length: 2)
                    self.EndDate = weekreport.EndDate.subString(0, length: 4) +  "/" + weekreport.EndDate.subString(5, length: 2) + "/" + weekreport.EndDate.subString(8, length: 2)
                    self.DateLabel = self.BeginDate + "-" + self.EndDate
                    
                    
                    var tempValueY:Array<String> = []
                    var tempValueY2:Array<String> = []
                    var tempValueY3:Array<String> = []
                    var tempValueX: Array<String> = []
                    self.WeekMaxHR = weekreport.WeekMaxHR
                    self.WeekMinHR = weekreport.WeekMinHR
                    self.WeekAvgHR = weekreport.WeekAvgHR
                    self.WeekMaxRR = weekreport.WeekMaxRR
                    self.WeekMinRR = weekreport.WeekMinRR
                    self.WeekAvgRR = weekreport.WeekAvgRR
                    //  self.HRRRRange = weekreport.HRRRRange
                    if weekreport.HRRRRange.count > 0{
                        for(var i = 0; i<weekreport.HRRRRange.count; i++){
                            var tempx:String = weekreport.HRRRRange[i].WeekDay.subString(2, length: 1)
                            if i == 0{
                                tempx = "周" + tempx
                            }
                            tempValueX.append(tempx)
                            tempValueY.append(weekreport.HRRRRange[i].HR)
                            tempValueY2.append(weekreport.HRRRRange[i].RR)
                        }
                        
                        self.HRRRRange.flag = true
                    }
                    else{
                        self.HRRRRange.flag = false
                    }
                    self.HRRRRange.ValueY = NSArray(objects:tempValueY,tempValueY2)
                    self.HRRRRange.ValueX = tempValueX
                    
                    
                    self.LeaveBedSum = weekreport.LeaveBedSum
                    tempValueX = []
                    tempValueY = []
                    tempValueY2 = []
                    tempValueY3 = []
                    if weekreport.LeaveBedRange.count > 0{
                        for(var i = 0; i<weekreport.LeaveBedRange.count; i++){
                            var tempx:String = weekreport.LeaveBedRange[i].WeekDay.subString(2, length: 1)
                            if i == 0{
                                tempx = "周" + tempx
                            }
                            tempValueX.append(tempx)
                            tempValueY.append(weekreport.LeaveBedRange[i].LeaveBedTimes)
                        }
                        
                        self.LeaveBedRange.flag = true
                    }
                    else{
                        self.LeaveBedRange.flag = false
                    }
                    self.LeaveBedRange.ValueY = NSArray(objects:tempValueY)
                    self.LeaveBedRange.ValueX = tempValueX
                    
                    
                    
                    
                    self.WeekWakeHours = weekreport.WeekWakeHours
                    self.WeekLightSleepHours = weekreport.WeekLightSleepHours
                    self.WeekDeepSleepHours = weekreport.WeekDeepSleepHours
                    self.WeekSleepHours = weekreport.WeekSleepHours
                    
                    self.OnbedBeginTime = weekreport.OnbedBeginTime != "" ? weekreport.OnbedBeginTime.subString(11, length: 8) : ""
                    self.OnbedEndTime = weekreport.OnbedEndTime != "" ? weekreport.OnbedEndTime.subString(11, length: 8) : ""
                    
                    
                    
                    
                    //   self.SleepRange = weekreport.SleepRange
                    tempValueX = []
                    tempValueY = []
                    tempValueY2 = []
                    tempValueY3 = []
                    if weekreport.SleepRange.count > 0{
                        for(var i = 0; i<weekreport.SleepRange.count; i++){
                            var tempx:String = weekreport.SleepRange[i].WeekDay.subString(2, length: 1)
                            if i == 0{
                                tempx = "周" + tempx
                            }
                            tempValueX.append(tempx)
                            tempValueY.append(weekreport.SleepRange[i].DeepHours)
                            tempValueY2.append(weekreport.SleepRange[i].LightHours)
                            tempValueY3.append(weekreport.SleepRange[i].WakeHours)
                        }
                        
                        self.SleepRange.flag = true
                    }
                    else{
                        self.SleepRange.flag = false
                    }
                    self.SleepRange.ValueY = NSArray(objects:tempValueY,tempValueY2,tempValueY3)
                    self.SleepRange.ValueX = tempValueX
                    
                    self.AvgLeaveBedSum = weekreport.AvgLeaveBedSum
                    self.AvgTurnTimes = weekreport.AvgTurnTimes
                    self.MaxLeaveBedHours = weekreport.MaxLeaveBedHours
                    self.TurnsRate = weekreport.TurnsRate
                    self.SleepSuggest = "睡眠建议: " + weekreport.SleepSuggest
                    
                }
                else{
                //没有选择老人，默认值全为0
                    var tempValueY:Array<String> = []
                    var tempValueY2:Array<String> = []
                    var tempValueY3:Array<String> = []
                    var tempValueX: Array<String> = []
                  self.DateLabel = ""
                    self.WeekMaxHR = ""
                    self.WeekMinHR = ""
                    self.WeekAvgHR = ""
                    self.WeekMaxRR = ""
                    self.WeekMinRR = ""
                    self.WeekAvgRR = ""
                    self.HRRRRange.flag = false
                    self.HRRRRange.ValueY = NSArray(objects:tempValueY,tempValueY2)
                    self.HRRRRange.ValueX = tempValueX
                    self.LeaveBedSum = ""
                    self.LeaveBedRange.flag = false
                    self.LeaveBedRange.ValueY = NSArray(objects:tempValueY)
                    self.LeaveBedRange.ValueX = tempValueX
                    self.WeekWakeHours = ""
                    self.WeekLightSleepHours = ""
                    self.WeekDeepSleepHours = ""
                    self.WeekSleepHours = ""
                    
                    self.OnbedBeginTime = ""
                    self.OnbedEndTime = ""
                    self.SleepRange.flag = false
                    self.SleepRange.ValueY = NSArray(objects:tempValueY,tempValueY2,tempValueY3)
                    self.SleepRange.ValueX = tempValueX
                    
                    self.AvgLeaveBedSum = ""
                    self.AvgTurnTimes = ""
                    self.MaxLeaveBedHours = ""
                    self.TurnsRate = ""
                    self.SleepSuggest = "睡眠建议: "
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
    
}
//心率呼吸chart
class HRRRChart:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    
    
    var flag:Bool = true  //标志有没有chart数据
}


//离床chart
class LeaveBedChart:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    
    var flag:Bool = true  //标志有没有chart数据
}

//睡眠chart
class SleepChart:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    
    var flag:Bool = true  //标志有没有chart数据
}
