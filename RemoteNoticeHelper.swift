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
     if (UIDevice.currentDevice().systemVersion.compare( "10.0.0" , options: NSStringCompareOptions.NumericSearch) == .OrderedAscending){
    //ios <8.0
    if  UIDevice.currentDevice().systemVersion.compare( "8.0.0" , options: NSStringCompareOptions.NumericSearch) == .OrderedAscending{
        if PLISTHELPER.FirstLaunch == "true"{
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Badge)
            
            PLISTHELPER.FirstLaunch = "false"
        }
        else{
            if   UIApplication.sharedApplication().enabledRemoteNotificationTypes() ==  UIRemoteNotificationType.None
            {
                CloseNotice()
            }
            else{
                OpenNotice()
            }
        }
        
    }
        //>= ios8.0
    else{
        
        //首次启动app，要弹窗提示是否接受通知
        if PLISTHELPER.FirstLaunch == "true"{
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        
            PLISTHELPER.FirstLaunch = "false"
            
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
    }
     else{
    print("ios10+++++++++++++++++++++register\n")
        if PLISTHELPER.FirstLaunch == "true"{
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
            
            PLISTHELPER.FirstLaunch = "false"
            
        }
        else {
             var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
             if (token == nil){
         UIApplication.sharedApplication().registerForRemoteNotifications()
            }
        }
    }
}



//开启通知（登陆后调用）
func OpenNotice(){
    try {
        ({
            
            if ( LOGINFLAG){
                var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
                if (token != nil){
                    
                    //<ios10
                    if (UIDevice.currentDevice().systemVersion.compare( "10.0.0" , options: NSStringCompareOptions.NumericSearch) == .OrderedAscending){
                   //<8.0
                     if (UIDevice.currentDevice().systemVersion.compare( "8.0.0" , options: NSStringCompareOptions.NumericSearch) == .OrderedAscending){
                        if(UIApplication.sharedApplication().enabledRemoteNotificationTypes() !=  UIRemoteNotificationType.None){
                            SleepCareForIPhoneBussiness().OpenNotification(token!, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                        }
                    }
                        //8.0-10.0
                    else {
                        if(UIApplication.sharedApplication().currentUserNotificationSettings().types !=  UIUserNotificationType.None){
                            SleepCareForIPhoneBussiness().OpenNotification(token!, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                        }
                    }
                    }
                        //>=ios10.0
                    else{
                    print("ios10!!!!!!!!!!!!!!!!!!!!!!!\n")
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
           
            if LOGINFLAG{
                var token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
                if token != nil{
                    SleepCareForIPhoneBussiness().CloseNotification(token!, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                }
                //                }
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
