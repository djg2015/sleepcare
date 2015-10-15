//
//  SleepQualityPandectViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

// 睡眠质量总览
class SleepQualityPandectViewModel: NSObject{
    // 属性定义
    var _funcSelectedIndex:Int = 0
    // 当前功能选项卡选择的索引
    dynamic var FuncSelectedIndex:Int{
        get
        {
            return self._funcSelectedIndex
        }
        set(value)
        {
            self._funcSelectedIndex=value
        }
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