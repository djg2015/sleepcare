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
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = ILoginUser(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        return result
    }

}
