//
//  PlistHelper.swift
//  plistTest
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 Qinyuan Liu. All rights reserved.
//

import Foundation




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


//只读plist文件值
func GetValueFromReadOnlyPlist(key:String,filename:String) ->String{
        var path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        var fileManager = NSFileManager.defaultManager()
        var fileExists:Bool = fileManager.fileExistsAtPath(path!)
        var data :NSMutableDictionary?
        if(fileExists){
            data=NSMutableDictionary(contentsOfFile: path!)
            return data?.valueForKey(key) as! String
        }
        return ""
}

//从本地plist读取键值
func GetValueFromPlist(key:String,filename:String) -> String{
    let path = documentsDirectory.stringByAppendingPathComponent(filename)
    if fileManager.fileExistsAtPath(path) {
       
        var value: AnyObject? = NSMutableDictionary(contentsOfFile: path)!.valueForKey(key)
        if value != nil{
            return value as! String
        }
    } else {
        println("WARNING: sleepcare.plist doesn't exist! return 空!")
    }
    return ""
    
}

//写本地plist键值
func SetValueIntoPlist(key:String, value:String){
    let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
    sleepcareResultDictionary!.setValue(value, forKey: key)
    sleepcareResultDictionary!.writeToFile(path, atomically: false)
   
}

//判断和server有关的信息是否为空
func IsPlistDataEmpty()->Bool{
    var ip =  GetValueFromPlist("xmppserver","sleepcare.plist")
    var port =  GetValueFromPlist("xmppport","sleepcare.plist")
    var server =  GetValueFromPlist("serverjid","sleepcare.plist")
    
    var ipaduser = GetValueFromPlist("xmppusername","sleepcare.plist")
    var ipadpwd = GetValueFromPlist("xmppuserpwd","sleepcare.plist")
    
    if (ip=="" || port=="" ||  server=="" || ipaduser=="" || ipadpwd==""){
        return true
    }
    return false
}

