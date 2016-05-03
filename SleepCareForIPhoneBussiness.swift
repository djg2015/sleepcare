//
//  SleepCareForIPhoneBussiness.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class SleepCareForIPhoneBussiness: SleepCareForIPhoneBussinessManager {
    
    // 获取登录信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    func Login(loginName:String,loginPassword:String) -> ILoginUser{
        
        var subject = MessageSubject(opera: "Login", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("loginPassword", value: loginPassword)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ILoginUser
    }
    
    
    // 注册用户信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    //      mainCode->医院/养老院编号
    func Regist(loginName:String,loginPassword:String,mainCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "Regist", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("loginPassword", value: loginPassword)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendDataForRegist(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    
   
    
    // 保存选择的用户类型
    // 参数：loginName->登录账户
    //      userType->用户类型
    func SaveUserType(loginName:String,userType:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "SaveUserType", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("userType", value: userType)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendDataForRegist(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 根据医院/养老院编号获取楼层以及床位用户信息
    // 参数：mainCode->医院/养老院编号
    func GetPartInfoByMainCode(mainCode:String)->IMainInfo{
        
        var subject = MessageSubject(opera: "GetPartInfoByMainCode", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IMainInfo
    }
    
    //根据医院/养老院编号获取楼层以及床位用户信息（排除已经关注的老人）
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetPartInfoWithoutFollowBedUser(loginName:String,mainCode:String)->IMainInfo{
        
        var subject = MessageSubject(opera: "GetPartInfoWithoutFollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post,timeOut:20)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IMainInfo
    }
    
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "FollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 移除已关注的床位用户
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    func RemoveFollowBedUser(loginName:String,bedUserCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "RemoveFollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 根据当前登录用户获取所关注的床位用户
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetBedUsersByLoginName(loginName:String,mainCode:String)->IBedUserList{
        
        var subject = MessageSubject(opera: "GetBedUsersByLoginName", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IBedUserList
    }
    
    // 根据床位用户编码获取心率曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetHRTimeReport(bedUserCode:String)->IHRRange{
        
        var subject = MessageSubject(opera: "GetHRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IHRRange
    }
    
    // 根据床位用户编码获取呼吸曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetRRTimeReport(bedUserCode:String)->IRRRange{
        
        var subject = MessageSubject(opera: "GetRRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IRRRange
    }
    
    // 根据床位用户编码分析日期查询用户的睡眠质量
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetSleepQualityByUser(bedUserCode:String,reportDate:String)->ISleepQualityReport{
        
        var subject = MessageSubject(opera: "GetSleepQualityByUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ISleepQualityReport
    }
    
    // 根据床位用户编码分析日期查询用户的周报表
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetWeekReportByUser(bedUserCode:String,reportDate:String)->IWeekReport{
        
        var subject = MessageSubject(opera: "GetWeekReportByUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IWeekReport
    }
    
    
    // 根据床位用户编码和邮箱信息发送邮件(指定日期所在周的报表)
    // 参数：bedUserCode->床位用户编号
    //      sleepDate->分析日期
    //      email->要发送的邮箱地址
    func SendEmail(bedUserCode:String,sleepDate:String,email:String)->ServerResult{
        
        var subject = MessageSubject(opera: "SendEmail", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("sleepDate", value: sleepDate)
        post.AddKeyValue("email", value: email)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 修改登录用户密码和所属医院/养老院
    // 参数：loginName->登录账户
    //      oldPassword->旧的登录密码
    //      newPassword->新的登录密码
    //      mainCode->医院/养老院编码
    func ModifyLoginUser(loginName:String,oldPassword:String,newPassword:String,mainCode:String)->ServerResult{
        
        var subject = MessageSubject(opera: "ModifyLoginUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("oldPassword", value: oldPassword)
        post.AddKeyValue("newPassword", value: newPassword)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 根据设备ID查询设备的状态
    // 参数：equipmentID->设备ID
    func GetEquipmentInfo(equipmentID:String)->IEquipmentInfo{
        
        var subject = MessageSubject(opera: "GetEquipmentInfo", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("equipmentID", value: equipmentID)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IEquipmentInfo
    }
    
    // 获取所有的医院/养老院
    func GetAllMainInfo()->IMainInfoList{
        var subject = MessageSubject(opera: "GetAllMainInfo", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendDataForRegist(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IMainInfoList
    }
    //注册设备
    // 参数：token->设备token
    //      deviceType->设备类型
    func RegistDevice(token:String, deviceType:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "RegistDevice", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("deviceType", value: deviceType)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }

    //开启远程通知
    func OpenNotification(token:String, loginName:String)->ServerResult{
        
        var subject = MessageSubject(opera: "OpenNotification", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("loginName", value: loginName)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    //关闭远程通知
    func CloseNotification(token:String, loginName:String)->ServerResult{
        var subject = MessageSubject(opera: "CloseNotification", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("loginName", value: loginName)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    
    }
   }