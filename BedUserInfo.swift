//
//  BedUserInfo.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/22/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class BedUserInfo: BaseMessage {
    
    var BedUserCode:String = ""
    var BedUserName:String = ""
    var Sex:String = ""
    var MobilePhone:String = ""
    var Address:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = BedUserInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var bedUser = doc.rootElement() as DDXMLElement!
        result.BedUserCode = bedUser.elementForName("BedUserCode") != nil ? bedUser.elementForName("BedUserCode").stringValue() : ""
        result.BedUserName = bedUser.elementForName("BedUserName") != nil ? bedUser.elementForName("BedUserName").stringValue() : ""
        result.Sex = bedUser.elementForName("Sex") != nil ? bedUser.elementForName("Sex").stringValue() : ""
        result.MobilePhone = bedUser.elementForName("MobilePhone") != nil ? bedUser.elementForName("MobilePhone").stringValue() : ""
        result.Address = bedUser.elementForName("Address") != nil ? bedUser.elementForName("Address").stringValue() : ""
        
        return result
    }
    
}
