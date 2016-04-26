//
//  SleepCareBussinessManager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//报警信息相关接口


protocol SleepCareBussinessManager{
    func GetAlarmByUser(partCode:String,userCode:String,userNameLike:String,bedNumberLike:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String, from:Int32?,max:Int32?)-> AlarmList
 
    // 处理报警信息
    // 参数：alarmCode-> 报警编号
    //      transferType-> 处理类型 002:处理 003:误警报
    func HandleAlarm(alarmCode:String,transferType:String)->ServerResult
    
    //根据当前登录用户、报警类型、报警时间段、报警处理状态等多条件获取关注老人的报警信息
    func GetAlarmByLoginUser(mainCode:String,loginName:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String,transferTypeCode:String,from:String?,max:String?)-> AlarmList
    
    //删除报警信息（已读）
    func DeleteAlarmMessage(alarmCodes:String,loginName:String)->ServerResult
}