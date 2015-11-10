//
//  IEquipmentInfo.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IEquipmentInfo: BaseMessage {
    
    var EquipmentID:String = ""
    var Status:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IEquipmentInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var equipment = doc.rootElement() as DDXMLElement!
        result.EquipmentID = equipment.elementForName("EquipmentID").stringValue()
        result.Status = equipment.elementForName("Status").stringValue()  
        
        return result
    }

}