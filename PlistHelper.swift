//
//  PlistHelper.swift
//  plistTest
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 Qinyuan Liu. All rights reserved.
//

import Foundation

var fileManager = NSFileManager.defaultManager()
let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
//存放本地plist文件的路径
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
        //fileManager.removeItemAtPath(path, error: nil)
    }
    sleepcareResultDictionary = NSMutableDictionary(contentsOfFile: path)
    //println("Loaded sleepcare.plist file is --> \(sleepcareResultDictionary?.description)")
}
//读取theme元素
func GetValueFromThemePlist(theme:String,key:String,filename:String) ->String{
    var path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
    var fileManager = NSFileManager.defaultManager()
    var fileExists:Bool = fileManager.fileExistsAtPath(path!)
    var themeDic :NSMutableDictionary?
    if(fileExists){
        themeDic=NSMutableDictionary(contentsOfFile: path!)
        let themeInfo = themeDic?.valueForKey(theme) as! NSMutableDictionary
        let themeItem = themeInfo.valueForKey(key) as! String
        return themeItem
    }
    return ""
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
    var ip =  GetValueFromPlist("IP","sleepcare.plist")
    var port =  GetValueFromPlist("OpenFirePort","sleepcare.plist")
    var pwd =  GetValueFromPlist("PWD","sleepcare.plist")
    var server =  GetValueFromPlist("ServerID","sleepcare.plist")
    
    if (ip=="" || port=="" || pwd=="" || server=="" ){
        return true
    }
    return false
}

