//
//  AlarmViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/8.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class AlarmViewModel:NSObject{
    
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
            self._funcSelectedIndex=value
        }
    }
    
    // 初始化
    override init()
    {
        self._funcSelectedIndex = 1
        super.init()
        
    }
    
    //自定义方法
    //当前选项卡选择触发的事件
    // 当选择为0时 表示选择的在离床报警
    // 当选择为1时 表示选择的体动/翻身信息
    func SelectChange(selectIndex:Int) -> BaseMessage
    {
        self.FuncSelectedIndex = selectIndex
        
        var sleepCareBLL = SleepCareBussiness()
        // 根据选择索引判断返回值
        if(self.FuncSelectedIndex == 0)
        {
            // 返回在离床报警
            var alarmList:AlarmList = sleepCareBLL.GetAlarmByUser("", userCode: "", userNameLike: "", bedNumberLike: "", schemaCode: "", alarmTimeBegin: "", alarmTimeEnd: "", from: nil, max: nil)
            return alarmList
        }
        else
        {
            // 返回体动/翻身
            var turnList:TurnOverAnalysList = sleepCareBLL.GetTurnOverAnalysByUser("", analysDateBegin: "", analysDateEnd: "", from: nil, max: nil)
            
            return turnList
        }
    }
}