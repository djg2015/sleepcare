//
//
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/19.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareDetailViewModel: BaseViewModel {
    //初始化
    required init(userCode:String,date:String) {
        super.init()
        self.userCode = userCode
        loadData(userCode,date: date)
    }
    
    override init() {
        super.init()
    }
    //属性定义
    var userCode:String = ""
    //深睡时长
    var _deepSleepSpan:String?
    dynamic var DeepSleepSpan:String?{
        get
        {
            return self._deepSleepSpan
        }
        set(value)
        {
            self._deepSleepSpan=value
        }
    }
    
    //浅睡时长
    var _lightSleepSpan:String?
    dynamic var LightSleepSpan:String?{
        get
        {
            return self._lightSleepSpan
        }
        set(value)
        {
            self._lightSleepSpan=value
        }
    }
    
    //在床时长
    var _onbedSpan:String?
    dynamic var OnbedSpan:String?{
        get
        {
            return self._onbedSpan
        }
        set(value)
        {
            self._onbedSpan=value
        }
    }
    
    //心率呼吸---------------
    var _hr:String?
    dynamic var HR:String?{
        get
        {
            return self._hr
        }
        set(value)
        {
            self._hr=value
        }
    }
    
    var _avgHR:String?
    dynamic var AvgHR:String?{
        get
        {
            return self._avgHR
        }
        set(value)
        {
            self._avgHR=value
        }
    }
    
    var _rr:String?
    dynamic var RR:String?{
        get
        {
            return self._rr
        }
        set(value)
        {
            self._rr=value
        }
    }
    
    var _avgRR:String?
    dynamic var AvgRR:String?{
        get
        {
            return self._avgRR
        }
        set(value)
        {
            self._avgRR=value
        }
    }
    
    //离床记录---------------
    var _leaveBedTimes:String?
    dynamic var LeaveBedTimes:String?{
        get
        {
            return self._leaveBedTimes
        }
        set(value)
        {
            self._leaveBedTimes=value
        }
    }
    
    var _maxLeaveBedSpan:String?
    dynamic var MaxLeaveBedSpan:String?{
        get
        {
            return self._maxLeaveBedSpan
        }
        set(value)
        {
            self._maxLeaveBedSpan=value
        }
    }
    
    var _leaveSuggest:String?
    dynamic var LeaveSuggest:String?{
        get
        {
            return self._leaveSuggest
        }
        set(value)
        {
            self._leaveSuggest=value
        }
    }
    
    //翻身记录---------------
    var _trunTimes:String?
    dynamic var TrunTimes:String?{
        get
        {
            return self._trunTimes
        }
        set(value)
        {
            self._trunTimes=value
        }
    }
    
    var _turnOverRate:String?
    dynamic var TurnOverRate:String?{
        get
        {
            return self._turnOverRate
        }
        set(value)
        {
            self._turnOverRate=value
        }
    }
    
    var _signReports:Array<SignReport>?
    dynamic var SignReports:Array<SignReport>?{
        get
        {
            return self._signReports
        }
        set(value)
        {
            self._signReports=value
        }
    }
    
    var _sleepCareReports:Array<SleepCareReport>?
    dynamic var SleepCareReports:Array<SleepCareReport>?{
        get
        {
            return self._sleepCareReports
        }
        set(value)
        {
            self._sleepCareReports=value
        }
    }
    //自定义方法
    //加载初始数据
    func loadData(userCode:String, date:String){
        try {
            ({
                let sleepCareBussiness = SleepCareBussiness()
                var sleepCareReport:SleepCareReport = sleepCareBussiness.QuerySleepQulityDetail(userCode, analysDate: date)
                self.DeepSleepSpan = sleepCareReport.DeepSleepTimeSpan
                self.LightSleepSpan = sleepCareReport.LightSleepTimeSpan
                self.OnbedSpan = sleepCareReport.OnBedTimeSpan.subString(0, length: 5)
                self.HR = sleepCareReport.HR
                self.RR = sleepCareReport.RR
                self.AvgHR = sleepCareReport.AVGHR
                self.AvgRR = sleepCareReport.AVGRR
                self.LeaveBedTimes = sleepCareReport.LeaveBedCount
                self.MaxLeaveBedSpan = sleepCareReport.MaxLeaveTimeSpan
                self.LeaveSuggest = sleepCareReport.LeaveBedSuggest
                self.TrunTimes = sleepCareReport.TurnOverTime
                self.TurnOverRate = sleepCareReport.TurnOverRate
                self.SignReports = sleepCareReport.SignReports
                //获取查询日期对应的自然周开始日期
                let begin = self.GetStartOfWeekForDate(date)
                let end  = begin.addDays(6)
                var session = Session.GetSession()
                var sleepcareList = sleepCareBussiness.GetSleepCareReportByUser(session.CurPartCode, userCode: userCode, analysTimeBegin: begin.description(format: "yyyy-MM-dd"), analysTimeEnd: end.description(format: "yyyy-MM-dd"), from: 1, max: 7)
                self.SleepCareReports = Array<SleepCareReport>()
                if(sleepcareList.sleepCareReportList.count > 0){
                    var curSleepCareReports = sleepcareList.sleepCareReportList
                    for i in 0...(curSleepCareReports.count - 1){
                        curSleepCareReports[i].ReportDate = self.GetChineseWeekDay(curSleepCareReports[i].ReportDate)
                        var bedSource = curSleepCareReports[i].OnBedTimeSpan
                        curSleepCareReports[i].onBedTimeSpanALL = (bedSource.split(":")[0] as NSString).doubleValue + (bedSource.split(":")[1] as NSString).doubleValue / 60
                        var sleepSource1 = (curSleepCareReports[i].DeepSleepTimeSpan.split(":")[0]  as NSString).doubleValue
                            + (curSleepCareReports[i].LightSleepTimeSpan.split(":")[0]  as NSString).doubleValue
                        var sleepsource2 = (curSleepCareReports[i].DeepSleepTimeSpan.split(":")[1]  as NSString).doubleValue
                            + (curSleepCareReports[i].LightSleepTimeSpan.split(":")[1]  as NSString).doubleValue
                        curSleepCareReports[i].SleepTimeSpanALL = sleepSource1 + sleepsource2 / 60
                    }
                    self.SleepCareReports = curSleepCareReports
                }
                },
                catch: { ex in
                    //异常处理
                 //   handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
    }
    
    //获取查询日期对应的自然周开始日期
    func GetStartOfWeekForDate(date:String) -> Date{
        var curDate = Date(string: date)
        var curindexofWeek = curDate.weekday()
        var span:Int = 0
        switch curindexofWeek{
        case Weekday.Sunday:
            span = 0
        case Weekday.Monday:
            span = 1
        case Weekday.Tuesday:
            span = 2
        case Weekday.Wednesday:
            span = 3
        case Weekday.Thursday:
            span = 4
        case Weekday.Friday:
            span = 5
        case Weekday.Saturday:
            span = 6
        }
        return curDate.addDays(-1 * span)
    }
    
    func GetChineseWeekDay(date:String) -> String{
        var curDate = Date(string: date)
        var curindexofWeek = curDate.weekday()
        switch curindexofWeek{
        case Weekday.Sunday:
            return "日"
        case Weekday.Monday:
            return "一"
        case Weekday.Tuesday:
            return "二"
        case Weekday.Wednesday:
            return "三"
        case Weekday.Thursday:
            return "四"
        case Weekday.Friday:
            return "五"
        case Weekday.Saturday:
            return "六"
        }
    }
}
