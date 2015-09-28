//
//  EMString.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class EMString: BaseMessage {
    //定义数据字段
    var EMString:String = ""
    
    //将当前模型转换为支持xml传递的Message格式
    override func ToXml()->DDXMLElement{
        var bodyInnerXml:String = "<EMString value=\"" + self.EMString + "\"/>"
        
        return super.ToXml(bodyInnerXml)
    }
}