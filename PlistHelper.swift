//
//  PlistHelper.swift
//  plistTest
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 Qinyuan Liu. All rights reserved.
//

import Foundation
class PlistHelper:NSObject{
//sleepcare.plit内数据
    var _serverJID:String = ""
    dynamic var ServerJID:String{
        get{
        return self._serverJID
        }
        set(value){
        self._serverJID = value
           self.SetValueIntoPlist("serverjid", value:self._serverJID)
        }
    }
    var _xmppServer:String = ""
    dynamic var XmppServer:String{
        get{
            return self._xmppServer
        }
        set(value){
            self._xmppServer = value
            self.SetValueIntoPlist("xmppserver", value:self._xmppServer)
        }
    }
    var _xmppPort:String = ""
    dynamic var XmppPort:String{
        get{
            return self._xmppPort
        }
        set(value){
            self._xmppPort = value
            self.SetValueIntoPlist("xmppport", value:self._xmppPort)
        }
    }
    var _xmppUsername:String = ""
    dynamic var XmppUsername:String{
        get{
            return self._xmppUsername
        }
        set(value){
            self._xmppUsername = value
            self.SetValueIntoPlist("xmppusername", value:self._xmppUsername)
        }
    }

    var _xmppUserpwd:String = ""
    dynamic var XmppUserpwd:String{
        get{
            return self._xmppUserpwd
        }
        set(value){
            self._xmppUserpwd = value
            self.SetValueIntoPlist("xmppuserpwd", value: self._xmppUserpwd)
        }
    }

    var _xmppUsernamePhone:String = ""
    dynamic var XmppUsernamePhone:String{
        get{
            return self._xmppUsernamePhone
        }
        set(value){
            self._xmppUsernamePhone = value
            self.SetValueIntoPlist("xmppusernamephone", value:self._xmppUsernamePhone)
        }
    }

    var _updateDate:String = ""
    dynamic var UpdateDate:String{
        get{
            return self._updateDate
        }
        set(value){
            self._updateDate = value
            self.SetValueIntoPlist("updatedate", value: self._updateDate)
        }
    }
    
    var _firstLaunch:String = ""
    dynamic var FirstLaunch:String{
        get{
            return self._firstLaunch
        }
        set(value){
            self._firstLaunch = value
            self.SetValueIntoPlist("firstLaunch", value:self._firstLaunch)
        }
    }
    
    var _curPatientCode:String = ""
    dynamic var CurPatientCode:String{
        get{
            return self._curPatientCode
        }
        set(value){
            self._curPatientCode = value
            self.SetValueIntoPlist("CurPatientCode", value:self._curPatientCode)
        }
    }

    var _curPatientName:String = ""
    dynamic var CurPatientName:String{
        get{
            return self._curPatientName
        }
        set(value){
            self._curPatientName = value
            self.SetValueIntoPlist("CurPatientName", value:self._curPatientName)
        }
    }

    var _loginTelephoneSingle:String = ""
    dynamic var LoginTelephoneSingle:String{
        get{
            return self._loginTelephoneSingle
        }
        set(value){
            self._loginTelephoneSingle = value
            self.SetValueIntoPlist("logintelephonesingle", value:self._loginTelephoneSingle)
        }
    }
    var _loginPwdSingle:String = ""
    dynamic var LoginPwdSingle:String{
        get{
            return self._loginPwdSingle
        }
        set(value){
            self._loginPwdSingle = value
            self.SetValueIntoPlist("loginpwdsingle", value:self._loginPwdSingle)
        }
    }
    var _isRegist:String = ""
    dynamic var IsRegist:String{
        get{
            return self._isRegist
        }
        set(value){
            self._isRegist = value
            self.SetValueIntoPlist("isRegist", value:self._isRegist)
        }
    }
    var _alarmNotice:String = ""
    dynamic var AlarmNotice:String{
        get{
            return self._alarmNotice
        }
        set(value){
            self._alarmNotice = value
            self.SetValueIntoPlist("alarmnotice", value:self._alarmNotice)
        }
    }
    

    //错误提示的文字信息
    var _messageList:Array<String> = Array<String>()
    dynamic var MessageList:Array<String>{
        get{
            return self._messageList
        }
        set(value){
            self._messageList = value
           
        }
    }
    

    //plistHelper
    var fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    var documentsDirectory:String!
    var sleepcareResultDictionary:NSMutableDictionary?

 
    
//初始化，载入默认数据
 func InitPlistFile(){
    documentsDirectory = paths[0] as! String
   let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
    
    //check if XXX.plist exists
    if(!fileManager.fileExistsAtPath(path)) {
        // If it doesn't, copy it from the default file in the Bundle
        if let bundlePath = NSBundle.mainBundle().pathForResource("sleepcare", ofType: "plist") {
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)

            fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            println("copy plist file from bundle file")
        }
        else {
            println("local sleepcare.plist file not found.")
        }
    }
    else {
        println("sleepcare.plist already exits.")
      //  fileManager.removeItemAtPath(path, error: nil)
    }
    sleepcareResultDictionary = NSMutableDictionary(contentsOfFile: path)
}




