//
//  Const.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

 // 放常量
import Foundation


//是否成功登陆的标志
var LOGINFLAG:Bool = false

//主题颜色
let DEFAULTCOLOR = UIColor.colorFromRGB(0x2052AA)
let BLACKCOLOR = UIColor.colorFromRGB(0x1F222C)
var themeName:String = "default"
var themeColor:Dictionary<String,UIColor> = ["default": DEFAULTCOLOR,"black": BLACKCOLOR]

//sleepcare.plist文件读取,jasonHelper
let USERID:String = "xmppusername"
let USERIDPHONE:String = "xmppusernamephone"
let PASS:String = "xmppuserpwd"
let SERVER:String = "xmppserver"
let PORT:String = "xmppport"
let SERVERJID:String = "serverjid"

//plistHelper
var fileManager = NSFileManager.defaultManager()
let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
var documentsDirectory:String!
var sleepcareResultDictionary:NSMutableDictionary?

//
var deviceType:String = "iphone"