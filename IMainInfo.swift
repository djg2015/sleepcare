//
//  IMainInfo.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IMainInfo: BaseMessage {
    var PartInfoList:Array<IPartInfo> = Array<IPartInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = IMainInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var partInfoList = doc.nodesForXPath("//PartInfo", error:nil) as! [DDXMLElement]
        for partInfo in partInfoList {
            var part = IPartInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
            part.MainName = partInfo.elementForName("MainName") == nil ? "" : partInfo.elementForName("MainName").stringValue()
            part.PartCode = partInfo.elementForName("PartCode").stringValue()
            part.PartName = partInfo.elementForName("PartName") == nil ? "" : partInfo.elementForName("PartName").stringValue()
            var bedInfoList = partInfo.elementForName("BedInfoList").elementsForName("BedInfo") as! [DDXMLElement]
            for bedInfo in bedInfoList{
                var bed:IBedInfo = IBedInfo()
                bed.RoomCode = bedInfo.elementForName("RoomCode").stringValue()
                bed.RoomName = bedInfo.elementForName("RoomName").stringValue()
                bed.BedCode = bedInfo.elementForName("BedCode").stringValue()
                bed.BedNumber = bedInfo.elementForName("BedNumber").stringValue()
                bed.BedUserCode = bedInfo.elementForName("BedUserCode").stringValue()
                bed.BedUserName = bedInfo.elementForName("BedUserName").stringValue()
                bed.EquipmentID = bedInfo.elementForName("EquipmentID") != nil ?bedInfo.elementForName("EquipmentID").stringValue() : "未绑定"
                bed.Sex = bedInfo.elementForName("Sex") != nil ?bedInfo.elementForName("Sex").stringValue() : ""
                
                part.BedInfoList.append(bed)
            }
            result.PartInfoList.append(part)
        }
        return result
    }
}

class IPartInfo:BaseMessage{
    var MainName:String = ""
    var PartCode:String = ""
    var PartName:String = ""
    var BedInfoList:Array<IBedInfo> = Array<IBedInfo>()
}

class IBedInfo{
    
    var RoomCode:String = ""
    var RoomName:String = ""
    var BedCode:String = ""
    var BedNumber:String = ""
    var BedUserCode:String = ""
    var BedUserName:String = ""
    var EquipmentID:String=""
    var Sex:String = ""
}