//
//  PartInfo.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class PartInfo: BaseMessage {
    var BedList = Array<Bed>()
    var PartCode:String = ""
    var PartName:String = ""
    var Location:String = ""
    var RoomCount:String = ""
    var BedCount:String = ""
    var BindingCount:String = ""
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = PartInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var partInfos = doc.nodesForXPath("//PartInfo", error:nil) as! [DDXMLElement]
        for partInfo in partInfos {
            result.PartCode = partInfo.elementForName("PartCode").stringValue()
            result.PartName = partInfo.elementForName("PartName").stringValue()
            result.Location = partInfo.elementForName("Location").stringValue()
            result.RoomCount = partInfo.elementForName("RoomCount").stringValue()
            result.BedCount = partInfo.elementForName("BedCount").stringValue()
            result.BindingCount = partInfo.elementForName("BindingCount").stringValue()
            //获取role节点的子节点
            let beds = partInfo.nodesForXPath("//PartInfo", error:nil) as! [DDXMLElement]
            for bed in beds {
                var newBed = Bed()
                newBed.BedCode = bed.elementForName("BedCode").stringValue()
                newBed.BedNumber = bed.elementForName("BedNumber").stringValue()
                newBed.RoomCode = bed.elementForName("RoomCode").stringValue()
                newBed.RoomNumber = bed.elementForName("RoomNumber").stringValue()
                newBed.UserCode = bed.elementForName("UserCode").stringValue()
                newBed.UserName = bed.elementForName("UserName").stringValue()
                newBed.CaseCode = bed.elementForName("CaseCode").stringValue()
                newBed.OnBedStatus = bed.elementForName("OnBedStatus").stringValue()
                newBed.Sleep = bed.elementForName("Sleep").stringValue()
                result.BedList.append(newBed)
            }
        }
        return result
    }

}