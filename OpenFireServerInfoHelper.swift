//
//  GetServerInfoHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 2/17/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class OpenFireServerInfoHelper: NSObject,NSURLConnectionDataDelegate {
    
    /**
    先从网站拉取服务器连接信息，不成功则从本地plist文件读取服务器连接信息。
    returns: 返回是否操作成功,布尔类型
    */
    
    private var backActionHandler: (() -> ())?
   
    init(_backActionHandler: () -> ()) {
        backActionHandler = _backActionHandler
    }
    
    func CheckServerInfo(){
        
        let urlPath: String = "http://usleepcare.com/app/getApp.aspx"
        let url: NSURL = NSURL(string: urlPath)!
        let request:NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        NSURLConnection(request: request, delegate: self)
       
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError){
    
        if(backActionHandler != nil){
            backActionHandler!()
        }
    }

    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dic : NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
        if dic != nil{
            var apInfo:NSDictionary? = dic!.objectForKey("apinfo") as? NSDictionary
            if apInfo != nil{
                var ip:String? = apInfo!.objectForKey("IP") as? String
                var port:Int? = apInfo!.objectForKey("OpenFirePort") as? Int
                var server:String? =  apInfo!.objectForKey("ServerID") as? String
                var pwd:String? = apInfo!.objectForKey("PWD") as? String
                var username:String? = apInfo!.objectForKey("UserName") as? String

                
                
                if (ip != nil && port != nil && server != nil && pwd != nil && username != nil){
                    SetValueIntoPlist(SERVER,ip!)
                    SetValueIntoPlist(PORT,String(port!) )
                    SetValueIntoPlist(SERVERJID, server!)
                    SetValueIntoPlist(PASS, pwd!)
                    SetValueIntoPlist(USERID, username! + "@" + ip!)
                }
                
            }
        }
        
        if(backActionHandler != nil){
            backActionHandler!()
        }
        
        
    }
    
    //获取server数据失败，显示提示信息
    func GetServerInfoFail(){
        SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.ConnectOpenfireFail), subTitle:"提示", style: AlertStyle.None,buttonTitle:"关闭",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"重试连接", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: ConnectAgain)
    }
    
    func ConnectAgain(isOtherButton: Bool){
        if !isOtherButton{
            CheckServerInfo()
        }
    }
    
}