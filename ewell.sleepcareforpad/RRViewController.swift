//
//  RRViewController.swift
//  
//
//  Created by Qinyuan Liu on 4/20/16.
//
//

import UIKit

class RRViewController: IBaseViewController{

    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var lblOnBedStatus: UILabel!
    @IBOutlet weak var processRR: CircularLoaderView!
    @IBOutlet weak var lblLastRR: UILabel!
    @IBOutlet weak var viewChart: BackgroundCommon!
    @IBOutlet weak var lblBedUserName: UILabel!
    
    var rrMonitorViewModel:IRRMonitorViewModel!
    var lblRR:UILabel!
    var _bedUserCode:String!
    var _bedUserName:String!
 
    
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
                lineChart = PNLineChart(frame: CGRectMake(0, 10,  UIScreen.mainScreen().bounds.size.width-10, (UIScreen.mainScreen().bounds.size.height-49) * 21/53 - 10))
             //    lineChart = PNLineChart(frame: CGRectMake(10, 10,  viewChart.frame.width-10, viewChart.frame.height-10))
                
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
                else{
                    for subview in self.viewChart.subviews{
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    //在离床状态改变，对应改变圆点的颜色
    var statusImageName:String?
        {
        didSet{
            if statusImageName != nil{
                self.statusImage.image = UIImage(named:statusImageName!)
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self._bedUserCode = SessionForIphone.GetSession()?.CurPatientCode
        self._bedUserName = SessionForIphone.GetSession()?.CurPatientName
        if self.rrMonitorViewModel == nil{
        self.rrMonitorViewModel = IRRMonitorViewModel()
        }
        self.rrMonitorViewModel!.BedUserCode = _bedUserCode
        self.rrMonitorViewModel!.BedUserName = _bedUserName
        self.rrMonitorViewModel!.loadPatientRR(_bedUserCode)
      
        currentController = self

        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rac_settings()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rac_settings(){
       
        self.rrMonitorViewModel = IRRMonitorViewModel()

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
        RACObserve(self.rrMonitorViewModel, "RRTimeReport") ~> RAC(self, "RRTimeReportList")
        RACObserve(self.rrMonitorViewModel, "BedUserName") ~> RAC(self.lblBedUserName, "text")
    }
    
}
