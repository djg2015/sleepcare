//
//  SleepViewController.swift
//  
//
//  Created by Qinyuan Liu on 4/21/16.
//
//

import UIKit

class SleepViewController: UIViewController,SelectDateEndDelegate,SelectDateDelegate {
    @IBOutlet weak var process: CircularLoaderView!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var viewSleepQuality: BackgroundCommon!
    @IBOutlet weak var lblTotalTime: UILabel!
    

    //点击操作，查看当前日期的昨天／明天
    @IBAction func moveLeft(sender:AnyObject)
    {
        self.sleepQualityViewModel!.SelectedDate = Date(string: self.sleepQualityViewModel!.SelectedDate, format: "yyyy-MM-dd").addDays(-1).description(format: "yyyy-MM-dd")
    }
    
    @IBAction func moveRight(sender:AnyObject)
    {
        self.sleepQualityViewModel!.SelectedDate = Date(string: self.sleepQualityViewModel!.SelectedDate, format: "yyyy-MM-dd").addDays(1).description(format: "yyyy-MM-dd")
    }

    //把睡眠周报表发送到email邮箱
    @IBAction func showDownload(sender:AnyObject)
    {
   //     self.performSegueWithIdentifier("SendEmail", sender: self)
        if self._bedUserCode == ""{
        showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
        }
        else{
        self.email = IEmailViewController(nibName: "IEmailView", bundle: nil)
        self.email!.BedUserCode = self._bedUserCode!
        self.email!.SleepDate = self.sleepQualityViewModel!.SelectedDate
        self.email!.ParentController = self
        var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack:"NO",
            KNSemiModalOptionKeys.animationDuration:"0.2",KNSemiModalOptionKeys.shadowOpacity:"0.3"]
        
        self.presentSemiViewController(self.email, withOptions: kNSemiModalOptionKeys)
        }
    }
    
    //点击查看周睡眠
     @IBAction func showWeekSleep(sender:AnyObject){
        
        if self._bedUserCode == ""{
            showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
        }
        else{
             //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:UIScreen.mainScreen().bounds)
        alertview.detegate = self
        self.view.addSubview(alertview)
        }
    }
    
    @IBAction func CloseWeekReport(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    var _bedUserCode:String!
    var sleepReportDate:String!
    var email:IEmailViewController?
    var sleepQualityViewModel:ISleepQualityMonitorViewModel?
    var lblSleepQuality:UILabel?
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
                lineChart = PNLineChart(frame: CGRectMake(0, 10,  UIScreen.mainScreen().bounds.size.width-10, (UIScreen.mainScreen().bounds.size.height-49) * 23/55 - 10))
            }
            
            lineChart!.yFixedValueMin = 1
            lineChart!.showLabel = true
            lineChart!.backgroundColor = UIColor.clearColor()
            lineChart!.xLabels = []
            for(var i = 0 ;i < self.sleepQualityViewModel!.SleepRange.count;i++){
                var xlable = self.sleepQualityViewModel!.SleepRange[i].WeekDay
                lineChart!.xLabels.append(xlable)
                if(self.sleepQualityViewModel!.SleepRange[i].ReportDate == self.sleepQualityViewModel!.SelectedDate)
                {
                    
                }
            }
            lineChart!.showCoordinateAxis = true
            
            //设置在床曲线
            var data01Array: [CGFloat] = []
            for(var i = 0 ;i < self.sleepQualityViewModel!.SleepRange.count;i++){
                data01Array.append(self.sleepQualityViewModel!.SleepRange[i].OnBedTimespanMinutes)
            }
            var data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = UInt(data01Array.count)
            data01.dataTitle = "在床(小时)"
            data01.getData = ({(index: UInt)  in
                var yValue:CGFloat = data01Array[Int(index)]
                var item = PNLineChartDataItem(y: yValue)
                return item
            })
            data01.inflexionPointStyle = PNLineChartPointStyle.Circle
            
            //设置睡眠曲线
            var data02Array: [CGFloat] = []
            for(var i = 0 ;i < self.sleepQualityViewModel!.SleepRange.count;i++){
                data02Array.append(self.sleepQualityViewModel!.SleepRange[i].SleepTimespanMinutes)
            }
            var data02:PNLineChartData = PNLineChartData()
            data02.color = PNGreyColor
            data02.itemCount = UInt(data02Array.count)
            data02.dataTitle = "睡眠(小时)"
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
                if(data01.itemCount > 0 || data02.itemCount > 0)
                {
                   lineChart!.updateChartData([data01,data02])
                }
                else{
                    for subview in self.viewSleepQuality.subviews{
                        subview.removeFromSuperview()
                    }
                }
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
            self._bedUserCode = SessionForIphone.GetSession()?.CurPatientCode
        self.sleepQualityViewModel?.BedUserCode = self._bedUserCode
        self.sleepQualityViewModel!.loadPatientSleep(self._bedUserCode)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WeekReport" {
            let vc = segue.destinationViewController as! IWeekSleepcareController
            vc.bedUserCode = self._bedUserCode
            vc.sleepDate = self.sleepReportDate
            
        }
