//
//  IBedUserList.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IBedUserList: BaseMessage {
    
    var bedUserInfoList:Array<IBedUserInfo> = Array<IBedUserInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{

        let result = IBedUserList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var bedUserList = doc.nodesForXPath("//BedUserInfo", error:nil) as! [DDXMLElement]
        for bedUser in bedUserList {
            var bedUserInfo = IBedUserInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            bedUserInfo.BedUserCode = bedUser.elementForName("BedUserCode").stringValue()
            bedUserInfo.BedUserName = bedUser.elementForName("BedUserName").stringValue()
            bedUserInfo.PartCode = bedUser.elementForName("PartCode").stringValue()
            bedUserInfo.PartName = bedUser.elementForName("PartName").stringValue()
            bedUserInfo.RoomCode = bedUser.elementForName("RoomCode").stringValue()
            bedUserInfo.RoomName = bedUser.elementForName("RoomName").stringValue()
            bedUserInfo.BedCode = bedUser.elementForName("BedCode").stringValue()
            bedUserInfo.BedNumber = bedUser.elementForName("BedNumber").stringValue()
            bedUserInfo.EquipmentID = bedUser.elementForName("EquipmentID").stringValue()
            result.bedUserInfoList.append(bedUserInfo)
        }
        return result
    }

}

class IBedUserInfo:BaseMessage {
    var BedUserCode:String = ""
    var BedUserName:String = ""
    var PartCode:String = ""
    var PartName:String = ""
    var RoomCode:String = ""
    var RoomName:String = ""
    var BedCode:String = ""
    var BedNumber:String = ""
    var EquipmentID:String = ""
}