//
//  RealTimeDelegate.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation


// 1. 推送实时生命体征数据
//   注：服务器会每隔1 秒推送一条实时数据
//  注：OnBedStatus 有5 个值: 请假 在床 离床 异常 空床

protocol RealTimeDelegate{
    func GetRealTimeDelegate(realTimeReport:RealTimeReport);
}

protocol WaringAttentionDelegate{
    func GetWaringAttentionDelegate(alarmList:AlarmList);
}
