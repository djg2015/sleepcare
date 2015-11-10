//
//  IMainInfoList.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IMainInfoList: BaseMessage {
    
    var mainInfoList:Array<ISimpleMainInfo> = Array<ISimpleMainInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IMainInfoList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var mainList = doc.nodesForXPath("//SimpleMainInfo", error:nil) as! [DDXMLElement]
        for mainInfo in mainList {
            var simpleMain = ISimpleMainInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            simpleMain.MainCode = mainInfo.elementForName("MainCode").stringValue()
            simpleMain.MainName = mainInfo.elementForName("MainName").stringValue()
            
            result.mainInfoList.append(simpleMain)
        }
        return result
    }

}

class ISimpleMainInfo: BaseMessage {
    
    var MainCode:String = ""
    var MainName:String = ""
}