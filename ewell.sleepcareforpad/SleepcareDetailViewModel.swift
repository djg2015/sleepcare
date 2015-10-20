//
//  SleepcareDetailViewModel.swift
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
    
    //自定义方法
    //加载初始数据
    func loadData(userCode:String, date:String){
        try {
            ({
                let sleepCareBussiness = SleepCareBussiness()
                var sleepCareReport:SleepCareReport = sleepCareBussiness.QuerySleepQulityDetail(userCode, analysDate: date)
                self.DeepSleepSpan = sleepCareReport.DeepSleepTimeSpan
                self.LightSleepSpan = sleepCareReport.LightSleepTimeSpan
                self.OnbedSpan = sleepCareReport.OnBedTimeSpan
                self.HR = sleepCareReport.HR
                self.RR = sleepCareReport.RR
                self.AvgHR = sleepCareReport.AVGHR
                self.AvgRR = sleepCareReport.AVGRR
                self.LeaveBedTimes = sleepCareReport.LeaveBedCount
                self.MaxLeaveBedSpan = sleepCareReport.LightSleepTimeSpan
                self.LeaveSuggest = sleepCareReport.LeaveBedSuggest
                self.TrunTimes = sleepCareReport.TurnOverTime
                self.TurnOverRate = sleepCareReport.TurnOverRate
                self.SignReports = sleepCareReport.SignReports
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
