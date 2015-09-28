//
//  EMServiceException.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class EMServiceException:BaseMessage{
    var code:String = ""
    var message:String = ""
    var trace:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> EMServiceException{
        let result = EMServiceException(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var eMServiceExceptions = doc.nodesForXPath("//EMServiceException", error:nil) as! [DDXMLElement]
        for eMServiceException in eMServiceExceptions {
            result.code = eMServiceException.attributeForName("code").stringValue()
            result.message = eMServiceException.attributeForName("message").stringValue()
            if(eMServiceException.attributeForName("trace") != nil)
            {
                result.trace = eMServiceException.attributeForName("trace").stringValue()
            }
        }
        return result
    }
}