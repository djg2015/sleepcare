//
//  ServerResult.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/3.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class ServerResult: BaseMessage {
    var Result:Bool = false

    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = ServerResult(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var serverResult = doc.rootElement() as DDXMLElement!
        result.Result = serverResult.elementForName("IsSuccessful").stringValue() == "true" ? true : false
        
        return result
    }
}