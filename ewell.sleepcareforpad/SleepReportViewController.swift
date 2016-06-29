//
//  ViewController.swift
//  周报表demo
//
//  Created by Qinyuan Liu on 6/16/16.
//  Copyright (c) 2016 Qinyuan Liu. All rights reserved.
//

import UIKit

class SleepReportViewController: UIViewController,UIScrollViewDelegate,SelectDateDelegate  {
    
    @IBOutlet weak var mainscrollView: UIScrollView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func ChangeDate(sender:UIButton){
        if self.weekreportViewModel.bedusercode != ""{
            //设置日期弹出窗口
            var alertview:DatePickerView = DatePickerView(frame:UIScreen.mainScreen().bounds)
            alertview.datedelegate = self
            self.view.addSubview(alertview)
        }
    }
    
    @IBAction func SendEmail(sender:UIButton){
        if self.weekreportViewModel.bedusercode != ""{
            
            self.email = IEmailViewController(nibName: "IEmailView", bundle: nil)
            self.email!.BedUserCode = self.weekreportViewModel.bedusercode
            self.email!.SleepDate = self.weekreportViewModel.SelectDate
            self.email!.ParentController = self
            var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack:"NO",
                KNSemiModalOptionKeys.animationDuration:"0.2",KNSemiModalOptionKeys.shadowOpacity:"0.3"]
            
            self.presentSemiViewController(self.email, withOptions: kNSemiModalOptionKeys)
        }
        
    }
    
    
    
    var weekreportViewModel:WeekReportViewModel!
    var email:IEmailViewController?
    
    let screenwidth = UIScreen.mainScreen().bounds.width
    let hrFigureWidth = UIScreen.mainScreen().bounds.width / 4
    let rrFigureWidth = UIScreen.mainScreen().bounds.width / 4
    let sleepFigureWidth = (UIScreen.mainScreen().bounds.width-4)/3
    let suggestionFigureWidth = (UIScreen.mainScreen().bounds.width-2)/2
    
    let font12 = UIFont.systemFontOfSize(12)
    let font14 = UIFont.systemFontOfSize(14)
    let font16 = UIFont.systemFontOfSize(16)
    let font23 =  UIFont.systemFontOfSize(23)
    let lighrgraybackgroundcolor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
    let hrcolor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
    let rrcolor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
    let leavebedcolor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
    let awakecolor = UIColor(red: 125/255, green: 249/255, blue: 60/255, alpha: 1.0)
    let lightsleepcolor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
    let deepsleepcolor = UIColor(red: 92/255, green: 130/255, blue: 245/255, alpha: 1.0)
    let sleeptextcolor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
    
    
    var hrTitleLabel:UILabel!
    var HrRrChartView = ChartView()
    var hrFiguresView:UIView!
    var hrSubTitleLabel:UILabel!
    var hrImage :UIImageView!
    var maxhrLabel:UILabel!
    var maxhrTitleLabel:UILabel!
    var minhrLabel:UILabel!
    var minhrTitleLabel:UILabel!
    var avghrLabel:UILabel!
    var avghrTitleLabel:UILabel!
    var rrFiguresView:UIView!
    var rrImage:UIImageView!
    var rrTitleLabel:UILabel!
    var maxrrLabel:UILabel!
    var maxrrTitleLabel:UILabel!
    var minrrLabel:UILabel!
    var minrrTitleLabel: UILabel!
    var avgrrLabel: UILabel!
    var avgrrTitleLabel:UILabel!
    var leavebedTitleLabel:UILabel!
    var LeaveBedChartView = ChartView()
    var LeaveBedFiguresView: UIView!
    var leavebedSubTitleLabel:UILabel!
    var leavebedValueLabel: UILabel!
    var sleepTitleLabel:UILabel!
    var SleepChartView = ChartView()
    var SleepFiguresView:UIView!
    var awakeView:UIView!
    var lightsleepView:UIView!
    var deepsleepView:UIView!
    var sleeptimeView:UIView!
    var onbedtimeView:UIView!
    var leavebedtimeView:UIView!
    var awakeLabel: UILabel!
    var awakeTitleLabel: UILabel!
    var lightsleepLabel: UILabel!
    var lightsleepTitleLabel: UILabel!
    var deepsleepLabel: UILabel!
    var deepsleepTitleLabel: UILabel!
    var sleeptimeLabel: UILabel!
    var sleeptimeTitleLabel: UILabel!
    var onbedtimeLabel: UILabel!
    var onbedtimeTitleLabel: UILabel!
    var leavebedtimeLabel: UILabel!
    var leavebedtimeTitleLabel: UILabel!
    var suggestionTitleLabel: UILabel!
    var SuggestionFiguresView: UIView!
    var leavebedtimesView: UIView!
    var turnovertimesView : UIView!
    var leavebedmaxView: UIView!
    var turnoverrateView : UIView!
    var leavebedtimesLabel: UILabel!
    var leavebedtimesTitleLabel: UILabel!
    var turnovertimesLabel: UILabel!
    var turnovertimesTitleLabel: UILabel!
    var leavebedmaxLabel: UILabel!
    var leavebedmaxTitleLabel: UILabel!
    var turnoverrateLabel: UILabel!
    var turnoverrateTitleLabel : UILabel!
    var SuggestionContentView:UIView!
    var suggestionContent:UITextView!
    
    
    override func viewWillAppear(animated: Bool) {
        currentController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weekreportViewModel = WeekReportViewModel()
        
        RACObserve(self.weekreportViewModel, "DateLabel") ~> RAC(self.lblDate, "text")
        
        self.mainscrollView.delegate = self
        self.mainscrollView.contentSize = CGSize(width:screenwidth,height:1370)
        
        
        self.rac_settings()
        self.Refresh()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rac_settings(){
        self.AddHrRrTitle()
        self.AddHrRrChart()
        self.AddHrFigures()
        self.AddRrFigures()
        self.AddLeaveBedTitle()
        self.AddLeaveBedChart()
        self.AddLeaveBedFigures()
        self.AddSleepTitle()
        self.AddSleepChart()
        self.AddSleepFigures()
        self.AddSuggestionTitle()
        self.AddSuggestionFigures()
        self.AddSuggestionContent()
    }
    
    func Refresh(){
        HrRrChartView.RemoveTrendChartView()
        if self.weekreportViewModel.HRRRRange.flag{
            HrRrChartView.Type = "1"
            let titleNameList1 = "心率"
            let titleNameList2 = "呼吸"
            HrRrChartView.valueAll = self.weekreportViewModel.HRRRRange.ValueY as [AnyObject]
            HrRrChartView.valueXList =  self.weekreportViewModel.HRRRRange.ValueX as [AnyObject]
            HrRrChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2) as [AnyObject]
            HrRrChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
            self.mainscrollView.addSubview(HrRrChartView)
        }
        
        
        maxhrLabel.text = self.weekreportViewModel.WeekMaxHR
        
        minhrLabel.text = self.weekreportViewModel.WeekMinHR
        
        avghrLabel.text = self.weekreportViewModel.WeekAvgHR
        
        maxrrLabel.text = self.weekreportViewModel.WeekMaxRR
        
        minrrLabel.text = self.weekreportViewModel.WeekMinRR
        
        avgrrLabel.text = self.weekreportViewModel.WeekAvgRR
        
        LeaveBedChartView.RemoveTrendChartView()
        if  self.weekreportViewModel.LeaveBedRange.flag{
            LeaveBedChartView.frame = CGRectMake(0, 420, screenwidth, 200)
            LeaveBedChartView.Type = "4"
            let titleNameList1 = "离床"
            LeaveBedChartView.valueAll = self.weekreportViewModel.LeaveBedRange.ValueY as [AnyObject]
            LeaveBedChartView.valueXList = self.weekreportViewModel.LeaveBedRange.ValueX as [AnyObject]
            LeaveBedChartView.valueTitleNames = NSArray(objects:titleNameList1) as [AnyObject]
            LeaveBedChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
            self.mainscrollView.addSubview(LeaveBedChartView)
        }
        
        leavebedValueLabel.text = self.weekreportViewModel.LeaveBedSum
        
        
        SleepChartView.RemoveTrendChartView()
        if self.weekreportViewModel.SleepRange.flag{
            SleepChartView.frame = CGRectMake(0, 732, screenwidth, 200)
            SleepChartView.Type = "3"
            let titleNameList1 = "深睡"
            let titleNameList2 = "浅睡"
            let titleNameList3 = "清醒"
            SleepChartView.valueAll = self.weekreportViewModel.SleepRange.ValueY as [AnyObject]
            SleepChartView.valueXList =  self.weekreportViewModel.SleepRange.ValueX as [AnyObject]
            SleepChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2,titleNameList3) as [AnyObject]
            SleepChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
            self.mainscrollView.addSubview(SleepChartView)
        }
        
        
        awakeLabel.text = self.weekreportViewModel.WeekWakeHours
        
        lightsleepLabel.text = self.weekreportViewModel.WeekLightSleepHours
        
        deepsleepLabel.text = self.weekreportViewModel.WeekDeepSleepHours
        
        sleeptimeLabel.text = self.weekreportViewModel.WeekSleepHours
        
        onbedtimeLabel.text = self.weekreportViewModel.OnbedBeginTime
        
        leavebedtimeLabel.text = self.weekreportViewModel.OnbedEndTime
        
        leavebedtimesLabel.text = self.weekreportViewModel.AvgLeaveBedSum
        
        turnovertimesLabel.text = self.weekreportViewModel.AvgTurnTimes
        
        leavebedmaxLabel.text = self.weekreportViewModel.MaxLeaveBedHours
        
        turnoverrateLabel.text = self.weekreportViewModel.TurnsRate
        
        suggestionContent.text = self.weekreportViewModel.SleepSuggest
    }
    
    func AddHrRrTitle(){
        hrTitleLabel = UILabel(frame: CGRectMake(0, 0, screenwidth, 35))
        hrTitleLabel.text = "心率和呼吸"
        hrTitleLabel.font = self.font16
        hrTitleLabel.textColor = self.rrcolor
        hrTitleLabel.textAlignment = NSTextAlignment.Center
        hrTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(hrTitleLabel)
        
    }
    
    func AddHrRrChart(){
        
        HrRrChartView.frame = CGRectMake(0, 35, screenwidth, 200)
        
        //        HrRrChartView.Type = "1"
        //        let titleNameList1 = "心率"
        //        let titleNameList2 = "呼吸"
        //        HrRrChartView.valueAll = self.weekreportViewModel.HRRRRange.ValueY as [AnyObject]
        //        HrRrChartView.valueXList =  self.weekreportViewModel.HRRRRange.ValueX as [AnyObject]
        //        HrRrChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2) as [AnyObject]
        //        HrRrChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        //        self.mainscrollView.addSubview(HrRrChartView)
    }
    
    func AddHrFigures(){
        hrFiguresView = UIView(frame:CGRectMake(0, 237, screenwidth, 73))
        hrFiguresView.backgroundColor = UIColor.whiteColor()
        hrImage = UIImageView(frame:CGRectMake(hrFigureWidth/2 - 13, 16, 26, 23))
        hrImage.image = UIImage(named:"icon_heart.png")
        hrFiguresView.addSubview(hrImage)
        hrSubTitleLabel = UILabel(frame:CGRectMake(0, 46, hrFigureWidth, 20))
        hrSubTitleLabel.font = self.font12
        hrSubTitleLabel.text = "次/分"
        hrSubTitleLabel.textAlignment = NSTextAlignment.Center
        hrSubTitleLabel.textColor = self.lighrgraybackgroundcolor
        hrFiguresView.addSubview(hrSubTitleLabel)
        
        maxhrLabel = UILabel(frame:CGRectMake(hrFigureWidth, 7, hrFigureWidth, 38))
        maxhrLabel.font = self.font23
        //  maxhrLabel.text = self.weekreportViewModel.WeekMaxHR
        maxhrLabel.textAlignment = NSTextAlignment.Left
        maxhrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(maxhrLabel)
        maxhrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth, 46, hrFigureWidth, 20))
        maxhrTitleLabel.font = self.font14
        maxhrTitleLabel.text = "周最大"
        maxhrTitleLabel.textAlignment = NSTextAlignment.Left
        maxhrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(maxhrTitleLabel)
        
        minhrLabel = UILabel(frame:CGRectMake(hrFigureWidth*2, 7, hrFigureWidth, 38))
        minhrLabel.font = self.font23
        //   minhrLabel.text = self.weekreportViewModel.WeekMinHR
        minhrLabel.textAlignment = NSTextAlignment.Left
        minhrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(minhrLabel)
        minhrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth*2, 46, hrFigureWidth, 20))
        minhrTitleLabel.font = self.font14
        minhrTitleLabel.text = "周最小"
        minhrTitleLabel.textAlignment = NSTextAlignment.Left
        minhrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(minhrTitleLabel)
        
        avghrLabel = UILabel(frame:CGRectMake(hrFigureWidth*3, 7, hrFigureWidth, 38))
        avghrLabel.font = self.font23
        //   avghrLabel.text = self.weekreportViewModel.WeekAvgHR
        avghrLabel.textAlignment = NSTextAlignment.Left
        avghrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(avghrLabel)
        avghrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth*3, 46, hrFigureWidth, 20))
        avghrTitleLabel.font = self.font14
        avghrTitleLabel.text = "周平均"
        avghrTitleLabel.textAlignment = NSTextAlignment.Left
        avghrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(avghrTitleLabel)
        
        self.mainscrollView.addSubview(hrFiguresView)
    }
    
    func AddRrFigures(){
        rrFiguresView = UIView(frame:CGRectMake(0, 312, screenwidth, 73))
        rrFiguresView.backgroundColor = UIColor.whiteColor()
        rrImage = UIImageView(frame:CGRectMake(rrFigureWidth/2 - 13, 16, 26, 23))
        rrImage.image = UIImage(named:"icon_breath.png")
        rrFiguresView.addSubview(rrImage)
        rrTitleLabel = UILabel(frame:CGRectMake(0, 46, hrFigureWidth, 20))
        rrTitleLabel.font = self.font12
        rrTitleLabel.text = "次/分"
        rrTitleLabel.textAlignment = NSTextAlignment.Center
        rrTitleLabel.textColor = self.lighrgraybackgroundcolor
        rrFiguresView.addSubview(rrTitleLabel)
        
        maxrrLabel = UILabel(frame:CGRectMake(rrFigureWidth, 7, rrFigureWidth, 38))
        maxrrLabel.font = self.font23
        //  maxrrLabel.text = self.weekreportViewModel.WeekMaxRR
        maxrrLabel.textAlignment = NSTextAlignment.Left
        maxrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(maxrrLabel)
        maxrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth, 46, rrFigureWidth, 20))
        maxrrTitleLabel.font = self.font14
        maxrrTitleLabel.text = "周最快"
        maxrrTitleLabel.textAlignment = NSTextAlignment.Left
        maxrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(maxrrTitleLabel)
        
        minrrLabel = UILabel(frame:CGRectMake(rrFigureWidth*2, 7, rrFigureWidth, 38))
        minrrLabel.font = self.font23
        //  minrrLabel.text = self.weekreportViewModel.WeekMinRR
        minrrLabel.textAlignment = NSTextAlignment.Left
        minrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(minrrLabel)
        minrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth*2, 46, rrFigureWidth, 20))
        minrrTitleLabel.font = self.font14
        minrrTitleLabel.text = "周最慢"
        minrrTitleLabel.textAlignment = NSTextAlignment.Left
        minrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(minrrTitleLabel)
        
        avgrrLabel = UILabel(frame:CGRectMake(rrFigureWidth*3, 7, rrFigureWidth, 38))
        avgrrLabel.font = self.font23
        //  avgrrLabel.text = self.weekreportViewModel.WeekAvgRR
        avgrrLabel.textAlignment = NSTextAlignment.Left
        avgrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(avgrrLabel)
        avgrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth*3, 46, rrFigureWidth, 20))
        avgrrTitleLabel.font = self.font14
        avgrrTitleLabel.text = "周平均"
        avgrrTitleLabel.textAlignment = NSTextAlignment.Left
        avgrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(avgrrTitleLabel)
        
        self.mainscrollView.addSubview(rrFiguresView)
    }
    
    func AddLeaveBedTitle(){
        leavebedTitleLabel = UILabel(frame: CGRectMake(0, 385, screenwidth, 35))
        leavebedTitleLabel.text = "离床时间"
        leavebedTitleLabel.font = self.font16
        leavebedTitleLabel.textColor = self.rrcolor
        leavebedTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(leavebedTitleLabel)
    }
    
    func AddLeaveBedChart(){
        //        if  self.weekreportViewModel.LeaveBedRange.flag{
        //
        //        LeaveBedChartView.frame = CGRectMake(0, 420, screenwidth, 200)
        //        LeaveBedChartView.Type = "4"
        //         let titleNameList1 = "离床"
        //        LeaveBedChartView.valueAll = self.weekreportViewModel.LeaveBedRange.ValueY as [AnyObject]
        //        LeaveBedChartView.valueXList = self.weekreportViewModel.LeaveBedRange.ValueX as [AnyObject]
        //        LeaveBedChartView.valueTitleNames = NSArray(objects:titleNameList1) as [AnyObject]
        //        LeaveBedChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        //        self.mainscrollView.addSubview(LeaveBedChartView)
        //        }
    }
    
    func AddLeaveBedFigures(){
        LeaveBedFiguresView = UIView(frame:CGRectMake(0, 622, screenwidth, 73))
        LeaveBedFiguresView.backgroundColor = UIColor.whiteColor()
        
        leavebedSubTitleLabel = UILabel(frame: CGRectMake(35, 23, 70, 25))
        leavebedSubTitleLabel.text = "离床频繁"
        leavebedSubTitleLabel.font = self.font14
        leavebedSubTitleLabel.textColor = self.leavebedcolor
        LeaveBedFiguresView.addSubview(leavebedSubTitleLabel)
        leavebedValueLabel = UILabel(frame: CGRectMake(130, 23, 120, 25))
        // leavebedValueLabel.text = self.weekreportViewModel.LeaveBedSum
        leavebedValueLabel.font = self.font14
        leavebedValueLabel.textColor = self.lighrgraybackgroundcolor
        LeaveBedFiguresView.addSubview(leavebedValueLabel)
        
        self.mainscrollView.addSubview(LeaveBedFiguresView)
    }
    
    func AddSleepTitle(){
        var sleepTitleLabel = UILabel(frame: CGRectMake(0, 695, screenwidth, 35))
        sleepTitleLabel.text = "睡眠时间"
        sleepTitleLabel.font = self.font16
        sleepTitleLabel.textColor = self.rrcolor
        sleepTitleLabel.textAlignment = NSTextAlignment.Center
        sleepTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(sleepTitleLabel)
    }
    
    
    func AddSleepChart(){
        
        //        if self.weekreportViewModel.SleepRange.flag{
        //        SleepChartView.frame = CGRectMake(0, 732, screenwidth, 200)
        //        SleepChartView.Type = "3"
        //        let titleNameList1 = "深睡"
        //        let titleNameList2 = "浅睡"
        //        let titleNameList3 = "清醒"
        //        SleepChartView.valueAll = self.weekreportViewModel.SleepRange.ValueY as [AnyObject]
        //        SleepChartView.valueXList =  self.weekreportViewModel.SleepRange.ValueX as [AnyObject]
        //        SleepChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2,titleNameList3) as [AnyObject]
        //        SleepChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        //        self.mainscrollView.addSubview(SleepChartView)
        //        }
    }
    
    
    func AddSleepFigures(){
        SleepFiguresView = UIView(frame:CGRectMake(0, 934, screenwidth, 148))
        SleepFiguresView.backgroundColor = UIColor.clearColor()
        
        awakeView = UIView(frame:CGRectMake(0, 0, sleepFigureWidth, 73))
        awakeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(awakeView)
        lightsleepView = UIView(frame:CGRectMake(sleepFigureWidth+2, 0, sleepFigureWidth, 73))
        lightsleepView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(lightsleepView)
        deepsleepView = UIView(frame:CGRectMake(sleepFigureWidth*2+4, 0, sleepFigureWidth, 73))
        deepsleepView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(deepsleepView)
        sleeptimeView = UIView(frame:CGRectMake(0, 75, sleepFigureWidth, 73))
        sleeptimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(sleeptimeView)
        onbedtimeView = UIView(frame:CGRectMake(sleepFigureWidth+2, 75, sleepFigureWidth, 73))
        onbedtimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(onbedtimeView)
        leavebedtimeView = UIView(frame:CGRectMake(sleepFigureWidth*2+4, 75, sleepFigureWidth, 73))
        leavebedtimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(leavebedtimeView)
        
        awakeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        awakeLabel.font = self.font23
        //  awakeLabel.text = self.weekreportViewModel.WeekWakeHours
        awakeLabel.textAlignment = NSTextAlignment.Center
        awakeLabel.textColor = self.awakecolor
        awakeView.addSubview(awakeLabel)
        awakeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        awakeTitleLabel.font = self.font14
        awakeTitleLabel.text = "清醒"
        awakeTitleLabel.textAlignment = NSTextAlignment.Center
        awakeTitleLabel.textColor = UIColor.lightGrayColor()
        awakeView.addSubview(awakeTitleLabel)
        
        lightsleepLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        lightsleepLabel.font = self.font23
        // lightsleepLabel.text = self.weekreportViewModel.WeekLightSleepHours
        lightsleepLabel.textAlignment = NSTextAlignment.Center
        lightsleepLabel.textColor = self.lightsleepcolor
        lightsleepView.addSubview(lightsleepLabel)
        lightsleepTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        lightsleepTitleLabel.font = self.font14
        lightsleepTitleLabel.text = "浅睡"
        lightsleepTitleLabel.textAlignment = NSTextAlignment.Center
        lightsleepTitleLabel.textColor = UIColor.lightGrayColor()
        lightsleepView.addSubview(lightsleepTitleLabel)
        
        deepsleepLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        deepsleepLabel.font = self.font23
        // deepsleepLabel.text = self.weekreportViewModel.WeekDeepSleepHours
        deepsleepLabel.textAlignment = NSTextAlignment.Center
        deepsleepLabel.textColor = self.deepsleepcolor
        deepsleepView.addSubview(deepsleepLabel)
        deepsleepTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        deepsleepTitleLabel.font = self.font14
        deepsleepTitleLabel.text = "深睡"
        deepsleepTitleLabel.textAlignment = NSTextAlignment.Center
        deepsleepTitleLabel.textColor = UIColor.lightGrayColor()
        deepsleepView.addSubview(deepsleepTitleLabel)
        
        sleeptimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        sleeptimeLabel.font = self.font23
        //  sleeptimeLabel.text = self.weekreportViewModel.WeekSleepHours
        sleeptimeLabel.textAlignment = NSTextAlignment.Center
        sleeptimeLabel.textColor = self.sleeptextcolor
        sleeptimeView.addSubview(sleeptimeLabel)
        sleeptimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        sleeptimeTitleLabel.font = self.font14
        sleeptimeTitleLabel.text = "睡眠时长"
        sleeptimeTitleLabel.textAlignment = NSTextAlignment.Center
        sleeptimeTitleLabel.textColor = UIColor.lightGrayColor()
        sleeptimeView.addSubview(sleeptimeTitleLabel)
        
        onbedtimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        onbedtimeLabel.font = self.font23
        // onbedtimeLabel.text = self.weekreportViewModel.OnbedBeginTime
        onbedtimeLabel.textAlignment = NSTextAlignment.Center
        onbedtimeLabel.textColor = self.sleeptextcolor
        onbedtimeView.addSubview(onbedtimeLabel)
        onbedtimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        onbedtimeTitleLabel.font = self.font14
        onbedtimeTitleLabel.text = "在床时间"
        onbedtimeTitleLabel.textAlignment = NSTextAlignment.Center
        onbedtimeTitleLabel.textColor = UIColor.lightGrayColor()
        onbedtimeView.addSubview(onbedtimeTitleLabel)
        
        leavebedtimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        leavebedtimeLabel.font = self.font23
        //  leavebedtimeLabel.text = self.weekreportViewModel.OnbedEndTime
        leavebedtimeLabel.textAlignment = NSTextAlignment.Center
        leavebedtimeLabel.textColor = self.sleeptextcolor
        leavebedtimeView.addSubview(leavebedtimeLabel)
        leavebedtimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        leavebedtimeTitleLabel.font = self.font14
        leavebedtimeTitleLabel.text = "离床时间"
        leavebedtimeTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedtimeTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedtimeView.addSubview(leavebedtimeTitleLabel)
        
        self.mainscrollView.addSubview(SleepFiguresView)
        
    }
    
    func AddSuggestionTitle(){
        suggestionTitleLabel = UILabel(frame: CGRectMake(0, 1082, screenwidth, 35))
        suggestionTitleLabel.text = "睡眠建议"
        suggestionTitleLabel.font = self.font16
        suggestionTitleLabel.textColor = self.rrcolor
        suggestionTitleLabel.textAlignment = NSTextAlignment.Center
        suggestionTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(suggestionTitleLabel)
    }
    
    func AddSuggestionFigures(){
        SuggestionFiguresView = UIView(frame:CGRectMake(0, 1117, screenwidth, 148))
        SuggestionFiguresView.backgroundColor = UIColor.clearColor()
        
        leavebedtimesView = UIView(frame:CGRectMake(0, 0, suggestionFigureWidth, 73))
        leavebedtimesView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(leavebedtimesView)
        turnovertimesView = UIView(frame:CGRectMake(suggestionFigureWidth+2, 0, suggestionFigureWidth, 73))
        turnovertimesView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(turnovertimesView)
        leavebedmaxView = UIView(frame:CGRectMake(0, 75, suggestionFigureWidth, 73))
        leavebedmaxView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(leavebedmaxView)
        turnoverrateView = UIView(frame:CGRectMake(suggestionFigureWidth+2, 75, suggestionFigureWidth, 73))
        turnoverrateView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(turnoverrateView)
        
        
        leavebedtimesLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        leavebedtimesLabel.font = self.font23
        // leavebedtimesLabel.text = self.weekreportViewModel.AvgLeaveBedSum
        leavebedtimesLabel.textAlignment = NSTextAlignment.Center
        leavebedtimesLabel.textColor = self.sleeptextcolor
        leavebedtimesView.addSubview(leavebedtimesLabel)
        leavebedtimesTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        leavebedtimesTitleLabel.font = self.font14
        leavebedtimesTitleLabel.text = "离床次数"
        leavebedtimesTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedtimesTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedtimesView.addSubview(leavebedtimesTitleLabel)
        
        turnovertimesLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        turnovertimesLabel.font = self.font23
        //  turnovertimesLabel.text = self.weekreportViewModel.AvgTurnTimes
        turnovertimesLabel.textAlignment = NSTextAlignment.Center
        turnovertimesLabel.textColor = self.sleeptextcolor
        turnovertimesView.addSubview(turnovertimesLabel)
        turnovertimesTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        turnovertimesTitleLabel.font = self.font14
        turnovertimesTitleLabel.text = "翻身次数"
        turnovertimesTitleLabel.textAlignment = NSTextAlignment.Center
        turnovertimesTitleLabel.textColor = UIColor.lightGrayColor()
        turnovertimesView.addSubview(turnovertimesTitleLabel)
        
        leavebedmaxLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        leavebedmaxLabel.font = self.font23
        //  leavebedmaxLabel.text = self.weekreportViewModel.MaxLeaveBedHours
        leavebedmaxLabel.textAlignment = NSTextAlignment.Center
        leavebedmaxLabel.textColor = self.sleeptextcolor
        leavebedmaxView.addSubview(leavebedmaxLabel)
        leavebedmaxTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        leavebedmaxTitleLabel.font = self.font14
        leavebedmaxTitleLabel.text = "最高离床时间"
        leavebedmaxTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedmaxTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedmaxView.addSubview(leavebedmaxTitleLabel)
        
        turnoverrateLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        turnoverrateLabel.font = self.font23
        //  turnoverrateLabel.text = self.weekreportViewModel.TurnsRate
        turnoverrateLabel.textAlignment = NSTextAlignment.Center
        turnoverrateLabel.textColor = self.sleeptextcolor
        turnoverrateView.addSubview(turnoverrateLabel)
        turnoverrateTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        turnoverrateTitleLabel.font = self.font14
        turnoverrateTitleLabel.text = "翻身频率"
        turnoverrateTitleLabel.textAlignment = NSTextAlignment.Center
        turnoverrateTitleLabel.textColor = UIColor.lightGrayColor()
        turnoverrateView.addSubview(turnoverrateTitleLabel)
        
        
        self.mainscrollView.addSubview(SuggestionFiguresView)
    }
    
    func AddSuggestionContent(){
        SuggestionContentView = UIView(frame:CGRectMake(0, 1267, screenwidth, 103))
        SuggestionContentView.backgroundColor = UIColor.whiteColor()
        suggestionContent = UITextView(frame:CGRectMake(30, 10, screenwidth-50, 90))
        //  suggestionContent.text = self.weekreportViewModel.SleepSuggest
        suggestionContent.editable = false
        suggestionContent.font = self.font14
        suggestionContent.textColor = UIColor.lightGrayColor()
        SuggestionContentView.addSubview(suggestionContent)
        self.mainscrollView.addSubview(SuggestionContentView)
        
    }
    
    
    func SelectDate(sender: UIView, dateString: String) {
        self.weekreportViewModel.SelectDate = dateString
        
        self.weekreportViewModel.LoadData()
        
        self.Refresh()
    }
    
    
}

