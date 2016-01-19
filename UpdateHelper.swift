//
//  UpdateHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/4/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class UpdateHelper:NSObject,NSURLConnectionDataDelegate{
    
    private static var updateInstance: UpdateHelper? = nil
    var currentVersion:String?
    var recervedData:NSMutableData?
   // var alartDelegate:UIAlertViewDelegate?
    var connectionDelegate:NSURLConnectionDataDelegate?
    var newversionURL:String! = ""
    
    //获取当前对象
    class func GetUpdateInstance()->UpdateHelper{
        if self.updateInstance == nil {
            self.updateInstance = UpdateHelper()
           //  self.updateInstance!.alartDelegate = self.updateInstance
             self.updateInstance!.connectionDelegate = self.updateInstance
             self.updateInstance!.recervedData = NSMutableData()
        //    self.updateInstance!.PrepareConnection()
        }
        return self.updateInstance!
    }
    //发送请求到app store
    func PrepareConnection(){
        //精确查找
        var stringURL = "http://itunes.apple.com/cn/lookup?id=1035212386"
        //模糊查找
        // var stringURL = "http://itunes.apple.com/search?term=智能床&entity=software"
        //如果程序中有非英文名称，需要转码
        stringURL=stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var URL = NSURL(string: stringURL)
        var request = NSURLRequest(URL: URL!)
        NSURLConnection(request: request, delegate: self)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        recervedData?.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        recervedData?.appendData(data)
    }
    
    //获取store中最新版本号，对比本地版本号，判断是否需要更新
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.CheckUpdate(false)
    }

    
    //检查sleepcare.plist里updatedate的值和当前时间哪个大（格式yyyy-MM-dd）,true：updatedate< curdate
    func CheckLocalUpdateDate(curupdate:String)->Bool{
        var localupdate = GetValueFromPlist("updatedate","sleepcare.plist")
        if localupdate == "" {
        return true
        }
               if localupdate < curupdate{
            return true
        }
        
        return false
    }
    
    //发送请求到app store，并返回当前app的版本号
    func LocalAppVersion()->String{
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        self.currentVersion = infoDict.objectForKey("CFBundleShortVersionString") as? String
        println("currentVersion = \(currentVersion)")
        
        if self.currentVersion == nil{
            return ""
        }
        return self.currentVersion!
    }
    
    func CheckUpdate(dailyCheckFlag:Bool){
        var dic : NSDictionary? = NSJSONSerialization.JSONObjectWithData(recervedData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
        var infoArray : NSArray? = dic?.objectForKey("results") as? NSArray
        
        if infoArray?.count > 0 {
            var releaseInfo : NSDictionary = infoArray?.objectAtIndex(0) as! NSDictionary
            self.newversionURL = releaseInfo.objectForKey("trackViewUrl")  as! String
            var appstoreVersion : String = releaseInfo.objectForKey("version") as! String
            println("appstoreVersion = \(appstoreVersion)")
            
            if (self.currentVersion!  < appstoreVersion) {
                SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.NeedUpdate), subTitle:"提示", style: AlertStyle.None,buttonTitle:"下次再说",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"马上更新", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: UpdateHelper.GetUpdateInstance().ChooseToUpdate)

            }
                
            else{
                if !dailyCheckFlag{
                 SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.DontNeedUpdate), subTitle:"提示", style: AlertStyle.None,buttonTitle:"确认",buttonColor: UIColor.colorFromRGB(0xAEDEF4))
               }
            }
        }

    }
    
    func ChooseToUpdate(isOtherButton: Bool){
        if !isOtherButton{
            var url = NSURL(string: newversionURL)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
//    //选择更新，则跳转store的下载页面
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        if alertView.tag == 10000{
//            if buttonIndex == 1 {
//                var url = NSURL(string: newversionURL)
//                UIApplication.sharedApplication().openURL(url!)
//                
//            }
//        }
//    }
    
}