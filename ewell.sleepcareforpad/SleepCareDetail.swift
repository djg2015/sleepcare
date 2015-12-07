//
//  SleepCareListController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

public let PNGreenColor = UIColor(red: 77.0 / 255.0 , green: 196.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
public let PNGreyColor = UIColor(red: 186.0 / 255.0 , green: 186.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
public let PNLightGreyColor = UIColor(red: 246.0 / 255.0 , green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)

class SleepCareDetail: UIView {
    
    @IBOutlet weak var lblDeepSleepSpan: UILabel!
    @IBOutlet weak var lblLightSleepSpan: UILabel!
    @IBOutlet weak var lblOnBedSpan: UILabel!
    @IBOutlet weak var uiHRRR: UIView!
    @IBOutlet weak var lblHR: UILabel!
    @IBOutlet weak var lblAvgHR: UILabel!
    @IBOutlet weak var lblRR: UILabel!
    @IBOutlet weak var lblAvgRR: UILabel!
    @IBOutlet weak var lblLeaveBedTimes: UILabel!
    @IBOutlet weak var lblMaxLeaveSpan: UILabel!
    @IBOutlet weak var lblLeaveSugest: UILabel!
    @IBOutlet weak var lblTurnTimes: UILabel!
    @IBOutlet weak var lblTrunRate: UILabel!
    @IBOutlet weak var uiTrun: UIView!
    @IBOutlet weak var uiSleep: UIView!
    
    var _signReports:Array<SignReport>?
    dynamic var SignReports:Array<SignReport>?{
        didSet{
            
            if(self.SignReports == nil){
                for(var i = 0 ; i < self.uiTrun.subviews.count; i++) {
                    self.uiTrun.subviews[i].removeFromSuperview()
                }
                for(var i = 0 ; i < self.uiHRRR.subviews.count; i++) {
                    self.uiHRRR.subviews[i].removeFromSuperview()
                }
                return
            }
            
            //设置心率曲线
            var data01Array: [CGFloat] = []
            for(var i = self.SignReports!.count - 1 ;i >= 0;i--){
                data01Array.append(CGFloat((self.SignReports![i].AVGHR as NSString).floatValue))
            }
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "心率"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            //设置呼吸曲线
            var data02Array: [CGFloat] = []
            for(var i = self.SignReports!.count - 1 ;i >= 0;i--){
                data02Array.append(CGFloat((self.SignReports![i].AVGRR as NSString).floatValue))
            }
            var data02:PNLineChartData = PNLineChartData()
            data02.color = PNGreyColor
            data02.itemCount = UInt(data02Array.count)
            data02.dataTitle = "呼吸"
            data02.getData = ({(index: UInt)  in
                var yValue:CGFloat = data02Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            var lineChart:PNLineChart? = PNLineChart(frame: CGRectMake(0, 10, self.uiHRRR.frame.width, self.uiHRRR.frame.height))
            if( self.uiHRRR.subviews.count != 0){
                lineChart = self.uiHRRR.subviews[0] as? PNLineChart
            }
            
            lineChart!.yLabelFormat = "%1.1f"
            lineChart!.yFixedValueMin = 10
            lineChart!.showLabel = true
            lineChart!.backgroundColor = UIColor.clearColor()
            lineChart!.xLabels = []
            for(var i = self.SignReports!.count - 1 ;i >= 0;i--){
                var xlable = self.SignReports![i].ReportHour.subString(11, length: 2)
                if(xlable.hasPrefix("0")){
                    xlable = xlable.subString(1, length: 1)
                }
                xlable = xlable + "点"
                lineChart!.xLabels.append(xlable)
            }
            //lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
            lineChart!.showCoordinateAxis = true
            
            if( self.uiHRRR.subviews.count == 0){
                lineChart!.chartData = [data01,data02]
                lineChart!.strokeChart()
                self.uiHRRR.addSubview(lineChart!)
                
                
                lineChart!.legendStyle = PNLegendItemStyle.Stacked
                //(lineChart!.legendFont as UIFont).fontWithSize(12)
                let legend = lineChart!.getLegendWithMaxWidth(self.uiHRRR.frame.width)
                legend.frame = CGRectMake(self.uiHRRR.frame.width - 65, 5, self.uiHRRR.frame.width, self.uiHRRR.frame.height)
                self.uiHRRR.addSubview(legend)
            }
            else{
                lineChart!.updateChartData([data01,data02])
            }
            
            //设置翻身
            var trunlineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 10, self.uiTrun.frame.width, self.uiTrun.frame.height))
            if(self.uiTrun.subviews.count != 0){
                trunlineChart = (self.uiTrun.subviews[0] as? PNLineChart)!
            }
            //trunlineChart.yLabelFormat = "%1.1f"
            trunlineChart.showLabel = true
            trunlineChart.yFixedValueMin = 1
            trunlineChart.backgroundColor = UIColor.clearColor()
            trunlineChart.xLabels = []
            for(var i = self.SignReports!.count - 1 ;i >= 0;i--){
                var xlable = self.SignReports![i].ReportHour.subString(11, length: 2)
                if(xlable.hasPrefix("0")){
                    xlable = xlable.subString(1, length: 1)
                }
                xlable = xlable + "点"
                trunlineChart.xLabels.append(xlable)
            }
            trunlineChart.showCoordinateAxis = true
            
            
            //设置翻身曲线
            var data03Array: [CGFloat] = []
            for(var i = self.SignReports!.count - 1 ;i >= 0;i--){
                data03Array.append(CGFloat((self.SignReports![i].TurnOverTime as NSString).floatValue))
            }
            var data03:PNLineChartData = PNLineChartData()
            data03.color = UIColor.blueColor()
            data03.itemCount = UInt(data03Array.count)
            data03.dataTitle = "翻身次数"
            data03.getData = ({(index: UInt)  in
                var yValue:CGFloat = data03Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            if( self.uiTrun.subviews.count == 0){
                trunlineChart.chartData = [data03]
                trunlineChart.strokeChart()
                self.uiTrun.addSubview(trunlineChart)
                
                trunlineChart.legendStyle = PNLegendItemStyle.Stacked
//                trunlineChart.legendFont.fontWithSize(12)
                let trunlegend = trunlineChart.getLegendWithMaxWidth(self.uiTrun.frame.width)
                trunlegend.frame = CGRectMake(self.uiTrun.frame.width - 90, 5, self.uiTrun.frame.width, self.uiTrun.frame.height)
                self.uiTrun.addSubview(trunlegend)
            }
            else{
                trunlineChart.updateChartData([data03])
            }
        }
    }
    
    var _sleepCareReports:Array<SleepCareReport>?
    dynamic var SleepCareReports:Array<SleepCareReport>?{
        didSet{
            if(self.SleepCareReports == nil){
                for(var i = 0 ; i < self.uiSleep.subviews.count; i++) {
                    self.uiSleep.subviews[i].removeFromSuperview()
                }
                return
            }
            //设置周睡眠图表
            var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(10, 10, self.uiSleep.frame.width, self.uiSleep.frame.height))
            if(self.uiSleep.subviews.count != 0){
                lineChart = (self.uiSleep.subviews[0] as? PNLineChart)!
            }
            lineChart.yFixedValueMin = 1
            lineChart.showLabel = true
            lineChart.backgroundColor = UIColor.clearColor()
            lineChart.xLabels = []
            for(var i = self.SleepCareReports!.count - 1 ;i >= 0;i--){
                var xlable = self.SleepCareReports![i].ReportDate
                lineChart.xLabels.append(xlable)
            }
            //lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
            lineChart.showCoordinateAxis = true
            
            
            //设置在床曲线
            var data01Array: [CGFloat] = []
            for(var i = self.SleepCareReports!.count - 1 ;i >= 0;i--){
                data01Array.append(CGFloat(self.SleepCareReports![i].onBedTimeSpanALL))
            }
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "在床时长"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            //设置睡眠曲线
            var data02Array: [CGFloat] = []
            for(var i = self.SleepCareReports!.count - 1 ;i >= 0;i--){
                data02Array.append(CGFloat(self.SleepCareReports![i].SleepTimeSpanALL))
            }
            var data02:PNLineChartData = PNLineChartData()
            data02.color = PNGreyColor
            data02.itemCount = UInt(data02Array.count)
            data02.dataTitle = "睡眠时长"
            data02.getData = ({(index: UInt)  in
                var yValue:CGFloat = data02Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            if( self.uiSleep.subviews.count == 0){
                lineChart.chartData = [data01,data02]
                lineChart.strokeChart()
                self.uiSleep.addSubview(lineChart)
                
                
                lineChart.legendStyle = PNLegendItemStyle.Serial
//                lineChart.legendFont.fontWithSize(12)
                let legend = lineChart.getLegendWithMaxWidth(self.uiSleep.frame.width)
                legend.frame = CGRectMake(65, 5, self.uiSleep.frame.width, self.uiSleep.frame.height)
                self.uiSleep.addSubview(legend)
            }
            else{
                lineChart.updateChartData([data01,data02])
            }
        }
    }
    
    var sleepcareDetailViewModel:SleepcareDetailViewModel?
    //界面初始化
    func viewInit(userCode:String,date:String = ""){
        var curdate = date
        if(date == ""){
            var d = Date(string: getCurrentTime("yyyy-MM-dd"))
            d = d.addDays(-1)
            curdate = d.description(format: "yyyy-MM-dd")
        }
        
        sleepcareDetailViewModel = SleepcareDetailViewModel(userCode: userCode, date: curdate)
        RACObserve(self.sleepcareDetailViewModel, "SignReports") ~> RAC(self, "SignReports")
        RACObserve(self.sleepcareDetailViewModel, "SleepCareReports") ~> RAC(self, "SleepCareReports")
        RACObserve(self.sleepcareDetailViewModel, "DeepSleepSpan") ~> RAC(self.lblDeepSleepSpan, "text")
        RACObserve(self.sleepcareDetailViewModel, "LightSleepSpan") ~> RAC(self.lblLightSleepSpan, "text")
        RACObserve(self.sleepcareDetailViewModel, "OnbedSpan") ~> RAC(self.lblOnBedSpan, "text")
        RACObserve(self.sleepcareDetailViewModel, "HR") ~> RAC(self.lblHR, "text")
        RACObserve(self.sleepcareDetailViewModel, "AvgHR") ~> RAC(self.lblAvgHR, "text")
        RACObserve(self.sleepcareDetailViewModel, "RR") ~> RAC(self.lblRR, "text")
        RACObserve(self.sleepcareDetailViewModel, "AvgRR") ~> RAC(self.lblAvgRR, "text")
        RACObserve(self.sleepcareDetailViewModel, "LeaveBedTimes") ~> RAC(self.lblLeaveBedTimes, "text")
        RACObserve(self.sleepcareDetailViewModel, "MaxLeaveBedSpan") ~> RAC(self.lblMaxLeaveSpan, "text")
        RACObserve(self.sleepcareDetailViewModel, "LeaveSuggest") ~> RAC(self.lblLeaveSugest, "text")
        RACObserve(self.sleepcareDetailViewModel, "TrunTimes") ~> RAC(self.lblTurnTimes, "text")
        RACObserve(self.sleepcareDetailViewModel, "TurnOverRate") ~> RAC(self.lblTrunRate, "text")
    }
    
    //根据查询条件重新加载界面
    func ReloadView(date:String){
        self.sleepcareDetailViewModel!.loadData(sleepcareDetailViewModel!.userCode, date: date)
    }
    
}
