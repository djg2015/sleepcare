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
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult
    
    // 移除已关注的床位用户
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    func RemoveFollowBedUser(loginName:String,bedUserCode:String)-> ServerResult
}