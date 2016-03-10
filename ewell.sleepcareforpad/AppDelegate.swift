//
//  AppDelegate.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//


import UIKit

var noticeFlag:Bool = false
{
 didSet{
    if (UIApplication.sharedApplication().isRegisteredForRemoteNotifications()){
       //如果已登陆,注册通知
        if LOGINFLAG {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))

        }
    }
    else{
        if LOGINFLAG{
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            let isconnect = xmppMsgManager!.Connect()
            if(isconnect){
                if deviceType == "iphone"{
                let token =  NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as! String
                //已登陆， 关闭通知
            BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").CloseNotification(token, loginName: SessionForIphone.GetSession()!.User!.LoginName)
                }
            }
        }
    }
}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {
    
    var window: UIWindow?
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    var isBackRun:Bool = false
    
    //1由not running状态切换到inactive状态,程序初始化
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //延时启动界面
        NSThread.sleepForTimeInterval(1)
        
        InitPlistFile()
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            deviceType = "iphone"
            //设置启动界面
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()

            let logincontroller = ILoginController(nibName:"ILogin", bundle:nil)
            let rootcontroller =  UINavigationController(rootViewController: logincontroller)
            self.window!.rootViewController = rootcontroller
            IViewControllerManager.GetInstance()!.SetRootController(logincontroller)
        }
        else if (UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            deviceType = "ipad"
            //隐藏状态栏
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            
            //设置启动界面
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            self.window!.rootViewController = UINavigationController(rootViewController:LoginController(nibName:"LoginView", bundle:nil))
        }
                
        //判断是否由远程消息通知触发应用程序启动
       if ((launchOptions) != nil && deviceType == "iphone") {
            //                    //获取应用程序消息通知标记数（即小红圈中的数字）
            //                    var badge = UIApplication.sharedApplication().applicationIconBadgeNumber;
            //                    if (badge>0) {
            //                        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            //                        badge = badge - 1
            //                        //清除标记。
            //                        UIApplication.sharedApplication().applicationIconBadgeNumber = badge;
//            let Info = launchOptions! as NSDictionary
//            let pushInfo = Info.objectForKey("UIApplicationLaunchOptionsRemoteNotificationKey") as! NSDictionary
//            //获取推送详情
//            var pushString = pushInfo.objectForKey("aps") as! String
            let alert = UIAlertView(title: "报警信息提示", message: "请点击一个老人后，到[我] ->［报警信息］下查看", delegate: nil, cancelButtonTitle: "确认")
            alert.show()
           }
  //      }
        return true
    }
    
    //2由inactive状态切换到active状态
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (UIApplication.sharedApplication().isRegisteredForRemoteNotifications()){
            if !noticeFlag{
            noticeFlag = true
            }
        }else{
            if noticeFlag{
            noticeFlag = false
            }
        }
        
        
        //iphone
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            if(xmppMsgManager?.isInstance == true){
                let isLogin = xmppMsgManager!.Connect()
                if(!isLogin){
                    //无法连接，弹窗提示是否重连
                    NSNotificationCenter.defaultCenter().postNotificationName("ReConnectInternetForPhone", object: self)
                }
                else{
                    
                    var curUpdate = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
                    
                    var updateflag = UpdateHelper.GetUpdateInstance().CheckLocalUpdateDate(curUpdate)
                    if updateflag{
                        UpdateHelper.GetUpdateInstance().PrepareConnection()
                        UpdateHelper.GetUpdateInstance().LocalAppVersion()
                        //更新本地sleepcare.plist文件里updatedate
                        SetValueIntoPlist("updatedate",curUpdate)
                        //本地version对比store里最新的version大小
                        UpdateHelper.GetUpdateInstance().CheckUpdate(true)
                    }
                }
            }
        }
            //ipad设备
        else{
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            if(xmppMsgManager?.isInstance == true){
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    //无法连接，弹窗提示是否重连
                    NSNotificationCenter.defaultCenter().postNotificationName("ReConnectInternetForPad", object: self)
                }
            }
        }
        
        self.isBackRun = false
    }
    
    
    //成功注册通知后，获取device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        var token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        println("token==\(token)")
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "DeviceToken")
        //068df3381f68a8bdca806926556daecc866dcfd90f31a0d2f7deea6ae1e9805c
        
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isconnect = xmppMsgManager!.Connect()
        //开启通知
        if(isconnect){
            //注册设备
            let dvtype = (deviceType == "iphone") ? "1" : "2"
            if deviceType == "iphone"{
            BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").RegistDevice(token, deviceType:dvtype)
            
           
           BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").OpenNotification(token, loginName: SessionForIphone.GetSession()!.User!.LoginName)
            }
        }
    }
    
    //当推送注册失败时
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //        var alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        //        alert.show()
    }
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return (Int)(UIInterfaceOrientationMask.Portrait.rawValue)
        }
        
        return (Int)(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
    }
    
    
    //3当切换到另一个App时，由状态active切换到inactive
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    //4然后从inactive状态切换到running状态
    func applicationDidEnterBackground(application: UIApplication) {
        self.isBackRun = true
        //按home键后执行，若当前页为Ialarmview，则关闭
        IViewControllerManager.GetInstance()!.IsCurrentAlarmView()
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
    
    
    //5切换回本来的App时，由running状态切换到inactive状态
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    //6 应用终止，保存上次终止时的重要用户信息
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().postNotificationName("WarningClose", object: self)
    }
    
    //接收本地通知
    func application(application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification) {
            if(self.isBackRun){
                //判断是否接收推送
                NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
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
        
        //若在后台，判断是否登陆，是则跳至报警页面
        if (self.isBackRun && LOGINFLAG && deviceType == "iphone") {
            let controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
            IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IAlarmView", reload: true)
        }
    }
}