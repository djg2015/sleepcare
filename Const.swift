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
//是否开启报警弹窗的定时器
var AlarmTimerFlag:Bool = false

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

//hr,rr页面常量值定义
let selectunderlineWidth = (UIScreen.mainScreen().bounds.width-40)/3
let chartwidth = UIScreen.mainScreen().bounds.width
let chartheight = UIScreen.mainScreen().bounds.height/570*200
let selectColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let noselectColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
let outterCircleHeight = UIScreen.mainScreen().bounds.height/570*150
let innerCircleHeight = UIScreen.mainScreen().bounds.height/570*125
let startColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let centerColor = UIColor(red: 195/255, green: 114/255, blue: 168/255, alpha: 1.0)
let endColor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
let avgColor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
let defaultColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
let grayColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)


//sleep页面常量
let awakeColor = UIColor(red: 125/255, green: 249/255, blue: 60/255, alpha: 1.0)
let lightsleepColor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
let deepsleepColor = UIColor(red: 92/255, green: 130/255, blue: 245/255, alpha: 1.0)
let bigCircleHeight = UIScreen.mainScreen().bounds.height/570*183
let middleCircleHeight = UIScreen.mainScreen().bounds.height/570*154
let smallCircleHeight = UIScreen.mainScreen().bounds.height/570*127

//字体颜色
let textGraycolor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
let textBluecolor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)

//记录当前显示的页面controller：
var currentController:UIViewController!


//注册成功后自动登录的代理
var AutologinDelegate:AutoLoginAfterRegistDelegate!


//是否显示报警通知,默认开启true（通过设置可关闭，为false）
var AlarmNoticeFlag = true
