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
            else{
                self._onBedStatus = "异常"
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
    
    required init(bedUserCode:String) {
        super.init()
        try {({
            self.BedUserCode = bedUserCode
            
            if(nil != self.BedUserCode)
            {
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.Connect()
                if(!isconnect){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var rrRange:IRRRange = sleepCareForIPhoneBLL.GetRRTimeReport(self.BedUserCode!)
                
                for report in rrRange.rrTimeReportList{
                    self._rrTimeReport.append(report)
                }
                
                RealTimeHelper.GetRealTimeInstance().SetDelegate("IRRMonitorViewModel",currentViewModelDelegate: self)
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
            }
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
    
    //释放实时数据delegate代理
    func Clean(){
        RealTimeHelper.GetRealTimeInstance().SetDelegate("IRRMonitorViewModel", currentViewModelDelegate: nil)
    }
}


