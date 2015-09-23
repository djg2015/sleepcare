//
//  BedUser.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class BedUser:BaseMessage{
    var BedCode:String = ""
    var BedNumber:String = ""
    var UserCode:String = ""
    var UserName:String = ""
    var Age:String = ""
    var Sex:String = ""
    var Phone:String = ""
    var Address:String = ""
    var CaseCode:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = BedUser(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var users = doc.nodesForXPath("//BedUser", error:nil) as! [DDXMLElement]
        for user in users {
            result.BedCode = user.elementForName("BedCode").stringValue()
            result.BedNumber = user.elementForName("BedNumber").stringValue()
            result.UserCode = user.elementForName("UserCode").stringValue()
            result.UserName = user.elementForName("UserName").stringValue()
            result.Age = user.elementForName("Age").stringValue()
            result.Sex = user.elementForName("Sex").stringValue()
            result.Phone = user.elementForName("Phone").stringValue()
            result.Address = user.elementForName("Address").stringValue()
            result.CaseCode = user.elementForName("CaseCode").stringValue()
        }
        return result
    }

}