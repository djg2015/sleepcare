//
//  IHRMonitor.swift
//
//
//  Created by djg on 15/11/11.
//
//

import UIKit

class IHRMonitor: UIView{
    
    @IBOutlet weak var lblOnBedStatus: UILabel!
    
    @IBOutlet weak var processHR: CircularLoaderView!
    
    @IBOutlet weak var lblLastHR: UILabel!
    
    @IBOutlet weak var viewChart: BackgroundCommon!
    
    @IBOutlet weak var lblBedUserName: UILabel!
    var hrMonitorViewModel:IHRMonitorViewModel?
    var parentController:IBaseViewController!
    var lblHR:UILabel!
    var _bedUserCode:String = ""
    var _bedUserName:String = ""
    
    var HRdelegate:LoadingHRDelegate!
    var loadingFlag:Bool = false
    
    var _hrTimeReportList:Array<IHRTimeReport> = Array<IHRTimeReport>()
    var HRTimeReportList:Array<IHRTimeReport> = [] {
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
            for(var i = 0 ;i < self.hrMonitorViewModel!.HRTimeReport.count;i++){
                var xlable = self.hrMonitorViewModel!.HRTimeReport[i].ReportHour
                lineChart!.xLabels.append(xlable)
            }
            lineChart!.showCoordinateAxis = true
            
            //设置心率曲线
            var data01Array: [CGFloat] = []
            for(var i = 0 ;i < self.hrMonitorViewModel!.HRTimeReport.count;i++){
                data01Array.append(self.hrMonitorViewModel!.HRTimeReport[i].AvgHRNumber)
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
            data01.inflexionPointStyle = PNLineChartPointStyle.Circle
            
            if(self.viewChart.subviews.count == 0){
                lineChart!.chartData = [data01]
                lineChart!.strokeChart()
                self.viewChart.addSubview(lineChart!)
                
                
                lineChart!.legendStyle = PNLegendItemStyle.Serial
                //                lineChart.legendFont.fontWithSize(12)
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
    
    
    func viewInit(parentController:IBaseViewController?,bedUserCode:String,bedUserName:String)
    {
        hrMonitorViewModel = IHRMonitorViewModel(bedUserCode: bedUserCode)
        self._bedUserCode = bedUserCode
        self._bedUserName = bedUserName
        
        self.parentController = parentController
        //        self._bedUserCode = bedUserCode
        // 画出圆圈中间内容
        self.lblHR = UILabel(frame: CGRect(x: 0, y: 40, width: self.processHR.bounds.width/2 + 20, height: 60))
        self.lblHR!.textAlignment = .Center
        self.lblHR!.font = UIFont.systemFontOfSize(60)
        self.lblHR!.textColor = UIColor.whiteColor()
        self.processHR.centerTitleView?.addSubview(self.lblHR!)
        
        var lbl1 = UILabel(frame: CGRect(x: self.processHR.bounds.width/2 + 25, y: 78, width: self.processHR.bounds.width/2 - 20, height: 12))
        lbl1.textAlignment = .Left
        lbl1.font = UIFont.systemFontOfSize(16)
        lbl1.textColor = UIColor.whiteColor()
        lbl1.text = "次/分"
        self.processHR.centerTitleView?.addSubview(lbl1)
        
        RACObserve(self.hrMonitorViewModel, "OnBedStatus") ~> RAC(self.lblOnBedStatus, "text")
        RACObserve(self.hrMonitorViewModel, "CurrentHR") ~> RAC(self.lblHR, "text")
        RACObserve(self.hrMonitorViewModel, "LastAvgHR") ~> RAC(self.lblLastHR, "text")
        RACObserve(self.hrMonitorViewModel, "ProcessMaxValue") ~> RAC(self.processHR, "maxProcess")
        RACObserve(self.hrMonitorViewModel, "ProcessValue") ~> RAC(self.processHR, "currentProcess")
        
        self.hrMonitorViewModel!.BedUserCode = bedUserCode
        //        RACObserve(self, "_bedUserCode") ~> RAC(self.hrMonitorViewModel, "BedUserCode")
        RACObserve(self.hrMonitorViewModel, "HRTimeReport") ~> RAC(self, "HRTimeReportList")
        RACObserve(self, "_bedUserName") ~> RAC(self.lblBedUserName, "text")
        
        RACObserve(self.hrMonitorViewModel, "LoadingFlag") ~> RAC(self, "loadingFlag")
        self.setTimer()
    }
    
    func setTimer(){
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer.fire()
    }
    
    func timerFireMethod(timer: NSTimer) {
        if self.loadingFlag && self.HRdelegate != nil{
      //  self.hrMonitorViewModel!.loadingFlag = true
            self.HRdelegate.CloseLoadingHR()
            self.hrMonitorViewModel!.LoadingFlag = false
        }
        
    }
    
    func Clean(){
    self.hrMonitorViewModel!.Clean()
    }
}

protocol LoadingHRDelegate{
func CloseLoadingHR()
}
