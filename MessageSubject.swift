//
//  MessageSubject.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class MessageSubject{
    var postMethod:String = "Request"
    var authCode:String = "1234567890"
    var version:String = "1.0"
    var biz:String = "sleepcareforpad"
    var operate:String? = nil
    var requestID:String? = nil
    var random = ["1","2","3","4","5","6","7","8","9","0","a","b","c","d","e","f","g","h"]
    init(opera:String,bizcode:String = "sleepcareforpad"){
        self.operate = opera
        self.biz = bizcode
    }
    
    //根据XML获取对应的Subject模型
    class func ParseXmlToSubject(subjectXml:String)-> MessageSubject{
        var subject = subjectXml.componentsSeparatedByString(":")
        var before = subject[0].componentsSeparatedByString("/")
        var end = subject[1].componentsSeparatedByString("/")
        let result = MessageSubject(opera: "")
        result.requestID = before[3]
        result.operate = end[1]
        return result
    }
    
    //转换Subjec模型为指定格式字符串
    func ParseSubjectToXml() -> DDXMLElement{
        var subject:DDXMLElement = DDXMLElement.elementWithName("subject") as! DDXMLElement
        self.requestID = GetRandomForRequest(16)
        var result:String = "\(self.postMethod)/\(self.authCode)/\(self.version)/" + self.requestID!+":"
        result += "\(self.biz)/" + self.operate!
        
        subject.setStringValue(result)
        return subject
    }
    
    //随机获取指定长度的数字字母字符串组合
    private func GetRandomForRequest(length:Int)->String{
        var result:String = ""
        for i in 0..<length{
            var index = randomIn(min: 0, max: self.random.count-1)
            result += self.random[index]
        }
        return result
    }
    
    func randomIn(#min: Int, max: Int) -> Int {
        var suff = max - min + 1
        var rand = arc4random() % 10
        return Int(rand) + min
    }
}
