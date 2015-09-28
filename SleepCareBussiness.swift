//
//  SleepCareBussiness.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class SleepCareBussiness: SleepCareBussinessManager {
    //获取认证用户信息
    func GetLoginInfo(LoginName:String,LoginPassword:String)->User{
        var subject = MessageSubject(opera: "Login")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: LoginName)
        post.AddKeyValue("loginPassword", value: LoginPassword)
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! User
    }
    
    // 根据角色父编码获取父编码下所有的角色包括当前父角色
    // 参数：parentRoleCode->父角色编码
    func ListRolesByParentCode(parentRoleCode:String)->RoleList{
        var subject = MessageSubject(opera: "ListRolesByParentCode")
        var post = EMString(messageSubject: subject)
        post.EMString = parentRoleCode
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! RoleList
    }
    
    // 根据科室/楼层编号 获取当前科室/楼层信息包括对应的床位信息
    // 参数：partCode->科室/楼层编码
    //      searchType->查找类型：1.按照房间号查询 2.按照床位号查询
    //      searchContent->房间号或者床位号
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetPartInfoByPartCode(partCode:String,searchType:String,searchContent:String,from:Int32?,max:Int32?)->PartInfo{
        var subject = MessageSubject(opera: "GetPartInfoByPartCode")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("partCode", value: partCode)
        post.AddKeyValue("searchType", value: searchType)
        post.AddKeyValue("searchContent", value: searchContent)
        if(from != nil)
        {
            post.AddKeyValue("from", value: String(from!))
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: String(max!))
        }
        
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! PartInfo
    }
    
    // 根据床位编码获取当前床位用户的信息
    // 参数：partCode->科室/楼层编码
    //      bedCode->床位编码
    func GetUserByBedCode(partCode:String,bedCode:String)->BedUser{
        var subject = MessageSubject(opera: "GetUserByBedCode")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("partCode", value: partCode)
        post.AddKeyValue("bedCode", value: bedCode)
        
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! BedUser
    }
    
    // 根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：partCode->科室/楼层编码
    //      userCode->用户编码
    //      analysTimeBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysTimeEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetSleepCareReportByUser(partCode:String,userCode:String,analysTimeBegin:String,analysTimeEnd:String,from:Int32?,max:Int32?)->SleepCareReportList{
        var subject = MessageSubject(opera: "GetSleepCareReportByUser")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("partCode", value: partCode)
        post.AddKeyValue("userCode", value: userCode)
        post.AddKeyValue("analysTimeBegin", value: analysTimeBegin)
        post.AddKeyValue("analysTimeEnd", value: analysTimeEnd)
        if(from != nil)
        {
            post.AddKeyValue("from", value: String(from!))
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: String(max!))
        }
        
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! SleepCareReportList
    }
    
    // 根据科室/楼层编号、用户编号、分析日期多条件获取睡眠质量分析明细
    // 参数：userCode->用户编码
    //      analysDate->分析日期("yyyy-MM-dd"格式)
    func QuerySleepQulityDetail(userCode:String,analysDate:String)->SleepCareReport{
        var subject = MessageSubject(opera: "QuerySleepQulityDetail")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("userCode", value: userCode)
        post.AddKeyValue("analysDate", value: analysDate)
        
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! SleepCareReport
    }
    
    // 根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：userCode->用户编码
    //      analysDateBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysDateEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetTurnOverAnalysByUser(userCode:String,analysDateBegin:String,analysDateEnd:String,from:Int32?,max:Int32?)->TurnOverAnalysList{
        var subject = MessageSubject(opera: "GetTurnOverAnalysByUser")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("userCode", value: userCode)
        post.AddKeyValue("analysDateBegin", value: analysDateBegin)
        post.AddKeyValue("analysDateEnd", value: analysDateEnd)
        if(from != nil)
        {
            post.AddKeyValue("from", value: String(from!))
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: String(max!))
        }
        
        var xmpp = XmppMsgManager.GetInstance(xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! TurnOverAnalysList
    }
}