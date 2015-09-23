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
    func GetLoginInfo(LoginName:String,LoginPassword:String)->User
}