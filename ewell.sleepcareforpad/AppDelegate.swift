//
//  AppDelegate.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {
    
    var window: UIWindow?
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    var isBackRun:Bool = false
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //延时启动界面
        NSThread.sleepForTimeInterval(1)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            deviceType = "iphone"
            //设置启动界面
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            
            self.window!.rootViewController = UINavigationController(rootViewController:ILoginController(nibName:"ILogin", bundle:nil))
        }
        else if (UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            
            //设置消息推送
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
            
            //隐藏状态栏
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            
            //设置启动界面
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            
            self.window!.rootViewController = UINavigationController(rootViewController:LoginController(nibName:"LoginView", bundle:nil))
        }
        
        InitPlistFile()
        
        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return (Int)(UIInterfaceOrientationMask.Portrait.rawValue)
        }
        
        return (Int)(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        var todoItems: [TodoItem] = TodoList.sharedInstance.allItems() // retrieve list of all to-do items
        var overdueItems = todoItems.filter({ (todoItem) -> Bool in
            return todoItem.deadline.compare(NSDate()) != .OrderedDescending
        })
        UIApplication.sharedApplication().applicationIconBadgeNumber = overdueItems.count
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        self.isBackRun = true
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果要后台运行
        //注册后台任务
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
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        if(xmppMsgManager?.isInstance == true){
            let isLogin = xmppMsgManager!.Connect()
            if(!isLogin){
                showDialogMsg("远程通讯服务器连接不上，请关闭重新登录！")
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().postNotificationName("WarningClose", object: self)
    }
    
    func application(application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification) {
            if(self.isBackRun){
                NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
                self.isBackRun = false
            }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void){
        
    }
}


