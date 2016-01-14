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
    var documentsDirectory:String!
    var resultDictionary:NSMutableDictionary?
   
     //初始化，载入默认数据
    func InitPlistFile(){
        // getting path to sleepcare.plist
        documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")

        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("sleepcare", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
              //  println("Bundle sleepcare.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy plist file from bundle file")
            }
            else {
                println("local sleepcare.plist file not found.")
            }
        }
        else {
            println("sleepcare.plist already exits.")
        //   fileManager.removeItemAtPath(path, error: nil)
        }
        
        resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded sleepcare.plist file is --> \(resultDictionary?.description)")
    }
    
//从plist读取键值
    func GetValueFromPlist(key:String) -> String?{
        let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
        if fileManager.fileExistsAtPath(path) {
         //   println("loaded value")
           return NSMutableDictionary(contentsOfFile: path)!.valueForKey(key) as? String
            
        } else {
            println("WARNING: sleepcare.plist doesn't exist! return 空!")
        }
        return ""
     
}

//写plist键值
    func SetValueIntoPlist(key:String, value:String){
        let path = documentsDirectory.stringByAppendingPathComponent("sleepcare.plist")
        resultDictionary!.setValue(value, forKey: key)
        resultDictionary!.writeToFile(path, atomically: false)
      //  println("Saved sleepcare.plist file is --> \(resultDictionary?.description)")
    }
    
//判断和server有关的信息是否为空
func IsPlistDataEmpty()->Bool{
    var ip =  GetValueFromPlist("IP")
    var port =  GetValueFromPlist("OpenFirePort")
    var pwd =  GetValueFromPlist("PWD")
    var server =  GetValueFromPlist("ServerID")
    var user =  GetValueFromPlist("UserName")
    
    if (ip==nil || port==nil || pwd==nil || server==nil || user==nil){
    return true
    }
    return false
}

