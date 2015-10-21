    //
    //  SleepQualityPandectViewModel.swift
    //  ewell.sleepcareforpad
    //
    //  Created by zhaoyin on 15/10/15.
    //  Copyright (c) 2015年 djg. All rights reserved.
    //
    
    import Foundation
    import UIKit
    
    // 睡眠质量总览
    class SleepcareQualityPandectViewModel: BaseViewModel{
        
        var tableView:UITableView = UITableView()
        
        // 属性定义
        var _sleepQualityList:Array<SleepPandectItemViewModel> = Array<SleepPandectItemViewModel>()
        // 当前功能选项卡选择的索引
        dynamic var SleepQualityList:Array<SleepPandectItemViewModel>{
            get
            {
                return self._sleepQualityList
            }
            set(value)
            {
                self._sleepQualityList = value
            }
        }
        
        var _analysisTimeBegin:String = ""
        // 分析起始时间
        dynamic var AnalysisTimeBegin:String{
            get
            {
                return self._analysisTimeBegin
            }
            set(value)
            {
                self._analysisTimeBegin=value
            }
        }
        
        var _analysisTimeEnd:String = ""
        // 分析结束时间
        dynamic var AnalysisTimeEnd:String{
            get
            {
                return self._analysisTimeEnd
            }
            set(value)
            {
                self._analysisTimeEnd=value
            }
        }
        
        var _currentPageIndex:String = "1"
        // 当前页码
        dynamic var CurrentPageIndex:String{
            get
            {
                return self._currentPageIndex
            }
            set(value)
            {
                self._currentPageIndex=value
            }
        }
        
        var _userCode:String = ""
        // 用户编码
        var UserCode:String{
            get
            {
                return self._userCode
            }
            set(value)
            {
                self._userCode=value
            }
        }
        
        // 一页显示的条数
        let _pageSize:Int32 = 12
        var _totalNum:Int32 = 0;
        
        var _totalPageCount:String = "共0页"
        // 一共多少页
        dynamic var TotalPageCount:String{
            get
            {
                return self._totalPageCount
            }
            set(value)
            {
                self._totalPageCount=value
            }
        }
        
        var _previewBtnEnable:Bool = false
        // 分析结束时间
        dynamic var PreviewBtnEnable:Bool{
            get
            {
                return self._previewBtnEnable
            }
            set(value)
            {
                self._previewBtnEnable=value
            }
        }
        
        var _nextBtnEnable:Bool = false
        // 分析结束时间
        dynamic var NextBtnEnable:Bool{
            get
            {
                return self._nextBtnEnable
            }
            set(value)
            {
                self._nextBtnEnable=value
            }
        }
        
        // Command定义
        // 查询
        var searchCommand: RACCommand?
        // 上一页
        var previewCommand: RACCommand?
        // 下一页
        var nextCommand: RACCommand?
        
        override init() {
            super.init()
        }
        
        required init(userCode:String)
        {
            super.init()
            self.UserCode = userCode
            searchCommand = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                return self.Search()
            }
            previewCommand = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                return self.Preview()
            }
            nextCommand = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                return self.Next()
            }
            // 加载数据
            self.AnalysisTimeBegin = Date.today().addDays(-7).description(format: "yyyy-MM-dd")
            self.AnalysisTimeEnd = Date.today().description(format: "yyyy-MM-dd")
            self.Search()
        }
        
        
        func Search() -> RACSignal{
            
            self.SleepQualityList = Array<SleepPandectItemViewModel>()
            self.CurrentPageIndex = "1"
            try {
                ({
                    var sleepCareBLL = SleepCareBussiness()
                    
                    var sleepCareReportList:SleepCareReportList = sleepCareBLL.GetSleepCareReportByUser(Session.GetSession().CurPartCode, userCode: self.UserCode, analysTimeBegin: self.AnalysisTimeBegin, analysTimeEnd: self.AnalysisTimeEnd, from:(Int32(self.CurrentPageIndex.toInt()!) - 1) * self._pageSize + 1 , max: self._pageSize)
                    
                    var totalSleepCareReportList:SleepCareReportList = sleepCareBLL.GetSleepCareReportByUser(Session.GetSession().CurPartCode, userCode: self.UserCode, analysTimeBegin: self.AnalysisTimeBegin, analysTimeEnd: self.AnalysisTimeEnd, from:nil, max: nil)
                    self._totalNum = Int32(totalSleepCareReportList.sleepCareReportList.count)
                    
                    var index:Int = 1;
                    for sleepCare in sleepCareReportList.sleepCareReportList
                    {
                        var itemVM:SleepPandectItemViewModel = SleepPandectItemViewModel()
                        itemVM.Number = index++
                        itemVM.AnalysisTimeSpan = sleepCare.AnalysisDateSection
                        itemVM.AvgRR = sleepCare.AVGRR
                        itemVM.AvgHR = sleepCare.AVGHR
                        itemVM.TurnTimes = sleepCare.TurnOverTime
                        
                        self.SleepQualityList.append(itemVM)
                    }
                    var pageCount:Int32 = 0
                    if(Int32(self._totalNum) % self._pageSize != 0)
                    {
                        pageCount = Int32(self._totalNum)/self._pageSize + 1
                    }
                    else
                    {
                        pageCount = Int32(self._totalNum)/self._pageSize
                    }
                    self.TotalPageCount = "共" + String(pageCount) + "页"
                    
                    if(pageCount <= 1)
                    {
                        self.PreviewBtnEnable = false
                        self.NextBtnEnable = false
                    }
                    else
                    {
                        self.NextBtnEnable = true
                    }
                    self.tableView.reloadData()
                    },
                    catch: { ex in
                        //异常处理
                        handleException(ex,showDialog: true)
                    },
                    finally: {
                        
                    }
                )}
            
            return RACSignal.empty()
        }
        
        func Preview() -> RACSignal{
            
            self.SleepQualityList = Array<SleepPandectItemViewModel>()
            try {
                ({
                    if(Int32(self.CurrentPageIndex.toInt()!) > 1)
                    {
                        self.CurrentPageIndex = String(Int32(self.CurrentPageIndex.toInt()!) - 1)
                        
                        var sleepCareBLL = SleepCareBussiness()
                        
                        var sleepCareReportList:SleepCareReportList = sleepCareBLL.GetSleepCareReportByUser(Session.GetSession().CurPartCode, userCode: self.UserCode, analysTimeBegin: self.AnalysisTimeBegin, analysTimeEnd: self.AnalysisTimeEnd, from:(Int32(self.CurrentPageIndex.toInt()!) - 1) * self._pageSize + 1 , max: self._pageSize)
                        var index:Int = 1;
                        for sleepCare in sleepCareReportList.sleepCareReportList
                        {
                            var itemVM:SleepPandectItemViewModel = SleepPandectItemViewModel()
                            itemVM.Number = index++
                            itemVM.AnalysisTimeSpan = sleepCare.AnalysisDateSection
                            itemVM.AvgRR = sleepCare.AVGRR
                            itemVM.AvgHR = sleepCare.AVGHR
                            itemVM.TurnTimes = sleepCare.TurnOverTime
                            
                            self.SleepQualityList.append(itemVM)
                        }
                        
                        if(Int32(self._totalNum) % self._pageSize != 0)
                        {
                            self.TotalPageCount = "共" + String(Int32(self._totalNum)/self._pageSize + 1) + "页"
                        }
                        else
                        {
                            self.TotalPageCount = "共" + String(Int32(self._totalNum)/self._pageSize) + "页"
                        }
                        self.NextBtnEnable = true
                        
                        if(Int32(self.CurrentPageIndex.toInt()!) == 1)
                        {
                            self.PreviewBtnEnable = false
                        }
                        else
                        {
                            self.PreviewBtnEnable = true
                        }
                        self.tableView.reloadData()
                    }
                    },
                    catch: { ex in
                        //异常处理
                        handleException(ex,showDialog: true)
                    },
                    finally: {
                        
                    }
                )}
            
            return RACSignal.empty()
        }
        
        func Next() -> RACSignal{
            
            self.SleepQualityList = Array<SleepPandectItemViewModel>()
            try {
                ({
                    var pageCount:Int32 = 0
                    if(Int32(self._totalNum) % self._pageSize != 0)
                    {
                        pageCount = Int32(self._totalNum)/self._pageSize + 1
                    }
                    else
                    {
                        pageCount = Int32(self._totalNum)/self._pageSize
                    }
                    if(Int32(self.CurrentPageIndex.toInt()!) < pageCount)
                    {
                        self.CurrentPageIndex = String(Int32(self.CurrentPageIndex.toInt()!) + 1)
                        
                        var sleepCareBLL = SleepCareBussiness()
                        
                        var sleepCareReportList:SleepCareReportList = sleepCareBLL.GetSleepCareReportByUser(Session.GetSession().CurPartCode, userCode: self.UserCode, analysTimeBegin: self.AnalysisTimeBegin, analysTimeEnd: self.AnalysisTimeEnd, from:(Int32(self.CurrentPageIndex.toInt()!) - 1) * self._pageSize + 1 , max: self._pageSize)
                        var index:Int = 1;
                        for sleepCare in sleepCareReportList.sleepCareReportList
                        {
                            var itemVM:SleepPandectItemViewModel = SleepPandectItemViewModel()
                            itemVM.Number = index++
                            itemVM.AnalysisTimeSpan = sleepCare.AnalysisDateSection
                            itemVM.AvgRR = sleepCare.AVGRR
                            itemVM.AvgHR = sleepCare.AVGHR
                            itemVM.TurnTimes = sleepCare.TurnOverTime
                            
                            self.SleepQualityList.append(itemVM)
                        }
                        
                        if(Int32(self._totalNum) % self._pageSize != 0)
                        {
                            self.TotalPageCount = "共" + String(Int32(self._totalNum)/self._pageSize + 1) + "页"
                        }
                        else
                        {
                            self.TotalPageCount = "共" + String(Int32(self._totalNum)/self._pageSize) + "页"
                        }
                        
                        self.PreviewBtnEnable = true
                        if(Int32(self.CurrentPageIndex.toInt()!) == pageCount)
                        {
                            self.NextBtnEnable = false
                        }else
                        {
                            self.NextBtnEnable = true
                        }
                        self.tableView.reloadData()
                    }
                    },
                    catch: { ex in
                        //异常处理
                        handleException(ex,showDialog: true)
                    },
                    finally: {
                        
                    }
                )}
            
            return RACSignal.empty()
        }
    }
    
    class SleepPandectItemViewModel:NSObject
    {
        // 属性定义
        var _number:Int = 0
        // 序号
        dynamic var Number:Int{
            get
            {
                return self._number
            }
            set(value)
            {
                self._number=value
            }
        }
        
        var _analysisTimeSpan:String = ""
        // 分析时段
        dynamic var AnalysisTimeSpan:String
            {
            get
            {
                return self._analysisTimeSpan
            }
            set(value)
            {
                self._analysisTimeSpan = value
            }
        }
        
        var _avgHR:String = ""
        // 平均心率
        dynamic var AvgHR:String
            {
            get
            {
                return self._avgHR
            }
            set(value)
            {
                self._avgHR = value
            }
        }
        
        var _avgRR:String = ""
        // 平均呼吸
        dynamic var AvgRR:String
            {
            get
            {
                return self._avgRR
            }
            set(value)
            {
                self._avgRR = value
            }
        }
        
        var _turnTimes:String = ""
        // 翻身次数
        dynamic var TurnTimes:String
            {
            get
            {
                return self._turnTimes
            }
            set(value)
            {
                self._turnTimes = value
            }
        }
        
        override init() {
            super.init()
        }
    }