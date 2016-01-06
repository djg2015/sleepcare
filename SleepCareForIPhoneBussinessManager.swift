//
//  SleepCareForIPhoneBussinessManager.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/10.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

protocol SleepCareForIPhoneBussinessManager{
    
    // 获取登录信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    func Login(loginName:String,loginPassword:String) -> ILoginUser
    
    // 注册用户信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    //      mainCode->医院/养老院编号
    func Regist(loginName:String,loginPassword:String,mainCode:String)-> ServerResult
    
    // 保存选择的用户类型
    // 参数：loginName->登录账户
    //      userType->用户类型
    func SaveUserType(loginName:String,userType:String)-> ServerResult
    
    // 根据医院/养老院编号获取楼层以及床位用户信息
    // 参数：mainCode->医院/养老院编号
    func GetPartInfoByMainCode(mainCode:String)->IMainInfo
    
    // 根据医院/养老院编号获取楼层以及床位用户信息（排除已经关注的老人）S
    // 参数：mainCode->医院/养老院编号
    //      loginName->登录账户
    func GetPartInfoWithoutFollowBedUser(loginName:String,mainCode:String)->IMainInfo
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult
    
    // 移除已关注的床位用户
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    func RemoveFollowBedUser(loginName:String,bedUserCode:String)-> ServerResult
    
    // 根据当前登录用户获取所关注的床位用户
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetBedUsersByLoginName(loginName:String,mainCode:String)->IBedUserList
    
    // 根据床位用户编码获取心率曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetHRTimeReport(bedUserCode:String)->IHRRange
    
    // 根据床位用户编码获取呼吸曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetRRTimeReport(bedUserCode:String)->IRRRange
    
    // 根据床位用户编码分析日期查询用户的睡眠质量
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetSleepQualityByUser(bedUserCode:String,reportDate:String)->ISleepQualityReport
    
    // 根据床位用户编码分析日期查询用户的周报表
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetWeekReportByUser(bedUserCode:String,reportDate:String)->IWeekReport
    
    // 根据床位用户编码和邮箱信息发送邮件(指定日期所在周的报表)
    // 参数：bedUserCode->床位用户编号
    //      sleepDate->分析日期
    //      email->要发送的邮箱地址
    func SendEmail(bedUserCode:String,sleepDate:String,email:String)->ServerResult
    
    // 修改登录用户密码和所属医院/养老院
    // 参数：loginName->登录账户
    //      oldPassword->旧的登录密码
    //      newPassword->新的登录密码
    //      mainCode->医院/养老院编码
    func ModifyLoginUser(loginName:String,oldPassword:String,newPassword:String,mainCode:String)->ServerResult
    
    // 根据设备ID查询设备的状态
    // 参数：equipmentID->设备ID
    func GetEquipmentInfo(equipmentID:String)->IEquipmentInfo
    
    // 获取所有的医院/养老院
    func GetAllMainInfo()->IMainInfoList
    
    
    
}