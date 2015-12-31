//
//  RealTimeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/31/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import Foundation
class RealTimeHelper:NSObject, RealTimeDelegate{

    var delegate:GetRealtimeDataDelegate!
     // var delegateList:Array<GetRealtimeDataDelegate>?
    //key:bedusercode,value:realtimereport
    var realTimeCaches:Dictionary<String,RealTimeReport>?
    private static var realtimeInstance:RealTimeHelper? = nil
  
    class func GetRealTimeInstance()->RealTimeHelper{
            if self.realtimeInstance == nil {
                self.realtimeInstance = RealTimeHelper()
                //实时数据处理代理设置
                var xmppMsgManager = XmppMsgManager.GetInstance()
                xmppMsgManager?._realTimeDelegate =  self.realtimeInstance
                self.realtimeInstance!.realTimeCaches = Dictionary<String,RealTimeReport>()
        }
            return self.realtimeInstance!

}
    
    //每隔一秒从缓冲区中取数据，让代理处理需要显示的数据
    func setRealTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "ShowRealTimeData", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    func ShowRealTimeData(){
        if self.delegate != nil{
            self.delegate.GetRealtimeData(self.realTimeCaches!)
        }
       
    }
    
    //实时数据获取,每个床位病人对应一条实时数据，放入缓冲区
    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
        let key = realTimeReport.UserCode
        if(self.realTimeCaches?.count > 0){
            var keys = self.realTimeCaches?.keys.filter({$0 == key})
            if(keys?.array.count == 0)
            {
                self.realTimeCaches?[key] = realTimeReport
            }
            else
            {
                self.realTimeCaches?.updateValue(realTimeReport, forKey: key)
            }
        }
        else{
            self.realTimeCaches?[key] = realTimeReport
        }
    }
    
    //设置当前代理
    func SetDelegate(currentViewModel:BaseViewModel){
    self.delegate = currentViewModel.delegate
    }
}

//每个需要实时数据的界面实现这个代理，获取数据
protocol GetRealtimeDataDelegate{
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>)
}
