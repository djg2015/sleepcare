//
//  ISleepQualityMonitor.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class ISleepQualityMonitor: UIView,THDateChoosedDelegate,SelectDateEndDelegate {
    
    @IBOutlet weak var process: CircularLoaderView!
    
    @IBOutlet weak var imgDownload: UIImageView!
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var imgMoveRight: UIImageView!
    @IBOutlet weak var imgMoveLeft: UIImageView!
    @IBOutlet weak var viewSleepQuality: BackgroundCommon!
    
    @IBOutlet weak var imgWeekSleep: UIImageView!
    @IBOutlet weak var lblWeekSleep: UILabel!
    
    var parentController:IBaseViewController!
    var _bedUserCode:String?
    var calendarControl:THDate!
    var email:IEmailViewController?
    
    var sleepQualityViewModel:ISleepQualityMonitorViewModel = ISleepQualityMonitorViewModel()
    var lblSleepQuality:UILabel?
    var lblOnBedTimespan:UILabel?
    var lblDeepSleepTimespan:UILabel?
    var lblLightSleepTimespan:UILabel?
    var lblAwakeningTimespan:UILabel?
    
    // 当前周每天的睡眠质量
    var _sleepRange:Array<ISleepDateReport> = Array<ISleepDateReport>()
    var SleepRange:Array<ISleepDateReport> = [] {
        didSet{
            //设置周睡眠图表
            var lineChart:PNLineChart?
            if(self.viewSleepQuality.subviews.count != 0){
                lineChart = (self.viewSleepQuality.subviews[0] as? PNLineChart)!
            }
            else
            {
                lineChart = PNLineChart(frame: CGRectMake(0, 10,  UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 206/522 - 30))
                
            }
            
            lineChart!.yFixedValueMin = 1
            lineChart!.showLabel = true
            lineChart!.backgroundColor = UIColor.clearColor()
            lineChart!.xLabels = []
            for(var i = 0 ;i < self.sleepQualityViewModel.SleepRange.count;i++){
                var xlable = self.sleepQualityViewModel.SleepRange[i].WeekDay
                lineChart!.xLabels.append(xlable)
                if(self.sleepQualityViewModel.SleepRange[i].ReportDate == self.sleepQualityViewModel.SelectedDate)
                {
                    
                }
            }
            lineChart!.showCoordinateAxis = true
            
            //设置在床曲线
            var data01Array: [CGFloat] = []
            for(var i = 0 ;i < self.sleepQualityViewModel.SleepRange.count;i++){
                data01Array.append(self.sleepQualityViewModel.SleepRange[i].OnBedTimespanMinutes)
            }
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "在床时间"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            data01.inflexionPointStyle = PNLineChartPointStyle.Circle
            
            //设置睡眠曲线
            var data02Array: [CGFloat] = []
            for(var i = 0 ;i < self.sleepQualityViewModel.SleepRange.count;i++){
                data02Array.append(self.sleepQualityViewModel.SleepRange[i].SleepTimespanMinutes)
            }
            var data02:PNLineChartData = PNLineChartData()
            data02.color = PNGreyColor
            data02.itemCount = UInt(data02Array.count)
            data02.dataTitle = "睡眠时间"
            data02.getData = ({(index: UInt)  in
                var yValue:CGFloat = data02Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)

                return item
            })
            data02.inflexionPointStyle = PNLineChartPointStyle.Circle
            
            if(self.viewSleepQuality.subviews.count == 0){
                lineChart!.chartData = [data01,data02]
                lineChart!.strokeChart()
                self.viewSleepQuality.addSubview(lineChart!)
                
                
                lineChart!.legendStyle = PNLegendItemStyle.Serial
                //                lineChart.legendFont.fontWithSize(12)
                let legend = lineChart!.getLegendWithMaxWidth(self.viewSleepQuality.frame.width)
                legend.frame = CGRectMake(65, 5, self.viewSleepQuality.frame.width - 10, self.viewSleepQuality.frame.height - 10)
                self.viewSleepQuality.addSubview(legend)
            }
            else{
                if(data01.itemCount > 0 && data02.itemCount > 0)
                {
                    lineChart!.updateChartData([data01,data02])
                }
            }
        }
    }
    
    
    func viewInit(parentController:IBaseViewController?,bedUserCode:String)
    {
        self.parentController = parentController
        self._bedUserCode = bedUserCode
        self.calendarControl = THDate(parentControl: parentController!)
        self.calendarControl.delegate = self
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
        RACObserve(self, "_bedUserCode") ~> RAC(self.sleepQualityViewModel, "BedUserCode")
        RACObserve(self.sleepQualityViewModel, "SleepRange") ~> RAC(self, "SleepRange")
        
        self.sleepQualityViewModel.SelectedDate = getCurrentTime("yyyy-MM-dd")
        
        if(self.email == nil){
            self.email = IEmailViewController(nibName: "IEmailView", bundle: nil)
            self.email?.BedUserCode = self._bedUserCode!
            self.email?.SleepDate = self.sleepQualityViewModel.SelectedDate
            self.email?.ParentController = self.parentController
        }
        
        // 给图片添加手势
        self.imgMoveLeft.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveLeft:")
        self.imgMoveLeft.addGestureRecognizer(singleTap)
        
        self.imgMoveRight.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveRight:")
        self.imgMoveRight.addGestureRecognizer(singleTap1)
        
        self.imgCalendar.userInteractionEnabled = true
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showCalendar:")
        self.imgCalendar.addGestureRecognizer(singleTap2)
        
        self.imgDownload.userInteractionEnabled = true
        var singleTap3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showDownload:")
        self.imgDownload.addGestureRecognizer(singleTap3)
        
        //周睡眠查看
        self.imgWeekSleep.userInteractionEnabled = true
        var singleTap4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showWeekSleep:")
        self.imgWeekSleep.addGestureRecognizer(singleTap4)
        
        self.lblWeekSleep.userInteractionEnabled = true
        var singleTap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showWeekSleep:")
        self.lblWeekSleep.addGestureRecognizer(singleTap5)

        
    }
    
    //显示周睡眠
    func showWeekSleep(sender:UITapGestureRecognizer){
    
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        
        //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:devicebounds)
        alertview.detegate = self
        self.addSubview(alertview)
    }
    
    //选中某天查看对应的周睡眠
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        let controller = IWeekSleepcareController(nibName:"IWeekSleepcare", bundle:nil,bedusercode:"",searchdate:"")
        self.parentController.presentViewController(controller, animated: true, completion: nil)
    }
    
    func moveLeft(sender:UITapGestureRecognizer)
    {
        self.sleepQualityViewModel.SelectedDate = Date(string: self.sleepQualityViewModel.SelectedDate, format: "yyyy-MM-dd").addDays(-1).description(format: "yyyy-MM-dd")
    }
    
    func moveRight(sender:UITapGestureRecognizer)
    {
        self.sleepQualityViewModel.SelectedDate = Date(string: self.sleepQualityViewModel.SelectedDate, format: "yyyy-MM-dd").addDays(1).description(format: "yyyy-MM-dd")
    }
    
    func showCalendar(sender:UITapGestureRecognizer)
    {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.calendarControl.ShowDate(date:getDateTime(self.sleepQualityViewModel.SelectedDate),returnformat: formatter)
    }
    
    func showDownload(sender:UITapGestureRecognizer)
    {
        var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack:"NO",
            KNSemiModalOptionKeys.animationDuration:"1.0",KNSemiModalOptionKeys.shadowOpacity:"0.3"]
        self.parentController.presentSemiViewController(self.email, withOptions: kNSemiModalOptionKeys)
    }
    
    func ChoosedDate(choosedDate:String?){
        self.sleepQualityViewModel.SelectedDate = choosedDate!
    }
}
