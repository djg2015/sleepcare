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
    var newversionURL:String?
    //获取当前对象
    class func GetUpdateInstance()->UpdateHelper{
        if self.updateInstance == nil {
            self.updateInstance = UpdateHelper()
             self.updateInstance!.alartDelegate = self.updateInstance
             self.updateInstance!.connectionDelegate = self.updateInstance
             self.updateInstance!.recervedData = NSMutableData()
        }
        return self.updateInstance!
    }
    
    //返回当前app的版本号
    func dealVersion()->String{
        
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        self.currentVersion = infoDict.objectForKey("CFBundleShortVersionString") as? String
        println("currentVersion = \(currentVersion)")
       
        
        //精确查找 
        //  var stringURL = "http://itunes.apple.com/cn/lookup?id=1035212386"
        //模糊查找
        var stringURL = "http://itunes.apple.com/search?term=智能床&entity=software"
        //如果程序中有非英文名称，需要转码
        stringURL=stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var URL = NSURL(string: stringURL)
        
        var request = NSURLRequest(URL: URL!)
        NSURLConnection(request: request, delegate: self)
        
        if self.currentVersion == nil{
            return ""
        }
        return self.currentVersion!
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
    
    func CheckUpdate(){
        var dic : NSDictionary? = NSJSONSerialization.JSONObjectWithData(recervedData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
        var infoArray : NSArray? = dic?.objectForKey("results") as? NSArray
        
        if infoArray?.count > 0 {
            var releaseInfo : NSDictionary = infoArray?.objectAtIndex(0) as! NSDictionary
            self.newversionURL = releaseInfo.objectForKey("trackViewUrl") as? String
            var lastVersion : NSString = releaseInfo.objectForKey("version") as! NSString
            println("lastVersion = \(lastVersion)")
            
            if ((self.currentVersion! as NSString).floatValue < lastVersion.floatValue){
                var alertView = UIAlertView(title: "更新", message: "有新版本更新，是否前往更新？", delegate: self.alartDelegate!, cancelButtonTitle: "关闭", otherButtonTitles: "更新")
                alertView.tag = 10000
                alertView.show()
                
            }
                
            else{
                var alertView = UIAlertView(title: "更新", message: "此版本为最新版本", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = 10001
                alertView.show()
            }
        }

    }
    
    //选择更新，则跳转store的下载页面
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 10000{
            if buttonIndex == 1 {
                var url = NSURL(string: newversionURL!)
                UIApplication.sharedApplication().openURL(url!)
                
            }
        }
    }
    
}