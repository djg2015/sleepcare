//
//  IRRMonitor.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IRRMonitor: UIView{
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var lblOnBedStatus: UILabel!
    @IBOutlet weak var processRR: CircularLoaderView!
    @IBOutlet weak var lblLastRR: UILabel!
    @IBOutlet weak var viewChart: BackgroundCommon!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblBedUserName: UILabel!
    
    
    var rrMonitorViewModel:IRRMonitorViewModel?
    var parentController:IBaseViewController!
    var lblRR:UILabel!
    var _bedUserCode:String = ""
    var _bedUserName:String = ""
  //  var RRdelegate:LoadingRRDelegate!
    var loadingFlag:Bool = false
    
    var _rrTimeReportList:Array<IRRTimeReport> = Array<IRRTimeReport>()
    var RRTimeReportList:Array<IRRTimeReport> = [] {
        didSet{
            //设置小时心率图表
            var lineChart:PNLineChart?
            if(self.viewChart.subviews.count != 0){
                lineChart = (self.viewChart.subviews[0] as? PNLineChart)!
            }
            else
            {
                lineChart = PNLineChart(frame: CGRectMake(0, 10,  UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 206/522 - 30))
            }
            
            lineChart!.yFixedValueMin = 1
            lineChart!.showLabel = true
            lineChart!.backgroundColor = UIColor.clearColor()
            lineChart!.xLabels = []
            for(var i = 0 ;i < self.rrMonitorViewModel!.RRTimeReport.count;i++){
                var xlable = self.rrMonitorViewModel!.RRTimeReport[i].ReportHour
                lineChart!.xLabels.append(xlable)
            }
            lineChart!.showCoordinateAxis = true
            
            //设置心率曲线
            var data01Array: [CGFloat] = []
            for(var i = 0 ;i < self.rrMonitorViewModel!.RRTimeReport.count;i++){
                data01Array.append(self.rrMonitorViewModel!.RRTimeReport[i].AvgRRNumber)
            }
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "呼吸(次/分)"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            data01.inflexionPointStyle = PNLineChartPointStyle.Circle
            
            if(self.viewChart.subviews.count == 0){
                lineChart!.chartData = [data01]
                lineChart!.strokeChart()
                self.viewChart.addSubview(lineChart!)
                
                lineChart!.legendStyle = PNLegendItemStyle.Serial
                let legend = lineChart!.getLegendWithMaxWidth(self.viewChart.frame.width)
                legend.frame = CGRectMake(65, 5, self.viewChart.frame.width - 10, self.viewChart.frame.height - 10)
                self.viewChart.addSubview(legend)
            }
            else{
                if(data01.itemCount > 0)
                {
                    lineChart!.updateChartData([data01])
                }
            }
        }
    }
    
    //在离床状态改变，对应改变圆圈的颜色
    var statusImageName:String?
        {
        didSet{
            if statusImageName != nil{
                self.statusImage.image = UIImage(named:statusImageName!)
            }
        }
    }
    
    
    func viewInit(parentController:IBaseViewController?,bedUserCode:String,bedUserName:String)
    {
        rrMonitorViewModel = IRRMonitorViewModel(bedUserCode: bedUserCode)
        self._bedUserCode = bedUserCode
        self._bedUserName = bedUserName
        self.parentController = parentController
        self.topView.backgroundColor = themeColor[themeName]
       
        // 画出圆圈中间内容
        self.lblRR = UILabel(frame: CGRect(x: 0, y: 36, width: self.processRR.bounds.width/2 + 25, height: 54))
        self.lblRR!.textAlignment = .Center
        self.lblRR!.font = UIFont.systemFontOfSize(54)
        self.lblRR!.textColor = UIColor.whiteColor()
        self.processRR.centerTitleView?.addSubview(self.lblRR!)
        
        var lbl1 = UILabel(frame: CGRect(x: self.processRR.bounds.width/2 + 26, y: 70, width: 45, height: 14))
        lbl1.textAlignment = .Center
        lbl1.font = UIFont.systemFontOfSize(14)
        lbl1.textColor = UIColor.whiteColor()
        lbl1.text = "次/分"
        self.processRR.centerTitleView?.addSubview(lbl1)
        
        RACObserve(self.rrMonitorViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.rrMonitorViewModel, "OnBedStatus") ~> RAC(self.lblOnBedStatus, "text")
        RACObserve(self.rrMonitorViewModel, "CurrentRR") ~> RAC(self.lblRR, "text")
        RACObserve(self.rrMonitorViewModel, "LastAvgRR") ~> RAC(self.lblLastRR, "text")
        RACObserve(self.rrMonitorViewModel, "ProcessMaxValue") ~> RAC(self.processRR, "maxProcess")
        RACObserve(self.rrMonitorViewModel, "ProcessValue") ~> RAC(self.processRR, "currentProcess")
        RACObserve(self, "_bedUserCode") ~> RAC(self.rrMonitorViewModel, "BedUserCode")
        RACObserve(self.rrMonitorViewModel, "RRTimeReport") ~> RAC(self, "RRTimeReportList")
        RACObserve(self, "_bedUserName") ~> RAC(self.lblBedUserName, "text")
        RACObserve(self.rrMonitorViewModel, "LoadingFlag") ~> RAC(self, "loadingFlag")
        
     //   self.setTimer()
    }
   
    //定时器，隔0.5秒检查是否完全载入数据
//    func setTimer(){
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
//        timer.fire()
//    }
//    
//    func timerFireMethod(timer: NSTimer) {
//        if self.loadingFlag && self.RRdelegate != nil{
//            self.RRdelegate.CloseLoadingRR()
//            if self.rrMonitorViewModel != nil{
//            self.rrMonitorViewModel!.LoadingFlag = false
//        }
//    }
//    }
    
    func Clean(){
        if self.rrMonitorViewModel != nil{
            self.RRTimeReportList = []
            self.processRR = nil
            self.topView = nil
            self.viewChart = nil
            self.rrMonitorViewModel!.Clean()
            self.rrMonitorViewModel = nil
         
        }
    }
}

//protocol LoadingRRDelegate{
//    func CloseLoadingRR()
//}