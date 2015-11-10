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

}