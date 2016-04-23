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
           
            self.loadPatientSleep(self.BedUserCode)
        }
    }
    
    // 要查询的床位用户编码
    var _bedUserCode:String = ""
    dynamic var BedUserCode:String{
        get{
            return self._bedUserCode
        }
        set(value){
            self._bedUserCode = value
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
    var _deepSleepTimespan:String = "00:00"
    dynamic var DeepSleepTimespan:String{
        get{
            return self._deepSleepTimespan
        }
        set(value){
            self._deepSleepTimespan = value
        }
    }
    
    // 浅睡时长
    var _lightSleepTimespan:String = "00:00"
    dynamic var LightSleepTimespan:String{
        get{
            return self._lightSleepTimespan
        }
        set(value){
            self._lightSleepTimespan = value
        }
    }
    
    // 在床时长
    var _onBedTimespan:String = "00:00"
    dynamic var OnBedTimespan:String{
        get{
            return self._onBedTimespan
        }
        set(value){
            self._onBedTimespan = value
        }
    }
    
    // 觉醒时长
    var _awakeningTimespan:String = "00:00"
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
    
    func  loadPatientSleep(bedusercode:String){
        if("" != bedusercode)
        {
        try {
            ({
                
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.Connect()
                if(!isconnect){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                    var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                    var report:ISleepQualityReport = sleepCareForIPhoneBLL.GetSleepQualityByUser(bedusercode, reportDate: self.SelectedDate)
                    self.SleepQuality = report.SleepQuality
                    if(report.SleepQuality == "优")
                    {
                        self.ProcessValue = 100
                    }
                    else if(report.SleepQuality == "良")
                    {
                        self.ProcessValue = 75
                        
                    }
                    if(report.SleepQuality == "中")
                    {
                        self.ProcessValue = 50
                        
                    }
                    if(report.SleepQuality == "一般")
                    {
                        self.ProcessValue = 25
                        
                    }
                    if(report.SleepQuality == "")
                    {
                        self.SleepQuality = "无"
                        self.ProcessValue = 0
                    }
                    if(report.DeepSleepTimespan != "")
                    {
                        var min = report.DeepSleepTimespan.subString(3, length: 2)
                        var hour = report.DeepSleepTimespan.subString(0, length: 2)
                        self.DeepSleepTimespan = hour + "小时" + min + "分"
                        
                    }
                    else
                    {
                        self.DeepSleepTimespan = "00小时00分"
                    }
                    if(report.LightSleepTimespan != "")
                    {
                        var min = report.LightSleepTimespan.subString(3, length: 2)
                        var hour = report.LightSleepTimespan.subString(0, length: 2)
                        self.LightSleepTimespan = hour + "小时" + min + "分"
                        
                    }
                    else
                    {
                        self.LightSleepTimespan = "00小时00分"
                    }
                    if(report.AwakeningTimespan != "")
                    {
                        var min = report.AwakeningTimespan.subString(3, length: 2)
                        var hour = report.AwakeningTimespan.subString(0, length: 2)
                        self.AwakeningTimespan = hour + "小时" + min + "分"
                        
                    }
                    else
                    {
                        self.AwakeningTimespan = "00小时00分"
                    }
                    if(report.OnBedTimespan != "")
                    {
                        self.OnBedTimespan = report.OnBedTimespan.subString(0, length: 2) + "小时" + report.OnBedTimespan.subString(3, length: 2) + "分"
                    }
                    else
                    {
                        self.OnBedTimespan = "00小时00分"
                    }
                    
                    if report.sleepRange.count == 0{
                        self.SleepRange = Array<ISleepDateReport>()
                    }
                    else{
                        self.SleepRange = report.sleepRange
                    }
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
            //清空页面数据
        else{
            self.SleepRange = Array<ISleepDateReport>()
            self.OnBedTimespan = ""
            self.ProcessValue = 0.0
            self.SleepQuality = ""
            self.DeepSleepTimespan = ""
            self.LightSleepTimespan = ""
            self.AwakeningTimespan = ""
        }
    }
    
}