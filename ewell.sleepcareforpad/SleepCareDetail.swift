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
    @IBOutlet var lblHR: UILabel!
    @IBOutlet var lblAvgHR: UILabel!
    @IBOutlet var lblRR: UILabel!
    @IBOutlet var lblAvgRR: UILabel!
    @IBOutlet var lblLeaveBedTimes: UILabel!
    @IBOutlet var lblMaxLeaveSpan: UILabel!
    @IBOutlet var lblLeaveSugest: UILabel!
    @IBOutlet var lblTurnTimes: UILabel!
    @IBOutlet var lblTrunRate: UILabel!
    @IBOutlet var uiTrun: UIView!
    @IBOutlet var uiSleep: UIView!
    
    
    var _signReports:Array<SignReport>?
    dynamic var SignReports:Array<SignReport>?{
        didSet{
            var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 10, self.uiHRRR.frame.width, self.uiHRRR.frame.height))
            lineChart.yLabelFormat = "%1.1f"
            lineChart.showLabel = true
            lineChart.backgroundColor = UIColor.clearColor()
            for i in 0...(self.SignReports!.count - 1){
                lineChart.xLabels[i] = self.SignReports![i].ReportHour
            }
            //lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
            lineChart.showCoordinateAxis = true
            
            
            //设置心率曲线
            var data01Array: [CGFloat] = []
            for i in 0...(self.SignReports!.count - 1){
                data01Array[i] = CGFloat((self.SignReports![i].AVGHR as NSString).floatValue)
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
            for i in 0...(self.SignReports!.count - 1){
                data02Array[i] = CGFloat((self.SignReports![i].AVGRR as NSString).floatValue)
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
            
            lineChart.chartData = [data01,data02]
            lineChart.strokeChart()
            self.uiHRRR.addSubview(lineChart)
            
            lineChart.legendStyle = PNLegendItemStyle.Stacked
            lineChart.legendFontSize = 12
            let legend = lineChart.getLegendWithMaxWidth(self.uiHRRR.frame.width)
            legend.frame = CGRectMake(self.uiHRRR.frame.width - 70, 20, self.uiHRRR.frame.width, self.uiHRRR.frame.height)
            self.uiHRRR.addSubview(legend)
            
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
        sleepcareDetailViewModel = SleepcareDetailViewModel(userCode:sleepcareDetailViewModel!.userCode, date: date)
    }
    
}
