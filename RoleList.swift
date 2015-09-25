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
            newRole.RoleCode = role.elementForName("RoleCode").stringValue()
            newRole.RoleName = role.elementForName("RoleName").stringValue()
            newRole.RoleType = role.elementForName("RoleType").stringValue()
            newRole.MainCode = role.elementForName("MainCode").stringValue()
            newRole.PartCode = role.elementForName("PartCode").stringValue()
            result.roleList.append(newRole)
        }
        return result
    }

}