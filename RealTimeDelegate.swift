//
//  RealTimeDelegate.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

protocol RealTimeDelegate{
    func GetRealTimeDelegate(realTimeReport:RealTimeReport);
}

protocol WaringAttentionDelegate{
    func GetWaringAttentionDelegate(alarmList:AlarmList);
}
