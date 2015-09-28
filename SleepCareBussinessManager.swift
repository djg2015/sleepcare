//
//  SleepCareBussinessManager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//针对智能床业务模块全部接口定义
protocol SleepCareBussinessManager{
    // 获取登录信息，返回登录用户
    // 参数：LoginName->登录账户
    //      LoginPassword->登录密码
    func GetLoginInfo(LoginName:String,LoginPassword:String)->User
    
    // 根据角色父编码获取父编码下所有的角色包括当前父角色
    // 参数：parentRoleCode->父角色编码
    func ListRolesByParentCode(parentRoleCode:String)->RoleList
    
    // 根据科室/楼层编号 获取当前科室/楼层信息包括对应的床位信息
    // 参数：partCode->科室/楼层编码
    //      searchType->查找类型：1.按照房间号查询 2.按照床位号查询
    //      searchContent->房间号或者床位号
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetPartInfoByPartCode(partCode:String,searchType:String,searchContent:String,from:Int32?,max:Int32?)->PartInfo
    
    // 根据床位编码获取当前床位用户的信息
    // 参数：partCode->科室/楼层编码
    //      bedCode->床位编码
    func GetUserByBedCode(partCode:String,bedCode:String)->BedUser
    
    // 根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：partCode->科室/楼层编码
    //      userCode->用户编码
    //      analysTimeBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysTimeEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetSleepCareReportByUser(partCode:String,userCode:String,analysTimeBegin:String,analysTimeEnd:String,from:Int32?,max:Int32?)->SleepCareReportList
    
    // 根据科室/楼层编号、用户编号、分析日期多条件获取睡眠质量分析明细
    // 参数：userCode->用户编码
    //      analysDate->分析日期("yyyy-MM-dd"格式)
    func QuerySleepQulityDetail(userCode:String,analysDate:String)->SleepCareReport
    
    // 根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：userCode->用户编码
    //      analysDateBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysDateEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetTurnOverAnalysByUser(userCode:String,analysDateBegin:String,analysDateEnd:String,from:Int32?,max:Int32?)->TurnOverAnalysList
}