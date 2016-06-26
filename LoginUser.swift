//
//  LoginUser.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/22/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class LoginUser: BaseMessage {
    
    var LoginName:String = ""
    var LoginPassword:String = ""
    //openfire用户id
    var JID:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = LoginUser(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var loginUser = doc.rootElement() as DDXMLElement!
        result.LoginName = loginUser.elementForName("LoginName").stringValue()
        result.LoginPassword = loginUser.elementForName("LoginPassword").stringValue()
        result.JID = loginUser.elementForName("JID").stringValue()
        
        
        return result
    }
    
}
