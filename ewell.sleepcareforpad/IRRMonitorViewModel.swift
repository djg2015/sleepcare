//
//  IRRMonitorViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

//class IRRMonitorViewModel: BaseViewModel,RealTimeDelegate {
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
            //实时数据处理代理设置
            //        var xmppMsgManager = XmppMsgManager.GetInstance()
            //        xmppMsgManager?._realTimeDelegate = self
            //        self.realTimeCaches = Array<RealTimeReport>()
            //        self.setRealTimer()
            // 获取对应的周心率
            
            if(nil != self.BedUserCode)
            {
                var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var rrRange:IRRRange = sleepCareForIPhoneBLL.GetRRTimeReport(self.BedUserCode!)
                
                for report in rrRange.rrTimeReportList{
                    self._rrTimeReport.append(report)
                }
                
                RealTimeHelper.GetRealTimeInstance().delegate = self
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
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
                    }//for
    }
}

//实时数据显示
//    func setRealTimer(){
//        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "realtimerFireMethod:", userInfo: nil, repeats:true);
//        realtimer.fire()
//    }
//
//    func realtimerFireMethod(timer: NSTimer) {
//
//        if(self.realTimeCaches?.count > 0){
//            var realTimeReport:RealTimeReport = self.realTimeCaches![0]
//
//            self.OnBedStatus = realTimeReport.OnBedStatus
//            self.CurrentRR = realTimeReport.RR
//            self.ProcessValue = CGFloat((realTimeReport.RR as NSString).floatValue)
//            self.LastAvgRR = realTimeReport.LastedAvgRR + "次/分"
//
//            self.realTimeCaches?.removeAtIndex(0)
//
//            self.LoadingFlag = true
//        }
//
//    }
//
//    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
//        let key = realTimeReport.UserCode
//        if(key == self.BedUserCode)
//        {
//            realTimeCaches?.append(realTimeReport)
//        }
//    }
