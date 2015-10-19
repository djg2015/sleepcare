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
    
    var _signReports:Array<SignReport>?
    dynamic var SignReports:Array<SignReport>?{
        didSet{
            var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 10, self.uiHRRR.frame.width, self.uiHRRR.frame.height))
            lineChart.yLabelFormat = "%1.1f"
            lineChart.showLabel = true
            lineChart.backgroundColor = UIColor.clearColor()
            lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
            lineChart.showCoordinateAxis = true
            
            
            // Line Chart Nr.1
            var data01Array: [CGFloat] = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2,90,100,110]
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "心率"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            
            var data02Array: [CGFloat] = [11, 30, 70, 8, 12, 13, 20,12,20,30]
            var data02:PNLineChartData = PNLineChartData()
            data02.color = PNGreyColor
            data02.itemCount = UInt(data01Array.count)
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
        let date = "2015-10-16"
        if(date == ""){
           let date = getCurrentTime("yyyy-MM-dd")
        }
       sleepcareDetailViewModel = SleepcareDetailViewModel(userCode: userCode, date: date)
    }
    
    
}
