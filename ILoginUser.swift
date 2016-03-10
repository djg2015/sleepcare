//
//  ILoginUser.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class ILoginUser: BaseMessage {
    
    var LoginName:String = ""
    var LoginPassword:String = ""
    var UserType:String = ""
    var Status:String = ""
    var HeadFace:String = ""
    var MainCode:String = ""
   
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = ILoginUser(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var loginUser = doc.rootElement() as DDXMLElement!
        result.LoginName = loginUser.elementForName("LoginName").stringValue()
        result.LoginPassword = loginUser.elementForName("LoginPassword").stringValue()
        result.UserType = loginUser.elementForName("UserType").stringValue()
        result.Status = loginUser.elementForName("Status") == nil ? "" : loginUser.elementForName("Status").stringValue()
        result.HeadFace = loginUser.elementForName("HeadFace") == nil ? "" : loginUser.elementForName("HeadFace").stringValue()
        result.MainCode = loginUser.elementForName("MainCode") == nil ? "" : loginUser.elementForName("MainCode").stringValue()
      
               
        return result
    }

}

struct LoginUserType {
    static var UserSelf:String = "1"
    static var Monitor:String = "2"
    static var UnKnow:String = "0"
}
