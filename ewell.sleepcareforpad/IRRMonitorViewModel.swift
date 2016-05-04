//
//  IRRMonitorViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IRRMonitorViewModel: BaseViewModel,GetRealtimeDataDelegate{
    // 属性
    var realTimeCaches:Array<RealTimeReport>?
    var rrRangeCaches:IHRRange?
    var realtimeFlag:Bool = false
    //实时数据是否已经载入
    var _loadingFlag:Bool = false
    dynamic var LoadingFlag:Bool{
        get
        {
            return self._loadingFlag
        }
        set(value)
        {
            self._loadingFlag = value
        }
    }
    
    // 当前用户所在床位号
    var _bedUserCode:String?
    dynamic var BedUserCode:String?{
        get
        {
            return self._bedUserCode
        }
        set(value)
        {
            self._bedUserCode = value
        }
    }
    var _bedUserName:String?
    dynamic var BedUserName:String?{
        get
        {
            return self._bedUserName
        }
        set(value)
        {
            self._bedUserName = value
        }
    }
    // 在离床状态
    var _onBedStatus:String?
    dynamic var OnBedStatus:String?{
        get
        {
            return self._onBedStatus
        }
        set(value)
        {
            self._onBedStatus = value
            self._onBedStatus = value
            if value == "在床"{
                StatusImageName = "greenpoint.png"
            }
            else if value == "离床"{
                StatusImageName = "greypoint.png"
            }
            else if value == "请假"{
                StatusImageName = "lightgreenpoint.png"
                
            }
            else if value ==  "异常"{
             
                StatusImageName = "yellowpoint.png"
            }


        }
    }
    //在离床状态的图片
    var _statusImageName:String?
    dynamic var StatusImageName:String?{
        get
        {
            return self._statusImageName
        }
        set(value)
        {
            self._statusImageName=value
        }
    }
    
    // 当前呼吸
    var _currentRR:String? = ""
    dynamic var CurrentRR:String?{
        get
        {
            return self._currentRR
        }
        set(value)
        {
            self._currentRR = value
 
        }
    }
    // 上一次平均呼吸
    var _lastAvgRR:String? = "次/分"
    dynamic var LastAvgRR:String?{
        get
        {
            return self._lastAvgRR
        }
        set(value)
        {
            self._lastAvgRR = value
        }
    }
    
    // 呼吸值
    var _processValue:CGFloat = 0.0
    dynamic var ProcessValue:CGFloat{
        get{
            return self._processValue
        }
        set(value){
            self._processValue = value
        }
    }
    
    // 呼吸最大值
    var _processMaxValue:CGFloat = 50.0
    dynamic var ProcessMaxValue:CGFloat{
        get{
            return self._processMaxValue
        }
        set(value){
            self._processMaxValue = value
        }
    }
    
    //呼吸报告
    var _rrTimeReport:Array<IRRTimeReport> = Array<IRRTimeReport>()
    dynamic var RRTimeReport:Array<IRRTimeReport>{
        get{
            return self._rrTimeReport
        }
        set(value){
            self._rrTimeReport = value
        }
    }
    
    override init() {
        super.init()
    }
    
    func loadPatientRR(bedusercode:String){
        try {({
            
            
            if("" != bedusercode)
            {

                    //获取某床位用户呼吸报告
                var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var rrRange:IRRRange = sleepCareForIPhoneBLL.GetRRTimeReport(self.BedUserCode!)
                var tempRRTimeReport = Array<IRRTimeReport>()
                    
                    for report in rrRange.rrTimeReportList{
                    tempRRTimeReport.append(report)
                }
                     self.RRTimeReport = tempRRTimeReport
                self.realtimeFlag = true
                RealTimeHelper.GetRealTimeInstance().SetDelegate("IRRMonitorViewModel",currentViewModelDelegate: self)
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
 
            }
            else{
                //清空页面数据
                
                self.CleanRealtimeDelegate()
                self.realtimeFlag = false
                self.OnBedStatus = ""
                self.CurrentRR = ""
                self.LastAvgRR = ""
                self.ProcessValue = 0.0
                self.StatusImageName = ""
                self.RRTimeReport = Array<IRRTimeReport>()
            }

            },
            catch: { ex in
                handleException(ex,showDialog: true)
            },
            finally: {
            }
            )}
    }
    
    //获取实时数据
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
         if realtimeFlag{
        for realTimeReport in realtimeData.values{
            if self.BedUserCode == realTimeReport.UserCode{
                self.OnBedStatus = realTimeReport.OnBedStatus
                self.CurrentRR = realTimeReport.RR
                self.ProcessValue = CGFloat((realTimeReport.RR as NSString).floatValue)
                self.LastAvgRR = realTimeReport.LastedAvgRR + "次/分"
                self.LoadingFlag = true
                return
            }
        }
        }
    }
    
    //释放实时数据delegate代理
   func CleanRealtimeDelegate(){
        RealTimeHelper.GetRealTimeInstance().SetDelegate("IRRMonitorViewModel", currentViewModelDelegate: nil)
    }
}


