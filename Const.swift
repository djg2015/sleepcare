//
//  Const.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

 // 放常量
import Foundation

let xmpp_Timeout:NSTimeInterval = 3000

//是否成功登陆的标志
var LOGINFLAG:Bool = false
//
var LOGIN:Bool = false

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

var deviceType:String = "iphone"

// let PNGreenColor = UIColor(red: 77.0 / 255.0 , green: 196.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
// let PNGreyColor = UIColor(red: 186.0 / 255.0 , green: 186.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
// let PNLightGreyColor = UIColor(red: 246.0 / 255.0 , green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
//let LOWCOLOR:UIColor = UIColor.colorFromRGB(0xEF8626)
//let MEDIUMCOLOR:UIColor = UIColor.colorFromRGB(0x44A355)
//let HIGHCOLOR:UIColor = UIColor.redColor()


//记录当前显示的页面controller：AlarmViewTag标志：当前是否是报警页面
var AlarmViewTag:Bool = false
var currentController:UIViewController!


//注册成功后自动登录的代理
var AutologinDelegate:AutoLoginAfterRegistDelegate!