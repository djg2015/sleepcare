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
            if bedUser.elementForName("BedUserCode") != nil{
            bedUserInfo.BedUserCode = bedUser.elementForName("BedUserCode").stringValue()
            }
            if bedUser.elementForName("BedUserName") != nil{
             bedUserInfo.BedUserName = bedUser.elementForName("BedUserName").stringValue()
            }
            if bedUser.elementForName("PartCode") != nil{
            bedUserInfo.PartCode = bedUser.elementForName("PartCode").stringValue()
            }
            if bedUser.elementForName("PartName") != nil{
            bedUserInfo.PartName = bedUser.elementForName("PartName").stringValue()
            }
            if bedUser.elementForName("RoomCode") != nil{
            bedUserInfo.RoomCode = bedUser.elementForName("RoomCode").stringValue()
            }
            if bedUser.elementForName("RoomName") != nil{
            bedUserInfo.RoomName = bedUser.elementForName("RoomName").stringValue()
            }
            if bedUser.elementForName("BedCode") != nil{
            bedUserInfo.BedCode = bedUser.elementForName("BedCode").stringValue()
            }
            if bedUser.elementForName("BedNumber") != nil{
            bedUserInfo.BedNumber = bedUser.elementForName("BedNumber").stringValue()
            }
            if bedUser.elementForName("EquipmentID") != nil{
            bedUserInfo.EquipmentID = bedUser.elementForName("EquipmentID").stringValue()
            }
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