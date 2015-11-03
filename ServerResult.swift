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
        
        return result
    }
}