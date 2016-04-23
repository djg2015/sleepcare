//
//  HRViewController.swift
//  
//
//  Created by Qinyuan Liu on 4/20/16.
//
//

import UIKit

class HRViewController: UIViewController {
     @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var lblOnBedStatus: UILabel!
    @IBOutlet weak var processHR: CircularLoaderView!
    @IBOutlet weak var lblLastHR: UILabel!
    @IBOutlet weak var viewChart: BackgroundCommon!
    @IBOutlet weak var lblBedUserName: UILabel!
    
     var hrMonitorViewModel:IHRMonitorViewModel!
    var lblHR:UILabel!
    var _bedUserCode:String!
    var _bedUserName:String!
    
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
          lineChart = PNLineChart(frame: CGRectMake(0, 10,  UIScreen.mainScreen().bounds.size.width-10, (UIScreen.mainScreen().bounds.size.height-49) * 27/59 - 10))
            //    lineChart = PNLineChart(frame: CGRectMake(10, 10,  viewChart.frame.width-10, viewChart.frame.height-10))
                
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
            data01.dataTitle = "心率(次/分)"
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
        self.hrMonitorViewModel!.BedUserCode = _bedUserCode
        self.hrMonitorViewModel!.BedUserName = _bedUserName
        
    
        self.hrMonitorViewModel!.loadPatientHR(_bedUserCode)
       
        
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
    
    
    //加载初始画面
    func rac_settings(){
        self.hrMonitorViewModel = IHRMonitorViewModel()

        // 画出圆圈中间内容
        self.lblHR = UILabel(frame: CGRect(x: 0, y: 36, width: self.processHR.bounds.width/2 + 25, height: 54))
        self.lblHR!.textAlignment = .Center
        self.lblHR!.font = UIFont.systemFontOfSize(54)
        self.lblHR!.textColor = UIColor.whiteColor()
        self.processHR.centerTitleView?.addSubview(self.lblHR!)
        
        var lbl1 = UILabel(frame: CGRect(x: self.processHR.bounds.width/2 + 26, y: 70, width: 45, height: 14))
        lbl1.textAlignment = .Center
        lbl1.font = UIFont.systemFontOfSize(14)
        lbl1.textColor = UIColor.whiteColor()
        lbl1.text = "次/分"
        self.processHR.centerTitleView?.addSubview(lbl1)
        
        RACObserve(self.hrMonitorViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.hrMonitorViewModel, "OnBedStatus") ~> RAC(self.lblOnBedStatus, "text")
        RACObserve(self.hrMonitorViewModel, "CurrentHR") ~> RAC(self.lblHR, "text")
        RACObserve(self.hrMonitorViewModel, "LastAvgHR") ~> RAC(self.lblLastHR, "text")
        RACObserve(self.hrMonitorViewModel, "ProcessMaxValue") ~> RAC(self.processHR, "maxProcess")
        RACObserve(self.hrMonitorViewModel, "ProcessValue") ~> RAC(self.processHR, "currentProcess")
        RACObserve(self.hrMonitorViewModel, "HRTimeReport") ~> RAC(self, "HRTimeReportList")
        RACObserve(self.hrMonitorViewModel, "BedUserName") ~> RAC(self.lblBedUserName, "text")
    }
   
}
