//
//  AppDelegate.swift
//  test
//
//  Created by Qinyuan Liu on 6/1/16.
//  Copyright (c) 2016 Qinyuan Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,XMPPStreamDelegate{
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    var isBackRun:Bool = false
    var window: UIWindow?
    
    //1由not running状态切换到inactive状态,程序初始化
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //延时启动界面
        NSThread.sleepForTimeInterval(1)
        //初始化plist文件
        PLISTHELPER = PlistHelper()
        PLISTHELPER.InitPlistFile()
        
        //读取sleepcare.plist文件到本地
         PLISTHELPER.GetValueFromSleepcarePlist()
        //读取Message.plist到本地
        PLISTHELPER.GetValueFromMessagePlist()
        

        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         self.isBackRun = true
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果要后台运行,注册后台任务
        self.backgroundTask = application.beginBackgroundTaskWithExpirationHandler({
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    //2由inactive状态切换到active状态
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //远程消息设置
        CheckRemoteNotice()
        //日更新提示
        var curUpdate = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
        var updateflag = UpdateHelper.GetUpdateInstance().CheckLocalUpdateDate(curUpdate)
        //更新本地sleepcare.plist文件里updatedate
       PLISTHELPER.UpdateDate = curUpdate
        //SetValueIntoPlist("updatedate",curUpdate)
        
        if updateflag{
            UpdateHelper.GetUpdateInstance().PrepareConnection()
            //本地version对比store里最新的version大小
            UpdateHelper.GetUpdateInstance().CheckUpdate()
        }
        
        
        self.isBackRun = false
        if currentController != nil{
            currentController.viewWillAppear(true)
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().postNotificationName("WarningClose", object: self)
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        
        return (Int)(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    //接收本地通知
    func application(application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification) {
            if(self.isBackRun){
                
                self.isBackRun = false
            }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void){
        
    }
    
    //接收远程推送通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //  println("userInfo = \(userInfo)")
        /* eg.
        userInfo = [aps:{
        alert: "???????"
        sound = default
        }]
        */
        
        //        let Info = (userInfo as NSDictionary).objectForKey("aps") as! NSDictionary
        //        let alert = UIAlertView(title: "remote notification", message: Info.objectForKey("alert") as? String, delegate: nil, cancelButtonTitle: "ok")
        //        alert.show()
        
        //后台点击通知,   若已登陆且报警页面未打开，则跳转报警页面
        if self.isBackRun{
            
                    NSNotificationCenter.defaultCenter().postNotificationName("OpenAlarmView", object: self)
         
        }
    }

    //成功注册通知后，获取device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        println("token==\(token)")
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "DeviceToken")
        
        OpenNotice()
        
    }
    
    //当推送注册失败时
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }

}

