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
class SleepQualityPandectViewModel: NSObject{
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
            self._sleepQualityList=value
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
    
    var _currentPageIndex:Int32 = 1
    // 当前页码
    dynamic var CurrentPageIndex:Int32{
        get
        {
            return self._currentPageIndex
        }
        set(value)
        {
            self._currentPageIndex=value
        }
    }
    
    var _pageSize:Int32 = 10
    

    // Command定义
    // 查询
    var searchCommand: RACCommand?
    // 上一页
    var previewCommand: RACCommand?
    // 下一页
    var nextCommand: RACCommand?
    
    override init()
    {
        super.init()
//        login = RACCommand() {
//            (any:AnyObject!) -> RACSignal in
//            return self.Login()
//        }
    }
    
    
    func Search() -> RACSignal{
        
        var sleepCareBLL = SleepCareBussiness()
        
        var sleepCareReportList:SleepCareReportList = sleepCareBLL.GetSleepCareReportByUser("00001", userCode: "00000001", analysTimeBegin: "", analysTimeEnd: "", from:self.CurrentPageIndex , max: self._pageSize)
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