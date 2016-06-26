//
//  SleepCareForSingleManager.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/22/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

protocol SleepCareForSingleManager{
    // 2登录认证
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    func SingleLogin(loginName:String,loginPassword:String) -> LoginUser
    
    
    //3.获取手机验证码
    //参数： mobileNum－> 11位手机号
    func GetVerificationCode(mobileNum:String)->ServerResult
    
 
    //4 注册个人用户信息
    //参数：loginName－>账户名（手机号）
    //     loginPassword->密码
    //     vcCode->验证码
    //     equipmentID->设备id
    func SingleRegist(loginName:String,loginPassword:String,vcCode:String,equipmentID:String) ->ServerResult
    
    
    //5 修改账户信息
    //参数：loginName－>账户名（手机号）
    //     oldPassword->旧密码
    //     newPassword->新密码
    func ModifyAccount(loginName:String,oldPassword:String,newPassword:String)->ServerResult
    
    
    //6设备编号认证
    //参数：equipmentID
    func CheckEquipmentID(equipmentID:String)->ServerResult
    
    
    //7 确认新密码（忘记密码）
    func ConfirmNewPassword(loginName:String,vcCode:String,newPassword:String)->ServerResult
    
    //8 根据设备编号查询对应老人信息
    //参数：equipmentID
    func GetBedUserInfoByEquipmentID(equipmentID:String)->BedUserInfo
 
    
    //9 完善老人信息
    //参数：bedUserCode,bedUserName,sex,mobilePhone,address
    func ModifyBedUserInfo(bedUserCode:String,bedUserName:String,sex:String,mobilePhone:String,address:String)->ServerResult
    
    //10移除设备
    //参数：loginName
    //     equipmentIDs->要移除的设备编码。（多个用半角“，”隔开）
    func RemoveEquipment(loginName:String,equipmentIDs:String)->ServerResult
    
    
    //11 获取登录账户绑定的设备(包括设备对应的老人信息 )
    //参数：loginName
    func GetEquipmentsByLoginName(loginName:String)->EquipmentList
    
    
    //12获取心率曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleHRTimeReport(bedUserCode:String,searchType:String)->HRRange
    
    
    
    //13获取呼吸曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleRRTimeReport(bedUserCode:String,searchType:String)->RRRange
    
    
    
    //14查询老人睡眠质量
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetSleepQualityofBedUser(bedUserCode:String,reportDate:String)->SleepQualityReport
    
    
    
    //15 根据床位用户编码和邮箱信息发送邮件(指定日期所在周的报表)
    // 参数：bedUserCode->床位用户编号
    //      sleepDate->分析日期
    //      email->要发送的邮箱地址
    func SendEmail(bedUserCode:String,sleepDate:String,email:String)->ServerResult
    
    
    //16查询指定日期所在周的老人睡眠报表
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetWeekSleepofBedUser(bedUserCode:String,reportDate:String)->WeekSleep
    
    
    //17根据当前登录用户、报警类型、时间段、处理状态等多条件获取关注老人的报警信息
    //参数： loginName
    //      schemaCode->报警类型
    //      alarmTimeBegin,alarmTimeEnd->报警开始结束时间yyyy-MM-dd
    //      transferTypeCode->报警处理类型
    //      from->开始记录序号 (为空表示查询全部）
    //      max->返回最大记录数量 (为空表示查询全部 )
    func GetSingleAlarmByLoginUser(loginName:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String,transferTypeCode:String,from:String?,max:String?)->AlarmList
    
    
    
    //18删除报警信息
    func DeleteAlarmMessage(alarmCodes:String,loginName:String)->ServerResult
    
    //19添加设备
    func BindEquipmentofUser(equipmentID:String,loginName:String)->ServerResult
    
    
    //22关闭远程通知
     func CloseNotification(token:String, loginName:String)->ServerResult
    
    //23 注册设备
    //deviceType：1手机 2pad
     func RegistDevice(token:String, deviceType:String)-> ServerResult
    
    //24 开启远程通知
    func OpenNotification(token:String, loginName:String)->ServerResult
}