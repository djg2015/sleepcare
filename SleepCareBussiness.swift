//
//  SleepCareBussiness.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class SleepCareBussiness: SleepCareBussinessManager {
    //获取认证用户信息
    func GetLoginInfo(LoginName:String,LoginPassword:String)->User{
        var suject = MessageSubject(opera: "Login")
        var post = EMProperties(messageSubject: suject)
        post.AddKeyValue("LoginName", value: LoginName)
        post.AddKeyValue("LoginPassword", value: LoginPassword)
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        return xmpp?.SendData(post) as! User
        
    }
}