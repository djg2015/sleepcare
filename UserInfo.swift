//
//  UserInfo.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//测试用
class UserInfo:BaseMessage{
   
    
    //定义实时数据字段
    
    
    
    
    
    //将当前模型转换为支持xml传递的Message格式
    override func ToXml()->DDXMLElement{
        var bodyInnerXml:String = "<EMProperties><Property name=\"shopCode\" value=\"0001\" /><Property name=\"businessDate\" value="
        bodyInnerXml += "\"2016-07-08\" /></EMProperties>"
        
        return super.ToXml(bodyInnerXml)
    }
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
      
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var users = doc.nodesForXPath("//EBRealTimeSummary", error:nil) as! [DDXMLElement]
        for user in users {
            let uid = user.attributeForName("shopCode").stringValue()
            //获取tel节点的子节点
            let telElement = user.elementForName("InfoItems") as DDXMLElement
            let home = (telElement.elementForName("Property") as DDXMLElement).attributeForName("name").stringValue()
            //println("User: uid:\(uid),uname:\(uname),mobile:\(mobile),home:\(home)")
        }
        return BaseMessage(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
    }
}