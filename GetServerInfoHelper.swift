//
//  GetServerInfoHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 2/17/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

/**
先从网站拉取服务器连接信息，不成功则从本地plist文件读取服务器连接信息。
returns: 返回是否操作成功,布尔类型
*/
func CheckServerInfo()->Bool{
    var jsonflag = JasonHelper.GetJasonInstance().ConnectJason()
    //若成功从url获取所有server有关的数据
    if jsonflag{
        var flag = JasonHelper.GetJasonInstance().GetFromJsonData()
        if flag{
            /**
            *	@brief  成功从网站获取服务器连接信息后的操作
            *	@param .SetJsonDataToPlistFile	将jason数据写入本地plist文件
            */
            JasonHelper.GetJasonInstance().SetJsonDataToPlistFile()
            return true
        }
    }
        // 无法从网站读取sever信息，则查看本地plist信息
    else{
        var plistflag = IsPlistDataEmpty()
        //本地sleepcare.plist文件包含服务器连接所需信息，则用本地plist文件内的信息尝试连接openfire
        if !plistflag {
            return true
        }
    }
    return false
}

//获取server数据失败，显示提示信息
func GetServerInfoFail(){
    SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.ConnectOpenfireFail), subTitle:"提示", style: AlertStyle.None,buttonTitle:"关闭",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"重试连接", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: ConnectAgain)
}
func ConnectAgain(isOtherButton: Bool){
    if !isOtherButton{
        CheckServerInfo()
    }
}