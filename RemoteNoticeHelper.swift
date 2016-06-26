//
//  RemoteNoticeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/11/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation


//每次从后台进入前台时检查是否要开启／关闭通知
func CheckRemoteNotice(){
    
    //首次启动app，要弹窗提示是否接受通知
    if GetValueFromPlist("firstLaunch","sleepcare.plist") == "true"{
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        SetValueIntoPlist("firstLaunch","false")
        
    }
        //非首次登录
    else {
        
    
            //不要接收通知
            if   UIApplication.sharedApplication().currentUserNotificationSettings().types ==  UIUserNotificationType.None
            {
                //已注册，1取消注册，2若已登陆关闭消息通知
                if UIApplication.sharedApplication().isRegisteredForRemoteNotifications(){
                    UIApplication.sharedApplication().unregisterForRemoteNotifications()
                    CloseNotice()
                }
            }
                
                //需要开启通知
            else{
                //未注册过，则注册远程通知
                if (!UIApplication.sharedApplication().isRegisteredForRemoteNotifications()){
                    UIApplication.sharedApplication().registerForRemoteNotifications()
                    
                }
            }
    }
}



//开启通知（登陆后调用）
func OpenNotice(){
    try {
        ({
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            let isconnect = xmppMsgManager!.Connect()
            
            if(isconnect){
                if LOGINFLAG{
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
                    if token != nil{
             SleepCareForSingle().OpenNotification(token!, loginName: SessionForSingle.GetSession()!.User!.LoginName)
                    }
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

//关闭通知
func CloseNotice(){
    try {
        ({
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            let isconnect = xmppMsgManager!.Connect()
            
            if(isconnect){
                if LOGINFLAG{
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
                    if token != nil{
                        SleepCareForSingle().CloseNotification(token!, loginName: SessionForSingle.GetSession()!.User!.LoginName)
                    }
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
