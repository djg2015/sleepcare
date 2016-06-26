//
//  UpdateHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/4/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class UpdateHelper:NSObject,UIAlertViewDelegate,NSURLConnectionDataDelegate{
    
    private static var updateInstance: UpdateHelper? = nil
    var currentVersion:String?
    var recervedData:NSMutableData?
    var alartDelegate:UIAlertViewDelegate?
    var connectionDelegate:NSURLConnectionDataDelegate?
    var newversionURL:String! = ""
    
    //获取当前对象
    class func GetUpdateInstance()->UpdateHelper{
        if self.updateInstance == nil {
            self.updateInstance = UpdateHelper()
             self.updateInstance!.alartDelegate = self.updateInstance
             self.updateInstance!.connectionDelegate = self.updateInstance
             self.updateInstance!.recervedData = NSMutableData()
        //    self.updateInstance!.PrepareConnection()
        }
        return self.updateInstance!
    }
    
    //检查sleepcare.plist里updatedate的值和当前时间哪个大（格式yyyy-MM-dd）,返回true需要检查更新
    func CheckLocalUpdateDate(curupdate:String)->Bool{
        var localupdate = GetValueFromPlist("updatedate","sleepcare.plist")
        if localupdate == "" {
            //首次安装登录,不用更新
        return false
        }
               if localupdate < curupdate{
            return true
        }
        
        return false
    }

    
    //发送请求到app store
    func PrepareConnection(){
        //精确查找
        var stringURL = "http://itunes.apple.com/cn/lookup?id=1101021028"
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
        self.CheckUpdate()
    }
    
    
    func ChooseToUpdate(isOtherButton: Bool){
        if !isOtherButton{
            var url = NSURL(string: newversionURL)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    
    
    func CheckUpdate(){
        //本地version号
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        self.currentVersion = infoDict.objectForKey("CFBundleShortVersionString") as? String
        println("currentVersion = \(currentVersion)")
        
        //app store version号
        var dic : NSDictionary? = NSJSONSerialization.JSONObjectWithData(recervedData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
        var infoArray : NSArray? = dic?.objectForKey("results") as? NSArray
        
        if infoArray?.count > 0 {
            var releaseInfo : NSDictionary = infoArray?.objectAtIndex(0) as! NSDictionary
            self.newversionURL = releaseInfo.objectForKey("trackViewUrl")  as! String
            var appstoreVersion : String = releaseInfo.objectForKey("version") as! String
            println("appstoreVersion = \(appstoreVersion)")
            
            if (self.currentVersion!  < appstoreVersion) {
                SweetAlert(contentHeight: 300).showAlert("检测到新版本，是否前往App Store更新？", subTitle:"更新提示", style: AlertStyle.None,buttonTitle:"下次再说",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"更新", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: UpdateHelper.GetUpdateInstance().ChooseToUpdate)
           
            }
                
           
        }

    }
    
}