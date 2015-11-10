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

        var subject = MessageSubject(opera: "Login")
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
        
        var subject = MessageSubject(opera: "Regist")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("loginPassword", value: loginPassword)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
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
        
        var subject = MessageSubject(opera: "SaveUserType")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("userType", value: userType)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 根据医院/养老院编号获取楼层以及床位用户信息
    // 参数：mainCode->医院/养老院编号
    func GetPartInfoByMainCode(mainCode:String)->IMainInfo{
        
        var subject = MessageSubject(opera: "GetPartInfoByMainCode")
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
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "FollowBedUser")
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
}