//
//  IHRMonitorViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IHRMonitorViewModel: BaseViewModel,RealTimeDelegate {
    
    // 属性
    var realTimeCaches:Array<RealTimeReport>?
    var hrRangeCaches:IHRRange?
    
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
    
    // 当前心率
    var _currentHR:String? = ""
    dynamic var CurrentHR:String?{
        get
        {
            return self._currentHR
        }
        set(value)
        {
            self._currentHR = value
        }
    }
    
    // 上一次平均心率
    var _lastAvgHR:String? = "次/分"
    dynamic var LastAvgHR:String?{
        get
        {
            return self._lastAvgHR
        }
        set(value)
        {
            self._lastAvgHR = value
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
    
    var _hrTimeReport:Array<IHRTimeReport> = Array<IHRTimeReport>()
    dynamic var HRTimeReport:Array<IHRTimeReport>{
        get{
            return self._hrTimeReport
        }
        set(value){
            self._hrTimeReport = value
        }
    }
    
    override init()
    {
        super.init()
    }
    
    required init(bedUserCode:String) {
        super.init()
        self.BedUserCode = bedUserCode
        //实时数据处理代理设置
        var xmppMsgManager = XmppMsgManager.GetInstance()
        xmppMsgManager?._realTimeDelegate = self
        self.realTimeCaches = Array<RealTimeReport>()
        self.setRealTimer()
        // 获取对应的周心率
        
        if(nil != self.BedUserCode)
        {
            var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
            var hrRange:IHRRange = sleepCareForIPhoneBLL.GetHRTimeReport(self.BedUserCode!)
            
            for report in hrRange.hrTimeReportList{
                _hrTimeReport.append(report)
            }
        }
    }
    
    //实时数据显示
    func setRealTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "realtimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    func realtimerFireMethod(timer: NSTimer) {
        if(self.realTimeCaches?.count > 0){
            var realTimeReport:RealTimeReport = self.realTimeCaches![0]
            self.OnBedStatus = realTimeReport.OnBedStatus
            self.CurrentHR = realTimeReport.HR
            self.ProcessValue = CGFloat((realTimeReport.HR as NSString).floatValue)
            self.LastAvgHR = realTimeReport.LastedAvgHR + "次/分"
            self.realTimeCaches?.removeAtIndex(0)
            
            
            self.LoadingFlag = true
        }
        
    }
    
    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
        // 根据用户编码获取
        let key = realTimeReport.UserCode
        if(key == self.BedUserCode)
        {
            realTimeCaches?.append(realTimeReport)
        }
    }
    
}