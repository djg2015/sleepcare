//
//  AlarmViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/8.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class AlarmViewModel:BaseViewModel{
    
    //属性定义
    var _funcSelectedIndex:Int
    // 当前功能选项卡选择的索引
    dynamic var FuncSelectedIndex:Int{
        get
        {
            return self._funcSelectedIndex
        }
        set(value)
        {
            self._funcSelectedIndex=value        }
    }
    
    var _userCode:String = ""
    // 用户编码
    dynamic var UserCode:String{
        get
        {
            return self._userCode
        }
        set(value)
        {
            self._userCode=value
            try {
                ({
                    var sleepCareBLL = SleepCareBussiness()
                    // 返回在离床报警
                    var reportList:LeaveBedReportList = sleepCareBLL.GetLeaveBedReport(Session.GetSession().CurPartCode, userCode: self.UserCode, userNameLike: "", bedNumberLike: "", leaveBedTimeBegin: "", leaveBedTimeEnd: "", from: 1, max: 20)
                    for report in reportList.reportList
                    {
                        var alarmVM:OnBedAlarmViewModel = OnBedAlarmViewModel();
                        alarmVM.LeaveBedTime = report.StartTime;
                        alarmVM.LeaveBedTimeSpan = report.LeaveBedTimespan;
                        self.AlarmInfoList.append(alarmVM)
                    }
                    // 返回体动/翻身
                    var turnList:TurnOverAnalysList = sleepCareBLL.GetTurnOverAnalysByUser(self.UserCode, analysDateBegin: "", analysDateEnd: "", from: nil, max: nil)
                    
                    for report in turnList.turnOverAnalysReportList
                    {
                        var turnOverVM:TurnOverViewModel = TurnOverViewModel();
                        turnOverVM.Date = report.ReportDate;
                        turnOverVM.TurnOverTimes = report.TurnOverTime;
                        turnOverVM.TurnOverRate = report.TurnOverRate;
                        self.TurnOverList.append(turnOverVM)
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
    
    
    // 初始化
    override init()
    {
        self._funcSelectedIndex = 0
        super.init()
    }
    
    var _alarmList:Array<OnBedAlarmViewModel> =  Array<OnBedAlarmViewModel>();
    dynamic var AlarmInfoList:Array<OnBedAlarmViewModel>{
        get
        {
            return self._alarmList
        }
        set(value)
        {
            self._alarmList=value
        }
    }
    
    var _turnOverList:Array<TurnOverViewModel> =  Array<TurnOverViewModel>();
    dynamic var TurnOverList:Array<TurnOverViewModel>{
        get
        {
            return self._turnOverList
        }
        set(value)
        {
            self._turnOverList=value
        }
    }
    
    
    //自定义方法
    func SelectChange(selectIndex:Int)
    {
        self.FuncSelectedIndex = selectIndex;
    }
    
    
    // 在离床报警ViewModel
    class OnBedAlarmViewModel: NSObject{
        
        // 属性
        // 离床时长
        var _leaveBedTimeSpan:String = "";
        dynamic var LeaveBedTimeSpan:String
            {
            get
            {
                return self._leaveBedTimeSpan;
            }
            set(value)
            {
                self._leaveBedTimeSpan = value;
            }
        }
        
        // 离床时间
        var _leaveBedTime:String = "";
        dynamic var LeaveBedTime:String
            {
            get
            {
                return self._leaveBedTime;
            }
            set(value)
            {
                self._leaveBedTime = value;
            }
        }
        
        override init()
        {
            super.init();
        }
    }
    
    // 体动/翻身ViewModel
    class TurnOverViewModel: NSObject{
        
        // 属性
        // 分析日期
        var _date:String = "";
        dynamic var Date:String
            {
            get
            {
                return self._date;
            }
            set(value)
            {
                self._date = value;
            }
        }
        
        // 翻身次数
        var _turnOverTimes:String = "";
        dynamic var TurnOverTimes:String
            {
            get
            {
                return self._turnOverTimes;
            }
            set(value)
            {
                self._turnOverTimes = value;
            }
        }
        
        // 翻身频率
        var _turnOverRate:String = "";
        dynamic var TurnOverRate:String
            {
            get
            {
                return self._turnOverRate;
            }
            set(value)
            {
                self._turnOverRate = value;
            }
        }
        
    }
}