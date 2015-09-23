//
//  EMProperties.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class EMProperties : BaseMessage{
    //定义数据字段
    private var EMPropertyDic = Dictionary<String,String>()
    
    //添加键值对
    func AddKeyValue(name:String,value:String){
      EMPropertyDic[name] = value
    }
    
    //将当前模型转换为支持xml传递的Message格式
    override func ToXml()->DDXMLElement{
        var bodyInnerXml:String = "<EMProperties>"
        for(name,value) in EMPropertyDic{
            bodyInnerXml += "<EMProperty name=\"" + name + "\" value=\"" + value + "\"/>"
        }
        bodyInnerXml += "</EMProperties>"
        return super.ToXml(bodyInnerXml)
    }
}