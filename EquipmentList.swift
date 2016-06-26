//
//  EquipmentList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/22/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class EquipmentList: BaseMessage {
    var equipmentList:Array<EquipmentInfo> = Array<EquipmentInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = EquipmentList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var tempEquipmentList = doc.nodesForXPath("//EquipmentInfo", error:nil) as! [DDXMLElement]
        
        for tempEquipmentInfo in tempEquipmentList {
            var equipmentInfo = EquipmentInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
          
            if tempEquipmentInfo.elementForName("EquipmentID") != nil{
                equipmentInfo.EquipmentID = tempEquipmentInfo.elementForName("EquipmentID").stringValue()
            }
            if tempEquipmentInfo.elementForName("BedUserCode") != nil{
               equipmentInfo.BedUserCode = tempEquipmentInfo.elementForName("BedUserCode").stringValue()
            }
            if tempEquipmentInfo.elementForName("BedUserName") != nil{
               equipmentInfo.BedUserName = tempEquipmentInfo.elementForName("BedUserName").stringValue()
            }
            if tempEquipmentInfo.elementForName("Sex") != nil{
               equipmentInfo.Sex = tempEquipmentInfo.elementForName("Sex").stringValue()
            }
            if tempEquipmentInfo.elementForName("MobilePhone") != nil{
               equipmentInfo.MobilePhone = tempEquipmentInfo.elementForName("MobilePhone").stringValue()
            }
            if tempEquipmentInfo.elementForName("Address") != nil{
                equipmentInfo.Address = tempEquipmentInfo.elementForName("Address").stringValue()
            }
            
            result.equipmentList.append(equipmentInfo)
        }
        
        return result
    }



}

class EquipmentInfo:BaseMessage {
   var EquipmentID:String = ""
    var BedUserCode:String = ""
    var BedUserName:String = ""
    var Sex:String = ""
    var MobilePhone:String = ""
    var Address:String = ""
    
}
