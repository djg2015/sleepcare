//
//  XmppMsgHelper.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class XmppMsgHelper:UIResponder, UIApplicationDelegate,XMPPStreamDelegate{

    var xmppStream:XMPPStream?
    var password:String? = ""
    var isOpen:Bool = false
    var loginFlag:Int = 0
    var _messageDelegate:MessageDelegate?
    func setupStream(){
        
        //初始化XMPPStream
        xmppStream = XMPPStream()
        xmppStream!.addDelegate(self,delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        
    }
    
    func goOnline(){
        
        //发送在线状态
        var presence:XMPPPresence = XMPPPresence()
        xmppStream!.sendElement(presence)
        
    }
    
    func goOffline(){
        
        //发送下线状态
        var presence:XMPPPresence = XMPPPresence(type:"unavailable");
        xmppStream!.sendElement(presence)
        
    }
    
    func connect(timeOut:NSTimeInterval) -> Bool{
        //初始化登录flag
        self.loginFlag = 0
        self.setupStream()
        
        //从本地取得用户名，密码和服务器地址
        var defaults:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        
        var userId:String?  = defaults.stringForKey(USERID)
        var pass:String? = defaults.stringForKey(PASS)
        var server:String? = defaults.stringForKey(SERVER)
        
        if (!xmppStream!.isDisconnected()) {
            return true
        }
        
        if (userId == "" || pass == "") {
            return false;
        }
        
        //设置用户
        xmppStream!.myJID = XMPPJID.jidWithString(userId)
        //设置服务器
        xmppStream!.hostName = server
        //xmppStream!.hostPort = 5222
        //密码
        password = pass;
        
        //连接服务器
        var error:NSError? ;
        if (!xmppStream!.connectWithTimeout(timeOut,error: &error)) {
            println("cannot connect \(server)")
            return false;
        }
        println("connect success!!!")
        return true;
        
    }
    
    func disconnect(){
        
        self.goOffline()
        xmppStream!.disconnect()
        isOpen = false
    }
    
    //发送数据XMl
    func sendElement(mes:DDXMLElement){
        xmppStream!.sendElement(mes)
    }
    
    //XMPPStreamDelegate协议实现
    //连接服务器
    func xmppStreamDidConnect(sender:XMPPStream ){
        println("xmppStreamDidConnect \(xmppStream!.isConnected())")
        isOpen = true;
        var error:NSError?
        xmppStream!.authenticateWithPassword(password ,error:&error);
        if error != nil {
            println(error!)
        }
    }
    
    //验证通过
    func xmppStreamDidAuthenticate(sender:XMPPStream ){
        println("xmppStreamDidAuthenticate")
        self.goOnline()
        loginFlag=1
    }
    
    func xmppStream(sender:XMPPStream , didNotAuthenticate error:DDXMLElement ){
        loginFlag=2
    }
    
    //收到消息
    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
        
        
        if message != nil {
//            println(message)
            var sub:String = message!.elementForName("subject").stringValue();
            var cont:String = message!.elementForName("body").stringValue();
            var from:String = message!.attributeForName("from").stringValue();
            
            var msg:Message = Message(subject:sub,content:cont,sender:from,ctime:getCurrentTime())
            
            
            //消息委托(这个后面讲)
            _messageDelegate?.newMessageReceived(msg);
        }
        
    }
    
    //收到好友状态
    func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
        
        println(presence)
        
        //取得好友状态
        var presenceType:NSString = presence.type() //online/offline
        //当前用户
        var userId:NSString  = sender.myJID.user;
        //在线用户
        var presenceFromUser:NSString  = presence.from().user;
        
        if (!presenceFromUser.isEqualToString(userId as String)) {
            
            //在线状态
            var srv:String = "macshare.local"
            if (presenceType.isEqualToString("available")) {
                
                //用户列表委托
                //chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(srv)")
                
            }else if (presenceType.isEqualToString("unavailable")) {
                //用户列表委托
//                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(srv)")
            }
            
        }
        
    }

}