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
            if(user.elementForName("BedCode") != nil)
            {
                result.BedCode = user.elementForName("BedCode").stringValue()
            }
            if(user.elementForName("BedNumber") != nil)
            {
                result.BedNumber = user.elementForName("BedNumber").stringValue()
            }
            if(user.elementForName("UserCode") != nil)
            {
                result.UserCode = user.elementForName("UserCode").stringValue()
            }
            if(user.elementForName("UserName") != nil)
            {
                result.UserName = user.elementForName("UserName").stringValue()
            }
            if(user.elementForName("Age") != nil)
            {
                result.Age = user.elementForName("Age").stringValue()
            }
            if(user.elementForName("Sex") != nil)
            {
                result.Sex = user.elementForName("Sex").stringValue()
            }
            if(user.elementForName("Phone") != nil)
            {
                result.Phone = user.elementForName("Phone").stringValue()
            }
            if(user.elementForName("Address") != nil)
            {
                result.Address = user.elementForName("Address").stringValue()
            }
            if(user.elementForName("CaseCode") != nil)
            {
                result.CaseCode = user.elementForName("CaseCode").stringValue()
            }
        }
        return result
    }
    
}