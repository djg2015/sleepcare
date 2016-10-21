//
//  Const.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/8/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

 // 放常量
import Foundation

var xmpp_Timeout:NSTimeInterval = 3000
//是否成功登陆的标志
var LOGINFLAG:Bool = false


//sleepcare.plist文件读取,jasonHelper
let USERID:String = "xmppusername"
let USERIDPHONE:String = "xmppusernamephone"
let PASS:String = "xmppuserpwd"
let SERVER:String = "xmppserver"
let PORT:String = "xmppport"
let SERVERJID:String = "serverjid"

//是否显示报警通知,默认开启true（通过设置可关闭，为false）
var AlarmNoticeFlag = true

let SCREENWIDTH = UIScreen.mainScreen().bounds.width
let SCREENHIGHT = UIScreen.mainScreen().bounds.height

//hr,rr页面常量值定义
let selectunderlineWidth = (UIScreen.mainScreen().bounds.width-40)/3
let chartwidth = UIScreen.mainScreen().bounds.width-40
let chartheight = UIScreen.mainScreen().bounds.height/570*190
let redColor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)

let selectColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let noselectColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
var outterCircleHeight = UIScreen.mainScreen().bounds.height/570*380-145

let startColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let centerColor = UIColor(red: 195/255, green: 114/255, blue: 168/255, alpha: 1.0)
let endColor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
let avgColor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
let defaultColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
let grayColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
let textDarkgrey = UIColor(red: 174/255, green: 173/255, blue: 173/255, alpha: 1.0)

let defaultblueColor = UIColor(red: 80/255, green: 171/255, blue: 242/255, alpha: 1.0)

//sleep页面常量
let awakeColor = UIColor(red: 125/255, green: 249/255, blue: 60/255, alpha: 1.0)
let lightsleepColor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
let deepsleepColor = UIColor(red: 92/255, green: 130/255, blue: 245/255, alpha: 1.0)
let bigCircleHeight = UIScreen.mainScreen().bounds.height/570*190 - 40

//周报表
let lighrgraybackgroundcolor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
let hrcolor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
let rrcolor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let textGraycolor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
let textBluecolor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
let leavebedcolor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
let hrFigureWidth = UIScreen.mainScreen().bounds.width / 4
let rrFigureWidth = UIScreen.mainScreen().bounds.width / 4
let sleepFigureWidth = (UIScreen.mainScreen().bounds.width-4)/3
let suggestionFigureWidth = (UIScreen.mainScreen().bounds.width-2)/2


//plist文件读写单例
var PLISTHELPER:PlistHelper!

//心率呼吸睡眠圆圈内的文字  ：system bold 37
//周报表上文字 ：system23
let font23 =  UIFont.systemFontOfSize(23)
//按钮上的文字 ：system 18
//登录注册老人信息文本框的文字／心率呼吸里滑动烂的文字／心率呼吸圆点右边的数字  ：system16
let font16 = UIFont.systemFontOfSize(16)
//扫一扫页面的文字／“扫一扫”文字／“返回”文字：system bold 15
//心率呼吸睡眠页面文字／表格里文字  ：system 14
let font14 = UIFont.systemFontOfSize(14)
//同意协议的文字：system bold 12
//周睡眠报表文字： system 12
let font12 = UIFont.systemFontOfSize(12)

//记录当前显示的页面controller：
var currentController:UIViewController!

var deviceType:String = "iphone"