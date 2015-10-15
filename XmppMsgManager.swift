//
//  XmppMsgManager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation




class XmppMsgManager:MessageDelegate{
    
    private var _timeout:NSTimeInterval=100
    private var _xmppMsgHelper:XmppMsgHelper?=nil
    private static var _xmppMsgManager:XmppMsgManager?=nil
    private var requsetQuene = Dictionary<String,BaseMessage>()
    var _realTimeDelegate:RealTimeDelegate?=nil
    private init(){
        
    }
    
    //获取xmpp通讯实例
    class func GetInstance(timeout:NSTimeInterval=100)->XmppMsgManager?{
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
        //_xmppMsgHelper!.connect(_timeout)
        let curTime = NSDate()
        if(_xmppMsgHelper!.connect(_timeout))
        {
            var sec:NSTimeInterval = 0
            while _xmppMsgHelper!.loginFlag == 0 {
                sec = NSDate().timeIntervalSinceDate(curTime)
                if(sec > 20){
                    return false
                }
            }
            
            return _xmppMsgHelper!.loginFlag == 1 ? true : false
        }
        return false
        
    }
    
    //发送数据--等待数据响应
    func SendData(baseMessage:BaseMessage)->BaseMessage?{
        
        _xmppMsgHelper?.sendElement(baseMessage.ToXml())
        
        requsetQuene[baseMessage.messageSubject.requestID!] = nil
        
        while requsetQuene[baseMessage.messageSubject.requestID!] == nil {
            
        }
        
        var result:BaseMessage = requsetQuene[baseMessage.messageSubject.requestID!]!
        requsetQuene[baseMessage.messageSubject.requestID!] = nil
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
        else
        {
            requsetQuene[object.messageSubject.requestID!] = object
        }
    }
    
    
}