//从message.plist文件读值
//func GetValueFromReadOnlyPlist(key:String,filename:String) ->String{
//        var path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
//        var fileManager = NSFileManager.defaultManager()
//        var fileExists:Bool = fileManager.fileExistsAtPath(path!)
//        var data :NSMutableDictionary?
//        if(fileExists){
//            data=NSMutableDictionary(contentsOfFile: path!)
//            return data?.valueForKey(key) as! String
//        }
//        return ""
//}
    
    func GetValueFromMessagePlist(){
        var path = NSBundle.mainBundle().pathForResource("Message", ofType: "plist")
        var fileManager = NSFileManager.defaultManager()
        var fileExists:Bool = fileManager.fileExistsAtPath(path!)
        var data :NSMutableDictionary?
        if(fileExists){
         //   data=NSMutableDictionary(contentsOfFile: path!)
            //读取到messagelist
      
                for(var i = 1;i<35;i++){
                    let data: AnyObject? = NSMutableDictionary(contentsOfFile: path!)!.valueForKey(String(i))
                    var message = data == nil ? "" : data as! String
                    self._messageList.append(message)
                  //  print(message+"\n")
                }
           // return data?.valueForKey(key) as! String
        }

        else{
        println("WARNING: Message.plist doesn't exist! return 空!")
        }
    }
    
//
////从sleepcare.plist读取键值
//func GetValueFromPlist(key:String,filename:String) -> String{
//    let path = documentsDirectory.stringByAppendingPathComponent(filename)
//    if fileManager.fileExistsAtPath(path) {
//       
//        var value: AnyObject? = NSMutableDictionary(contentsOfFile: path)!.valueForKey(key)
//        if value != nil{
//            return value as! String
//        }
//    } else {
//        println("WARNING: sleepcare.plist doesn't exist! return 空!")
//    }
//    return ""
//    
//}

func GetValueFromSleepcarePlist(){
    let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
    if fileManager.fileExistsAtPath(path) {
        
        var value: AnyObject? = NSMutableDictionary(contentsOfFile: path)!.valueForKey("serverjid")
        self._serverJID = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("xmppserver")
        self._xmppServer = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("xmppport")
        self._xmppPort = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("xmppusername")
        self._xmppUsername = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("xmppuserpwd")
       self._xmppUserpwd = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("xmppusernamephone")
        self._xmppUsernamePhone = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("firstLaunch")
      self._firstLaunch = (value == nil) ? "" : (value as! String)
        
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("curPatientCode")
       self._curPatientCode = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("curPatientName")
        self._curPatientName = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("logintelephonesingle")
        self._loginTelephoneSingle = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("loginpwdsingle")
        self._loginPwdSingle = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("isRegist")
        self._isRegist = (value == nil) ? "" : (value as! String)
        value = NSMutableDictionary(contentsOfFile: path)!.valueForKey("alarmnotice")
        self._alarmNotice = (value == nil) ? "" : (value as! String)
        
//        print(SERVERJIDVALUE+"\n")
//        print(XMPPSERVERVALUE+"\n")
//         print(XMPPPORTVALUE+"\n")
//         print(XMPPUSERNAMEVALUE+"\n")
//         print(XMPPUSERPWDVALUE+"\n")
//         print(XMPPUSERNAMEPHONEVALUE+"\n")
//         print(FIRSTLAUNCHVALUE+"\n")
//         print(CURPATIENTNAMEVALUE+"\n")
//         print(CURPATIENTCODEVALUE+"\n")
//         print(LOGINTELEPHONESINGLEVALUE+"\n")
//         print(LOGINPWDSINGLEVALUE+"\n")
//         print(ISREGISTVALUE+"\n")
//         print(ALARMNOTICEVALUE+"\n")
      
    } else {
        println("WARNING: sleepcare.plist doesn't exist! return 空!")
    }
   
    
}


//写本地plist键值
func SetValueIntoPlist(key:String, value:String){
    let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
    sleepcareResultDictionary!.setValue(value, forKey: key)
    sleepcareResultDictionary!.writeToFile(path, atomically: false)
   
}

////判断和server有关的信息是否为空
//func IsPlistDataEmpty()->Bool{
//    var ip =  GetValueFromPlist("xmppserver","sleepcare.plist")
//    var port =  GetValueFromPlist("xmppport","sleepcare.plist")
//    var server =  GetValueFromPlist("serverjid","sleepcare.plist")
//    
//    var ipaduser = GetValueFromPlist("xmppusername","sleepcare.plist")
//    var ipadpwd = GetValueFromPlist("xmppuserpwd","sleepcare.plist")
//    
//    if (ip=="" || port=="" ||  server=="" || ipaduser=="" || ipadpwd==""){
//        return true
//    }
//    return false
//}

}