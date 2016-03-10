//
//  XmppMsgManager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class XmppMsgManager:MessageDelegate{
    
    private var _timeout:NSTimeInterval=1000
    private var _xmppMsgHelper:XmppMsgHelper?=nil
    private static var _xmppMsgManager:XmppMsgManager?=nil
    private var requsetQuene = Dictionary<String,AnyObject>()
    var _realTimeDelegate:RealTimeDelegate?=nil
    var _waringAttentionDelegate:WaringAttentionDelegate?=nil
    var isInstance = false
    
    
    private init(){
        
    }
    //获取xmpp通讯实例
    class func GetInstance(timeout:NSTimeInterval=1000)->XmppMsgManager?{
        if(self._xmppMsgManager == nil){
            self._xmppMsgManager = XmppMsgManager()
            self._xmppMsgManager!._timeout = timeout
            self._xmppMsgManager!._xmppMsgHelper = XmppMsgHelper()
            self._xmppMsgManager?._xmppMsgHelper!._messageDelegate = self._xmppMsgManager
        }
        return self._xmppMsgManager
    }
    
    //是否能够连接
    func Connect() -> Bool{
        let curTime = NSDate()
        if(_xmppMsgHelper!.connect(_timeout))
        {
            var sec:NSTimeInterval = 0
            while _xmppMsgHelper!.loginFlag == 0 {
                sec = NSDate().timeIntervalSinceDate(curTime)
                if(sec > 4){
                    return false
                }
            }
            if(_xmppMsgHelper!.loginFlag == 1){
                isInstance = true
            }
            return _xmppMsgHelper!.loginFlag == 1 ? true : false
        }
        return false
    }
    
    //ipad连接，iphone注册账号时连接
    func RegistConnect() -> Bool{
        let curTime = NSDate()
        if(_xmppMsgHelper!.RegistConnect(_timeout))
        {
            var sec:NSTimeInterval = 0
            while _xmppMsgHelper!.loginFlag == 0 {
                sec = NSDate().timeIntervalSinceDate(curTime)
                if(sec > 3){
                    return false
                }
            }
            if(_xmppMsgHelper!.loginFlag == 1){
                isInstance = true
            }
            return _xmppMsgHelper!.loginFlag == 1 ? true : false
        }
        return false
    }

    
    //关闭连接
    func Close(){
        isInstance = false
        _xmppMsgHelper?.disconnect()
    }
    
    //发送数据--等待数据响应
    func SendData(baseMessage:BaseMessage,timeOut:NSTimeInterval=9)->BaseMessage?{
    
        
        _xmppMsgHelper?.sendElement(baseMessage.ToXml())
        requsetQuene[baseMessage.messageSubject.requestID!] = self
        var now = NSDate()
        //添加时间判断，没收到数据则抛出异常
        var sec:NSTimeInterval = 0
        while requsetQuene[baseMessage.messageSubject.requestID!]!.isKindOfClass(BaseMessage) == false {
            sec = NSDate().timeIntervalSinceDate(now)
            if(sec > timeOut){
                throw("-2", ShowMessage(MessageEnum.GetDataOvertime))
            }
        }
        var result:BaseMessage = requsetQuene.removeValueForKey(baseMessage.messageSubject.requestID!) as! BaseMessage
        
        return result
    }

    
    //发送数据--无需等待响应
    func SendDataAsync(baseMessage:BaseMessage){
        _xmppMsgHelper?.sendElement(baseMessage.ToXml())
    }
    
    //处理响应的消息
    func newMessageReceived(msg:Message){
        
        var object:BaseMessage = MessageFactory.GetMessageModel(msg)
        
        if(object.isKindOfClass(RealTimeReport)){
            if(self._realTimeDelegate != nil){
                self._realTimeDelegate?.GetRealTimeDelegate(object as! RealTimeReport)
            }
        }
        else if(object.isKindOfClass(AlarmList) && "GetAlarmByUser" != object.messageSubject.operate && "GetAlarmByLoginUser" != object.messageSubject.operate)
        {
            if(self._waringAttentionDelegate != nil){
                self._waringAttentionDelegate?.GetWaringAttentionDelegate(object as! AlarmList)
            }
        }
        else
        {
           
            requsetQuene[object.messageSubject.requestID!] = object
        }
    }
    
    
}