//
//  IHRMonitorViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

//class IHRMonitorViewModel: BaseViewModel,RealTimeDelegate {
class IHRMonitorViewModel: BaseViewModel,GetRealtimeDataDelegate{
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
            if value == "在床"{
                StatusImageName = "greenpoint.png"
            }
            else if value == "离床"{
                StatusImageName = "greypoint.png"
            }
            else if value == "请假"{
                StatusImageName = "lightgreenpoint.png"

            }
            else if value == "异常"{
               
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
    
    // 心率值
    var _processValue:CGFloat = 0.0
    dynamic var ProcessValue:CGFloat{
        get{
            return self._processValue
        }
        set(value){
            self._processValue = value
        }
    }
    
    // 心率最大值
    var _processMaxValue:CGFloat = 125.0
    dynamic var ProcessMaxValue:CGFloat{
        get{
            return self._processMaxValue
        }
        set(value){
            self._processMaxValue = value
        }
    }
    
    //呼吸报告
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
                    //连接成功，获取某床位用户心率报告
                var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var hrRange:IHRRange = sleepCareForIPhoneBLL.GetHRTimeReport(self.BedUserCode!)
                for report in hrRange.hrTimeReportList{
                    self._hrTimeReport.append(report)
                }
             
                RealTimeHelper.GetRealTimeInstance().SetDelegate("IHRMonitorViewModel",currentViewModelDelegate: self)
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
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
 
    //获取实时数据
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        for realTimeReport in realtimeData.values{
            if self.BedUserCode == realTimeReport.UserCode{
              self.OnBedStatus = realTimeReport.OnBedStatus
              self.CurrentHR = realTimeReport.HR
              self.ProcessValue = CGFloat((realTimeReport.HR as NSString).floatValue)
              self.LastAvgHR = realTimeReport.LastedAvgHR + "次/分"
              self.LoadingFlag = true
              return
            }
        }
    }
    
    //释放代理
    func Clean(){
        
    RealTimeHelper.GetRealTimeInstance().SetDelegate("IHRMonitorViewModel", currentViewModelDelegate: nil)
    }
}

