//
//  ThemeHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/21/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation



//设置当前主题
func SetTheme(ThemeName:String){
    themeName = ThemeName
}

//获取图片名字
func GetImg(name:String)->String{
    var imgName:String = themeName + "_" + name + ".png"
    return imgName
}


