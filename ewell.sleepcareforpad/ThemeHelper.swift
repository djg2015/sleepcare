//
//  ThemeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/21/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

let DEFAULTCOLOR = UIColor.colorFromRGB(0x2052AA)
let BLACKCOLOR = UIColor.colorFromRGB(0x1F222C)

var themeName:String = "default"
var themeColor:Dictionary<String,UIColor> = ["default": DEFAULTCOLOR,"black": BLACKCOLOR]

//设置当前主题
func SetTheme(ThemeName:String){
    themeName = ThemeName
}

//获取图片名字
func GetImg(name:String)->String{
    var imgName:String = themeName + "_" + name + ".png"
    return imgName
}


