//
//  AlarmController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/8.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class AlarmView:UIView
{
    // 控件定义
    @IBOutlet weak var tabAlarm: UISegmentedControl!
    
    // 属性定义
    var alarmViewModel = AlarmViewModel()


    //-------------自定义方法处理---------------
    func rac_settings(){
        //属性绑定
        RACObserve(self.alarmViewModel, "FuncSelectedIndex") ~> RAC(self.tabAlarm, "selectedSegmentIndex")
          self.tabAlarm!.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext{
            _ in
            var v = 0
            self.alarmViewModel.SelectChange(self.tabAlarm.selectedSegmentIndex)
        }
    }
}