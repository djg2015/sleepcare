//
//  JasonHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/11/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class JasonHelper: NSObject {
    private static var jasonInstance: JasonHelper? = nil
    var data:  NSData?  = nil//保存每次获得的数据
    var json: AnyObject? = nil
    var apInfo: AnyObject? = nil
    var connection: NSURLConnection?
    var serverInfo:ServerSetingInfo?
    
    //创建单例
    class func GetJasonInstance()->JasonHelper{
        if self.jasonInstance == nil {
            self.jasonInstance = JasonHelper()
        }
        return self.jasonInstance!
    }
    
    //从url成功获取json数据，返回true
    func ConnectJason()->Bool{
        
        let urlPath: String = "http://usleepcare.com/app/getApp.aspx"
        var url: NSURL = NSURL(string: urlPath)!
        self.data = NSData(contentsOfURL: url)
        
        if self.data != nil{
            var str = NSString(data: self.data!, encoding: NSUTF8StringEncoding)
            self.json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            if self.json != nil{
            self.apInfo = self.json!.objectForKey("apinfo")
                if self.apInfo != nil{
                   return true
                }
            }
        }
        return false
    }
    
    //将json数据转换为class对象，若出现值为nil，则返回false
    func GetFromJsonData()->Bool{
        if self.apInfo != nil{
            var ip:String? = self.apInfo!.objectForKey("IP") as? String
            var port:Int? = self.apInfo!.objectForKey("OpenFirePort") as? Int
            var server:String? =  self.apInfo!.objectForKey("ServerID") as? String
            var user:String? =  self.apInfo!.objectForKey("UserName") as? String
            var pwd:String? = self.apInfo!.objectForKey("PWD") as? String
            
            if (ip==nil || port==nil || server==nil || pwd==nil || user==nil){
                return false
            }
            self.serverInfo = ServerSetingInfo(ip:ip!, port:String(port!), server:server!,ipadUser:user!, ipadpwd:pwd!)
        }
        return true
    }
    
    //写入本地plist文件
    func SetJsonDataToPlistFile(){
        if self.serverInfo != nil{
            SetValueIntoPlist("xmppserver", self.serverInfo!.IP!)
            SetValueIntoPlist("xmppport", self.serverInfo!.OpenFirePort!)
            SetValueIntoPlist("xmppuserpwd", self.serverInfo!.ipadpwd!)
            SetValueIntoPlist("serverjid", self.serverInfo!.ServerID!)
            SetValueIntoPlist("xmppusername", self.serverInfo!.ipadUser!)
        }
    }
    
    func CloseJason(){
        // self.connection!.cancel()
        self.data = nil
        self.json = nil
        self.serverInfo = nil
    }
}

class ServerSetingInfo{
    var IP:String?
    var OpenFirePort:String?
    var ServerID:String?
    var ipadUser:String?
    var ipadpwd:String?
    
    init(ip:String, port:String, server:String, ipadUser:String, ipadpwd:String){
        self.IP = ip
        self.OpenFirePort = port
        self.ServerID = server
        self.ipadUser = ipadUser + "@" + ip
        self.ipadpwd = ipadpwd
       
    }
}