//        else if segue.identifier == "SendEmail" {
//            let vc = segue.destinationViewController as! IEmailViewController
//            vc.BedUserCode = self._bedUserCode
//            vc.SleepDate = self.sleepReportDate
//        }
        
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
   
       
    self.sleepQualityViewModel = ISleepQualityMonitorViewModel()
        
       
        // 画出圆圈中间内容
        self.lblSleepQuality = UILabel(frame: CGRect(x: 0, y: 10, width: self.process.bounds.width, height: 40))
        self.lblSleepQuality!.textAlignment = .Center
        self.lblSleepQuality!.font = UIFont.boldSystemFontOfSize(50)
        self.lblSleepQuality!.textColor = UIColor.whiteColor()
        self.process.centerTitleView?.addSubview(self.lblSleepQuality!)
        
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
        
        RACObserve(self.sleepQualityViewModel, "OnBedTimespan") ~> RAC(self.lblTotalTime, "text")
        RACObserve(self.sleepQualityViewModel, "ProcessMaxValue") ~> RAC(self.process, "maxProcess")
        RACObserve(self.sleepQualityViewModel, "ProcessValue") ~> RAC(self.process, "currentProcess")
        RACObserve(self.sleepQualityViewModel, "SleepQuality") ~> RAC(self.lblSleepQuality, "text")
        RACObserve(self.sleepQualityViewModel, "DeepSleepTimespan") ~> RAC(self.lblDeepSleepTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "LightSleepTimespan") ~> RAC(self.lblLightSleepTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "AwakeningTimespan") ~> RAC(self.lblAwakeningTimespan, "text")
        RACObserve(self.sleepQualityViewModel, "SelectedDate") ~> RAC(self.lblSelectDate, "text")
        RACObserve(self.sleepQualityViewModel, "SleepRange") ~> RAC(self, "SleepRange")
        
        self.sleepQualityViewModel!.SelectedDate = getCurrentTime("yyyy-MM-dd")
        
        self.lblSelectDate.userInteractionEnabled = true
        var singleTap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "LableChooseDate:")
        self.lblSelectDate.addGestureRecognizer(singleTap5)
        
    }
    //点击date弹出选择日期的控件
    func LableChooseDate(sender:UITapGestureRecognizer){
        var devicebounds:CGRect = UIScreen.mainScreen().bounds
        
        //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:devicebounds)
        alertview.datedelegate = self
        self.view.addSubview(alertview)
    }
    
    func SelectDate(sender: UIView, dateString: String) {
        self.sleepQualityViewModel!.SelectedDate = dateString
    }
    
    
  
   
    //对日期控件，选中某天查看对应的周睡眠
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        
        //若当前bedusercode ＝“”，则弹窗提示不可以查看
        
        
       self.sleepReportDate = dateString
       self.performSegueWithIdentifier("WeekReport", sender: self)
        
    }
    
    
}
