//
//  RealTimeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/31/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import Foundation

class RealTimeHelper:NSObject, RealTimeDelegate{
    private var lock:NSLock?
    
    private static var realtimeInstance:RealTimeHelper? = nil
  //  var delegate:GetRealtimeDataDelegate?
    var delegateList:Dictionary<String,GetRealtimeDataDelegate>= Dictionary<String,GetRealtimeDataDelegate>()
   
    //key:bedusercode,value:realtimereport
    var realTimeCaches:Dictionary<String,RealTimeReport>!
   
  
    class func GetRealTimeInstance()->RealTimeHelper{
            if self.realtimeInstance == nil {
                self.realtimeInstance = RealTimeHelper()
                //实时数据处理代理设置
                var xmppMsgManager = XmppMsgManager.GetInstance()
                xmppMsgManager?._realTimeDelegate =  self.realtimeInstance
                self.realtimeInstance!.realTimeCaches = Dictionary<String,RealTimeReport>()
                self.realtimeInstance!.lock = NSLock()
            }
        
            return self.realtimeInstance!
}
    class func Close(){
        self.realtimeInstance = nil
    }
    
    //设置当前代理
    func SetDelegate(name:String,currentViewModelDelegate:GetRealtimeDataDelegate?){
        if currentViewModelDelegate != nil{
            self.delegateList[name] = currentViewModelDelegate
        }
        else{
            self.delegateList[name] = nil
        }
    }
    
    //每隔2秒从缓冲区中取数据，让代理处理需要显示的数据
    func setRealTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "ShowRealTimeData", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    func ShowRealTimeData(){
        for key in self.delegateList.keys{
            if self.delegateList[key] != nil{
            self.delegateList[key]!.GetRealtimeData(self.realTimeCaches!)
            }
        }
    }
    
    //实时数据获取,每个床位病人对应一条实时数据
    //通过session里的beduserlist进行删选，选择关注的老人实时信息放入缓冲区
    //当前关注的老人出院，收不到实时数据
    
    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
        //key ＝ 病人code
        let key = realTimeReport.UserCode
        let session = SessionForIphone.GetSession()
        
        if session != nil{
        let usercodeList = session!.BedUserCodeList
        
        self.lock!.lock()
        //判断此实时报告的人是否在关注列表,bedusercode做删选
        if usercodeList.filter({$0 == key}).count > 0 {
            if(self.realTimeCaches.count > 0){
                //检查缓冲区是否存在该病人实时报告，存在则更新；不存在则插入.存放时bedusercode为key值
                var keys = self.realTimeCaches.keys.filter({$0 == key})
                if(keys.array.count == 0)
                {
                    self.realTimeCaches[key] = realTimeReport
                }
                else
                {
                    self.realTimeCaches.updateValue(realTimeReport, forKey: key)
                }
            }
            else{
                self.realTimeCaches[realTimeReport.BedCode] = realTimeReport
            }
        }

        self.lock!.unlock()
    }
    
    }

}

//每个需要实时数据的界面实现这个代理，获取数据
protocol GetRealtimeDataDelegate{
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>)
}
