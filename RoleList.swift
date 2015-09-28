//
//  RoleList.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
// 角色列表
class RoleList:BaseMessage
{
    var roleList = Array<Role>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = RoleList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var roleList = doc.nodesForXPath("//Role", error:nil) as! [DDXMLElement]
        for role in roleList {
            var newRole = Role()
            if(role.elementForName("RoleCode") != nil)
            {
                newRole.RoleCode = role.elementForName("RoleCode").stringValue()
            }
            if(role.elementForName("RoleName") != nil)
            {
                newRole.RoleName = role.elementForName("RoleName").stringValue()
            }
            if(role.elementForName("RoleType") != nil)
            {
                newRole.RoleType = role.elementForName("RoleType").stringValue()
            }
            if(role.elementForName("MainCode") != nil)
            {
                newRole.MainCode = role.elementForName("MainCode").stringValue()
            }
            if(role.elementForName("PartCode") != nil)
            {
                newRole.PartCode = role.elementForName("PartCode").stringValue()
            }
            result.roleList.append(newRole)
        }
        return result
    }
    
}