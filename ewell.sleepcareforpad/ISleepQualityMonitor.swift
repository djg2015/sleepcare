//
//  ISleepQualityMonitor.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class ISleepQualityMonitor: UIView {
    
    @IBOutlet weak var process: CircularLoaderView!
    
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var imgMoveRight: UIImageView!
    @IBOutlet weak var imgMoveLeft: UIImageView!
    
    
    var sleepQualityViewModel:ISleepQualityMonitorViewModel = ISleepQualityMonitorViewModel()
    var lblSleepQuality:UILabel?
    var lblOnBedTimespan:UILabel?
    var lblDeepSleepTimespan:UILabel?
    var lblLightSleepTimespan:UILabel?
    var lblAwakeningTimespan:UILabel?
    
    func viewInit()
    {
        // 画出圆圈中间内容
        self.lblSleepQuality = UILabel(frame: CGRect(x: 0, y: 10, width: self.process.bounds.width, height: 40))
        self.lblSleepQuality!.textAlignment = .Center
        self.lblSleepQuality!.font = UIFont.boldSystemFontOfSize(50)
        self.lblSleepQuality!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblSleepQuality!)
        
        var lbl1 = UILabel(frame: CGRect(x: 0, y: 60, width: self.process.bounds.width/2 - 5, height: 12))
        lbl1.textAlignment = .Right
        lbl1.font = UIFont.boldSystemFontOfSize(10)
        lbl1.textColor = UIColor.whiteColor()
        lbl1.text = "总时长"
        self.process.centerTitleView?.addSubview(lbl1)
        
        self.lblOnBedTimespan = UILabel(frame: CGRect(x: self.process.bounds.width/2 + 5, y: 60, width: self.process.bounds.width/2 - 5, height: 12))
        self.lblOnBedTimespan!.textAlignment = .Left
        self.lblOnBedTimespan!.font = UIFont.boldSystemFontOfSize(10)
        self.lblOnBedTimespan!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblOnBedTimespan!)
        
        var lbl2 = UILabel(frame: CGRect(x: 0, y: 72, width: self.process.bounds.width/2 - 5, height: 12))
        lbl2.textAlignment = .Right
        lbl2.font = UIFont.boldSystemFontOfSize(10)
        lbl2.textColor = UIColor.whiteColor()
        lbl2.text = "深睡时长"
        self.process.centerTitleView?.addSubview(lbl2)
        
        self.lblDeepSleepTimespan = UILabel(frame: CGRect(x: self.process.bounds.width/2 + 5, y: 72, width: self.process.bounds.width/2 - 5, height: 12))
        self.lblDeepSleepTimespan!.textAlignment = .Left
        self.lblDeepSleepTimespan!.font = UIFont.boldSystemFontOfSize(10)
        self.lblDeepSleepTimespan!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblDeepSleepTimespan!)
        
        var lbl3 = UILabel(frame: CGRect(x: 0, y: 84, width: self.process.bounds.width/2 - 5, height: 12))
        lbl3.textAlignment = .Right
        lbl3.font = UIFont.boldSystemFontOfSize(10)
        lbl3.textColor = UIColor.whiteColor()
        lbl3.text = "浅睡时长"
        self.process.centerTitleView?.addSubview(lbl3)
        
        self.lblLightSleepTimespan = UILabel(frame: CGRect(x: self.process.bounds.width/2 + 5, y: 84, width: self.process.bounds.width/2 - 5, height: 12))
        self.lblLightSleepTimespan!.textAlignment = .Left
        self.lblLightSleepTimespan!.font = UIFont.boldSystemFontOfSize(10)
        self.lblLightSleepTimespan!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblLightSleepTimespan!)
        
        var lbl4 = UILabel(frame: CGRect(x: 0, y: 96, width: self.process.bounds.width/2 - 5, height: 12))
        lbl4.textAlignment = .Right
        lbl4.font = UIFont.boldSystemFontOfSize(10)
        lbl4.textColor = UIColor.whiteColor()
        lbl4.text = "觉醒时长"
        self.process.centerTitleView?.addSubview(lbl4)
        
        self.lblAwakeningTimespan = UILabel(frame: CGRect(x: self.process.bounds.width/2 + 5, y: 96, width: self.process.bounds.width/2, height: 12))
        self.lblAwakeningTimespan!.textAlignment = .Left
        self.lblAwakeningTimespan!.font = UIFont.boldSystemFontOfSize(10)
        self.lblAwakeningTimespan!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblAwakeningTimespan!)
        
        
        RACObserve(self.sleepQualityViewModel, "ProcessMaxValue") ~> RAC(self.process, "maxProcess")
        RACObserve(self.sleepQualityViewModel, "ProcessValue") ~> RAC(self.process, "currentProcess")
        RACObserve(self.sleepQualityViewModel, "SleepQuality") ~> RAC(self.lblSleepQuality, "text")
        RACObserve(self.sleepQualityViewModel, "OnBedTimespan") ~> RAC(self.lblOnBedTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "DeepSleepTimespan") ~> RAC(self.lblDeepSleepTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "LightSleepTimespan") ~> RAC(self.lblLightSleepTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "AwakeningTimespan") ~> RAC(self.lblAwakeningTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "SelectedDate") ~> RAC(self.lblSelectDate, "text")

        
        self.sleepQualityViewModel.SelectedDate = getCurrentTime("yyyy-MM-dd")
        
        // 给图片添加手势
        self.imgMoveLeft.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveLeft:")
        self.imgMoveLeft.addGestureRecognizer(singleTap)
        
        self.imgMoveRight.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveRight:")
        self.imgMoveRight.addGestureRecognizer(singleTap1)
    }
    
    func moveLeft(sender:UITapGestureRecognizer)
    {
        self.sleepQualityViewModel.SelectedDate = Date(string: self.sleepQualityViewModel.SelectedDate, format: "yyyy-MM-dd").addDays(-1).description(format: "yyyy-MM-dd")
    }
    
    func moveRight(sender:UITapGestureRecognizer)
    {
        self.sleepQualityViewModel.SelectedDate = Date(string: self.sleepQualityViewModel.SelectedDate, format: "yyyy-MM-dd").addDays(1).description(format: "yyyy-MM-dd")
    }
    
}
