//
//  ISleepQualityMonitorViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class ISleepQualityMonitorViewModel: BaseViewModel {
    
    // 选择的查询日期
    var _selectedDate:String = ""
    dynamic var SelectedDate:String{
        get{
            return self._selectedDate
        }
        set(value){
            self._selectedDate = value
            var sleepCareForIPhoneBLL:SleepCareForIPhoneBussiness = SleepCareForIPhoneBussiness()
            var report:ISleepQualityReport = sleepCareForIPhoneBLL.GetSleepQualityByUser("00000001", reportDate: "2015-09-23")
            self.SleepQuality = report.SleepQuality
            if(report.SleepQuality == "优")
            {
                self.ProcessValue = 100
            }
            else if(report.SleepQuality == "良")
            {
                self.ProcessValue = 80
            }
            if(report.SleepQuality == "中")
            {
                self.ProcessValue = 60
            }
            if(report.SleepQuality == "差")
            {
                self.ProcessValue = 20
            }
            self.DeepSleepTimespan = report.DeepSleepTimespan.subString(0, length: 2) + "小时" + report.DeepSleepTimespan.subString(3, length: 2) + "分"
            self.LightSleepTimespan = report.LightSleepTimespan.subString(0, length: 2) + "小时" + report.LightSleepTimespan.subString(3, length: 2) + "分"
            self.AwakeningTimespan = report.AwakeningTimespan.subString(0, length: 2) + "小时" + report.AwakeningTimespan.subString(3, length: 2) + "分"
            self.OnBedTimespan = report.OnBedTimespan.subString(0, length: 2) + "小时" + report.OnBedTimespan.subString(3, length: 2) + "分"
            self.SleepRange = report.sleepRange
        }
    }
    
    // 查询日期的睡眠质量
    var _processValue:CGFloat = 0.0
    dynamic var ProcessValue:CGFloat{
        get{
            return self._processValue
        }
        set(value){
            self._processValue = value
        }
    }
    
    // 查询日期的睡眠质量
    var _processMaxValue:CGFloat = 100.0
    dynamic var ProcessMaxValue:CGFloat{
        get{
            return self._processMaxValue
        }
        set(value){
            self._processMaxValue = value
        }
    }
    
    // 查询日期的睡眠质量
    var _sleepQuality:String = ""
    dynamic var SleepQuality:String{
        get{
            return self._sleepQuality
        }
        set(value){
            self._sleepQuality = value
        }
    }
    
    // 深睡时长
    var _deepSleepTimespan:String = ""
    dynamic var DeepSleepTimespan:String{
        get{
            return self._deepSleepTimespan
        }
        set(value){
            self._deepSleepTimespan = value
        }
    }
    
    // 浅睡时长
    var _lightSleepTimespan:String = ""
    dynamic var LightSleepTimespan:String{
        get{
            return self._lightSleepTimespan
        }
        set(value){
            self._lightSleepTimespan = value
        }
    }
    
    // 在床时长
    var _onBedTimespan:String = ""
    dynamic var OnBedTimespan:String{
        get{
            return self._onBedTimespan
        }
        set(value){
            self._onBedTimespan = value
        }
    }
    
    // 觉醒时长
    var _awakeningTimespan:String = ""
    dynamic var AwakeningTimespan:String{
        get{
            return self._awakeningTimespan
        }
        set(value){
            self._awakeningTimespan = value
        }
    }
    
    // 当前周每天的睡眠质量
    var _sleepRange:Array<ISleepDateReport> = Array<ISleepDateReport>()
    dynamic var SleepRange:Array<ISleepDateReport> {
        get{
            return self._sleepRange
        }
        set(value){
            self._sleepRange = value
        }
    }
}