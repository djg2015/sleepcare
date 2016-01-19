//
//  BaseMessage.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/15.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class BaseMessage:NSObject{
    init(messageSubject:MessageSubject){
        self.messageSubject = messageSubject
    }
    var messageSubject:MessageSubject
    func ToXml(bodyInnerXml:String)->DDXMLElement{
        var body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue(bodyInnerXml)
        
        //生成XML消息文档
        var mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        //消息类型
        mes.addAttributeWithName("type",stringValue:"normal")
        //发送给谁
        mes.addAttributeWithName("to" ,stringValue: GetValueFromPlist(SERVERJID,"sleepcare.plist"))
        //由谁发送
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
        mes.addAttributeWithName("from" ,stringValue:GetValueFromPlist(USERIDPHONE,"sleepcare.plist"))
        }
        else{
        mes.addAttributeWithName("from" ,stringValue:GetValueFromPlist(USERID,"sleepcare.plist"))
        }
        //组合
        mes.addChild(self.messageSubject.ParseSubjectToXml())
        mes.addChild(body)
        return mes
    }
    
    func GetElementValue(element:DDXMLElement)->String?
    {
        if(element.stringValue() == nil)
        {
            return nil;
        }
        else
        {
            return element.stringValue();
        }
    }
    
    func ToXml()->DDXMLElement{
        //生成XML消息文档
        var mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        //消息类型
        mes.addAttributeWithName("type",stringValue:"normal")
        //发送给谁
        mes.addAttributeWithName("to" ,stringValue:"ewell@122.224.242.241")
        
        //由谁发送
        mes.addAttributeWithName("from" ,stringValue:NSUserDefaults.standardUserDefaults().stringForKey(USERID))
        //组合
        mes.addChild(self.messageSubject.ParseSubjectToXml())
        return mes
        
    }
    
    class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        return BaseMessage(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
    }
}