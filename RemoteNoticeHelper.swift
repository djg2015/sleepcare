//
//  RemoteNoticeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/11/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation


//  注册回调后用token，执行接口方法：注册设备，开启通知
func AfterRegisterWithToken(token:String){
    let dvtype = (deviceType == "iphone") ? "1" : "2"
    if deviceType == "iphone"{
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.Connect()
                //开启通知
                if(isconnect){
                    BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").RegistDevice(token, deviceType:dvtype)
                    if LOGINFLAG {
                        BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").OpenNotification(token, loginName: SessionForIphone.GetSession()!.User!.LoginName)
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
}

//每次从后台进入前台时检查是否要开启／关闭通知
func CheckRemoteNotice(){
    //不要接收通知
    if   UIApplication.sharedApplication().currentUserNotificationSettings().types ==  UIUserNotificationType.None
    {
        //首次启动app，要弹窗提示是否接受通知
        if GetValueFromPlist("firstLaunch","sleepcare.plist") == "true"{
           UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
          
            
        }
            //非首次登录
        else{
            //已注册，1取消注册，2若已登陆关闭消息通知
            if UIApplication.sharedApplication().isRegisteredForRemoteNotifications(){
                UIApplication.sharedApplication().unregisterForRemoteNotifications()
                //关闭通知
                
                    CloseNotice()
                
            }
        }
    }
    //需要开启通知
    else{
        //未注册过，则 1注册远程通知，2注册设备 3若登陆了，则开启通知
        if (!UIApplication.sharedApplication().isRegisteredForRemoteNotifications()){
            UIApplication.sharedApplication().registerForRemoteNotifications()
            //didRegisterForRemoteNotificationsWithDeviceToken里执行2，3
        }
    }
}

//开启通知（登陆后调用）
func OpenNotice(){
    try {
        ({
            if LOGINFLAG{
                var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
                if token != nil{
                    BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").OpenNotification(token!, loginName: SessionForIphone.GetSession()!.User!.LoginName)
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
               BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").CloseNotification(token!, loginName: SessionForIphone.GetSession()!.User!.LoginName)
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
