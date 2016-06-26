//
//  ViewController.swift
//  周报表demo
//
//  Created by Qinyuan Liu on 6/16/16.
//  Copyright (c) 2016 Qinyuan Liu. All rights reserved.
//

import UIKit

class SleepReportViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var mainscrollView: UIScrollView!
    
    let screenwidth = UIScreen.mainScreen().bounds.width
    let hrFigureWidth = UIScreen.mainScreen().bounds.width / 4
    let rrFigureWidth = UIScreen.mainScreen().bounds.width / 4
    let sleepFigureWidth = (UIScreen.mainScreen().bounds.width-4)/3
    let suggestionFigureWidth = (UIScreen.mainScreen().bounds.width-2)/2
    
    let font12 = UIFont.systemFontOfSize(12)
    let font14 = UIFont.systemFontOfSize(14)
    let font16 = UIFont.systemFontOfSize(16)
    let font28 =  UIFont.systemFontOfSize(28)
    let lighrgraybackgroundcolor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
    let hrcolor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
    let rrcolor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
    let leavebedcolor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
    let awakecolor = UIColor(red: 125/255, green: 249/255, blue: 60/255, alpha: 1.0)
    let lightsleepcolor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
    let deepsleepcolor = UIColor(red: 92/255, green: 130/255, blue: 245/255, alpha: 1.0)
    let sleeptextcolor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mainscrollView.delegate = self
        self.mainscrollView.contentSize = CGSize(width:screenwidth,height:1370)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func AddHrRrTitle(){
        var hrTitleLabel = UILabel(frame: CGRectMake(0, 0, screenwidth, 35))
        hrTitleLabel.text = "心率和呼吸"
        hrTitleLabel.font = self.font16
        hrTitleLabel.textColor = self.rrcolor
        hrTitleLabel.textAlignment = NSTextAlignment.Center
        hrTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(hrTitleLabel)
        
    }
    
    func AddHrRrChart(){
        var HrRrChartView = ChartView()
        HrRrChartView.frame = CGRectMake(0, 35, screenwidth, 200)

        HrRrChartView.Type = "1"
        
        let valueList1:NSArray = [ "20","35","97","70","30","40","20"]
        let valueList2:NSArray = [ "10","15","9","20","24","30","25"]
        let valueListForX1 = NSArray(objects:  "周一","周二","周三","周四","周五","周六","周日")
        let titleNameList1 = "心率"
        let titleNameList2 = "呼吸"

        HrRrChartView.valueAll = NSArray(objects:valueList1,valueList2) as [AnyObject]
        HrRrChartView.valueXList =  valueListForX1 as [AnyObject]
        HrRrChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2) as [AnyObject]
        HrRrChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        
        self.mainscrollView.addSubview(HrRrChartView)
    }
    
    func AddHrFigures(){
        var hrFiguresView = UIView(frame:CGRectMake(0, 237, screenwidth, 73))
        hrFiguresView.backgroundColor = UIColor.whiteColor()
        var hrImage = UIImageView(frame:CGRectMake(hrFigureWidth/2 - 13, 16, 26, 23))
        hrImage.image = UIImage(named:"icon_heart.png")
       hrFiguresView.addSubview(hrImage)
        var hrTitleLabel = UILabel(frame:CGRectMake(0, 46, hrFigureWidth, 20))
        hrTitleLabel.font = self.font12
        hrTitleLabel.text = "次/分"
        hrTitleLabel.textAlignment = NSTextAlignment.Center
        hrTitleLabel.textColor = self.lighrgraybackgroundcolor
         hrFiguresView.addSubview(hrTitleLabel)
        
        var maxhrLabel = UILabel(frame:CGRectMake(hrFigureWidth, 7, hrFigureWidth, 38))
        maxhrLabel.font = self.font28
        maxhrLabel.text = "110"
        maxhrLabel.textAlignment = NSTextAlignment.Left
        maxhrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(maxhrLabel)
        var maxhrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth, 46, hrFigureWidth, 20))
        maxhrTitleLabel.font = self.font14
        maxhrTitleLabel.text = "周最大"
        maxhrTitleLabel.textAlignment = NSTextAlignment.Left
        maxhrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(maxhrTitleLabel)
        
        var minhrLabel = UILabel(frame:CGRectMake(hrFigureWidth*2, 7, hrFigureWidth, 38))
        minhrLabel.font = self.font28
        minhrLabel.text = "60"
        minhrLabel.textAlignment = NSTextAlignment.Left
        minhrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(minhrLabel)
        var minhrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth*2, 46, hrFigureWidth, 20))
        minhrTitleLabel.font = self.font14
        minhrTitleLabel.text = "周最小"
        minhrTitleLabel.textAlignment = NSTextAlignment.Left
        minhrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(minhrTitleLabel)
        
        var avghrLabel = UILabel(frame:CGRectMake(hrFigureWidth*3, 7, hrFigureWidth, 38))
        avghrLabel.font = self.font28
        avghrLabel.text = "80"
        avghrLabel.textAlignment = NSTextAlignment.Left
        avghrLabel.textColor = self.hrcolor
        hrFiguresView.addSubview(avghrLabel)
        var avghrTitleLabel = UILabel(frame:CGRectMake(hrFigureWidth*3, 46, hrFigureWidth, 20))
        avghrTitleLabel.font = self.font14
        avghrTitleLabel.text = "周平均"
        avghrTitleLabel.textAlignment = NSTextAlignment.Left
        avghrTitleLabel.textColor = UIColor.lightGrayColor()
        hrFiguresView.addSubview(avghrTitleLabel)
        
        self.mainscrollView.addSubview(hrFiguresView)
    }
    
    func AddRrFigures(){
        var rrFiguresView = UIView(frame:CGRectMake(0, 312, screenwidth, 73))
        rrFiguresView.backgroundColor = UIColor.whiteColor()
        var rrImage = UIImageView(frame:CGRectMake(rrFigureWidth/2 - 13, 16, 26, 23))
        rrImage.image = UIImage(named:"icon_breath.png")
        rrFiguresView.addSubview(rrImage)
        var rrTitleLabel = UILabel(frame:CGRectMake(0, 46, hrFigureWidth, 20))
        rrTitleLabel.font = self.font12
        rrTitleLabel.text = "次/分"
        rrTitleLabel.textAlignment = NSTextAlignment.Center
        rrTitleLabel.textColor = self.lighrgraybackgroundcolor
        rrFiguresView.addSubview(rrTitleLabel)
        
        var maxrrLabel = UILabel(frame:CGRectMake(rrFigureWidth, 7, rrFigureWidth, 38))
        maxrrLabel.font = self.font28
        maxrrLabel.text = "50"
        maxrrLabel.textAlignment = NSTextAlignment.Left
        maxrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(maxrrLabel)
        var maxrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth, 46, rrFigureWidth, 20))
        maxrrTitleLabel.font = self.font14
        maxrrTitleLabel.text = "周最快"
        maxrrTitleLabel.textAlignment = NSTextAlignment.Left
        maxrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(maxrrTitleLabel)
        
        var minrrLabel = UILabel(frame:CGRectMake(rrFigureWidth*2, 7, rrFigureWidth, 38))
        minrrLabel.font = self.font28
        minrrLabel.text = "10"
        minrrLabel.textAlignment = NSTextAlignment.Left
        minrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(minrrLabel)
        var minrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth*2, 46, rrFigureWidth, 20))
        minrrTitleLabel.font = self.font14
        minrrTitleLabel.text = "周最慢"
        minrrTitleLabel.textAlignment = NSTextAlignment.Left
        minrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(minrrTitleLabel)
        
        var avgrrLabel = UILabel(frame:CGRectMake(rrFigureWidth*3, 7, rrFigureWidth, 38))
        avgrrLabel.font = self.font28
        avgrrLabel.text = "40"
        avgrrLabel.textAlignment = NSTextAlignment.Left
        avgrrLabel.textColor = self.rrcolor
        rrFiguresView.addSubview(avgrrLabel)
        var avgrrTitleLabel = UILabel(frame:CGRectMake(rrFigureWidth*3, 46, rrFigureWidth, 20))
        avgrrTitleLabel.font = self.font14
        avgrrTitleLabel.text = "周平均"
        avgrrTitleLabel.textAlignment = NSTextAlignment.Left
        avgrrTitleLabel.textColor = UIColor.lightGrayColor()
        rrFiguresView.addSubview(avgrrTitleLabel)
        
        self.mainscrollView.addSubview(rrFiguresView)
    }
    
    func AddLeaveBedTitle(){
        var leavebedTitleLabel = UILabel(frame: CGRectMake(0, 385, screenwidth, 35))
        leavebedTitleLabel.text = "离床时间"
        leavebedTitleLabel.font = self.font16
        leavebedTitleLabel.textColor = self.rrcolor
        leavebedTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(leavebedTitleLabel)
    }
    
    func AddLeaveBedChart(){
        var LeaveBedChartView = ChartView()
        LeaveBedChartView.frame = CGRectMake(0, 420, screenwidth, 200)
        //初始化chartview1的值
        //        let valueList1:NSArray = NSArray(objects: "11","15","97","70","30","40","20")
        //        let valueListForX1:NSArray = NSArray(objects: "周一","周二","周三","周四","周五","周六","周日")
        //        let titleNameList1:NSArray = NSArray(object: "心率")
        //       HrRrChartView.valueAll = valueList1 as [AnyObject]
        //       HrRrChartView.valueXList = valueListForX1 as [AnyObject]
        //        HrRrChartView.valueTitleNames = titleNameList1 as [AnyObject]
       LeaveBedChartView.Type = "4"
        
        let valueList1:NSArray = [ "0","3","9","0","0","14","15"]
        let valueListForX1 = NSArray(objects:  "周一","周二","周三","周四","周五","周六","周日")
        let titleNameList1 = "离床"
      
        
        LeaveBedChartView.valueAll = NSArray(objects:valueList1) as [AnyObject]
        LeaveBedChartView.valueXList =  valueListForX1 as [AnyObject]
        LeaveBedChartView.valueTitleNames = NSArray(objects:titleNameList1) as [AnyObject]
        LeaveBedChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        
        self.mainscrollView.addSubview(LeaveBedChartView)
    }
    
    func AddLeaveBedFigures(){
        var LeaveBedFiguresView = UIView(frame:CGRectMake(0, 622, screenwidth, 73))
        LeaveBedFiguresView.backgroundColor = UIColor.whiteColor()
        
        var leavebedTitleLabel = UILabel(frame: CGRectMake(35, 23, 70, 25))
        leavebedTitleLabel.text = "离床频繁"
        leavebedTitleLabel.font = self.font14
        leavebedTitleLabel.textColor = self.leavebedcolor
        LeaveBedFiguresView.addSubview(leavebedTitleLabel)
        var leavebedValueLabel = UILabel(frame: CGRectMake(130, 23, 120, 25))
       leavebedValueLabel.text = "周六 周日"
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
    
        var HrRrChartView = ChartView()
        HrRrChartView.frame = CGRectMake(0, 732, screenwidth, 200)
        
        HrRrChartView.Type = "3"
        
        let valueList1:NSArray = [ "2","3","4","4","5","4","6"]
        let valueList2:NSArray = [ "1","2","2","2","4","4","5"]
        let valueList3:NSArray = [ "1","0.5","1","1.4","2","2.5","2.5"]
        let valueListForX1 = NSArray(objects:  "周一","周二","周三","周四","周五","周六","周日")
        let titleNameList1 = "深睡"
        let titleNameList2 = "浅睡"
        let titleNameList3 = "清醒"
        
        HrRrChartView.valueAll = NSArray(objects:valueList1,valueList2,valueList3) as [AnyObject]
        HrRrChartView.valueXList =  valueListForX1 as [AnyObject]
        HrRrChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2,titleNameList3) as [AnyObject]
        HrRrChartView.addTrendChartView(CGRectMake(0, 0, screenwidth, 200))
        
        self.mainscrollView.addSubview(HrRrChartView)
    }
    
    
    func AddSleepFigures(){
        var SleepFiguresView = UIView(frame:CGRectMake(0, 934, screenwidth, 148))
        SleepFiguresView.backgroundColor = UIColor.clearColor()
        
        var awakeView = UIView(frame:CGRectMake(0, 0, sleepFigureWidth, 73))
        awakeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(awakeView)
        var lightsleepView = UIView(frame:CGRectMake(sleepFigureWidth+2, 0, sleepFigureWidth, 73))
        lightsleepView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(lightsleepView)
        var deepsleepView = UIView(frame:CGRectMake(sleepFigureWidth*2+4, 0, sleepFigureWidth, 73))
        deepsleepView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(deepsleepView)
        var sleeptimeView = UIView(frame:CGRectMake(0, 75, sleepFigureWidth, 73))
        sleeptimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(sleeptimeView)
        var onbedtimeView = UIView(frame:CGRectMake(sleepFigureWidth+2, 75, sleepFigureWidth, 73))
        onbedtimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(onbedtimeView)
        var leavebedtimeView = UIView(frame:CGRectMake(sleepFigureWidth*2+4, 75, sleepFigureWidth, 73))
        leavebedtimeView.backgroundColor = UIColor.whiteColor()
        SleepFiguresView.addSubview(leavebedtimeView)
        
        var awakeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        awakeLabel.font = self.font28
        awakeLabel.text = "50"
       awakeLabel.textAlignment = NSTextAlignment.Center
        awakeLabel.textColor = self.awakecolor
        awakeView.addSubview(awakeLabel)
        var awakeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
       awakeTitleLabel.font = self.font14
        awakeTitleLabel.text = "清醒"
        awakeTitleLabel.textAlignment = NSTextAlignment.Center
        awakeTitleLabel.textColor = UIColor.lightGrayColor()
        awakeView.addSubview(awakeTitleLabel)
        
        var lightsleepLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        lightsleepLabel.font = self.font28
        lightsleepLabel.text = "10"
        lightsleepLabel.textAlignment = NSTextAlignment.Center
        lightsleepLabel.textColor = self.lightsleepcolor
        lightsleepView.addSubview(lightsleepLabel)
        var lightsleepTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        lightsleepTitleLabel.font = self.font14
        lightsleepTitleLabel.text = "浅睡"
        lightsleepTitleLabel.textAlignment = NSTextAlignment.Center
        lightsleepTitleLabel.textColor = UIColor.lightGrayColor()
        lightsleepView.addSubview(lightsleepTitleLabel)
        
        var deepsleepLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        deepsleepLabel.font = self.font28
        deepsleepLabel.text = "20"
        deepsleepLabel.textAlignment = NSTextAlignment.Center
        deepsleepLabel.textColor = self.deepsleepcolor
        deepsleepView.addSubview(deepsleepLabel)
        var deepsleepTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        deepsleepTitleLabel.font = self.font14
        deepsleepTitleLabel.text = "深睡"
        deepsleepTitleLabel.textAlignment = NSTextAlignment.Center
        deepsleepTitleLabel.textColor = UIColor.lightGrayColor()
        deepsleepView.addSubview(deepsleepTitleLabel)
        
        var sleeptimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        sleeptimeLabel.font = self.font28
        sleeptimeLabel.text = "10"
        sleeptimeLabel.textAlignment = NSTextAlignment.Center
        sleeptimeLabel.textColor = self.sleeptextcolor
        sleeptimeView.addSubview(sleeptimeLabel)
        var sleeptimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        sleeptimeTitleLabel.font = self.font14
        sleeptimeTitleLabel.text = "睡眠时长"
        sleeptimeTitleLabel.textAlignment = NSTextAlignment.Center
        sleeptimeTitleLabel.textColor = UIColor.lightGrayColor()
        sleeptimeView.addSubview(sleeptimeTitleLabel)
        
        var onbedtimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        onbedtimeLabel.font = self.font28
        onbedtimeLabel.text = "15"
        onbedtimeLabel.textAlignment = NSTextAlignment.Center
        onbedtimeLabel.textColor = self.sleeptextcolor
        onbedtimeView.addSubview(onbedtimeLabel)
        var onbedtimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
        onbedtimeTitleLabel.font = self.font14
        onbedtimeTitleLabel.text = "在床时间"
        onbedtimeTitleLabel.textAlignment = NSTextAlignment.Center
        onbedtimeTitleLabel.textColor = UIColor.lightGrayColor()
        onbedtimeView.addSubview(onbedtimeTitleLabel)
        
        var leavebedtimeLabel = UILabel(frame:CGRectMake(0, 7, sleepFigureWidth, 38))
        leavebedtimeLabel.font = self.font28
        leavebedtimeLabel.text = "5"
        leavebedtimeLabel.textAlignment = NSTextAlignment.Center
        leavebedtimeLabel.textColor = self.sleeptextcolor
        leavebedtimeView.addSubview(leavebedtimeLabel)
        var leavebedtimeTitleLabel = UILabel(frame:CGRectMake(0, 46, sleepFigureWidth, 20))
       leavebedtimeTitleLabel.font = self.font14
        leavebedtimeTitleLabel.text = "离床时间"
        leavebedtimeTitleLabel.textAlignment = NSTextAlignment.Center
       leavebedtimeTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedtimeView.addSubview(leavebedtimeTitleLabel)
        
        self.mainscrollView.addSubview(SleepFiguresView)
    
    }
    
    func AddSuggestionTitle(){
        var suggestionTitleLabel = UILabel(frame: CGRectMake(0, 1082, screenwidth, 35))
        suggestionTitleLabel.text = "睡眠建议"
        suggestionTitleLabel.font = self.font16
        suggestionTitleLabel.textColor = self.rrcolor
        suggestionTitleLabel.textAlignment = NSTextAlignment.Center
        suggestionTitleLabel.backgroundColor = UIColor.clearColor()
        self.mainscrollView.addSubview(suggestionTitleLabel)
    }
    
    func AddSuggestionFigures(){
        var SuggestionFiguresView = UIView(frame:CGRectMake(0, 1117, screenwidth, 148))
        SuggestionFiguresView.backgroundColor = UIColor.clearColor()
        
        var leavebedtimesView = UIView(frame:CGRectMake(0, 0, suggestionFigureWidth, 73))
        leavebedtimesView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(leavebedtimesView)
        var turnovertimesView = UIView(frame:CGRectMake(suggestionFigureWidth+2, 0, suggestionFigureWidth, 73))
        turnovertimesView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(turnovertimesView)
        var leavebedmaxView = UIView(frame:CGRectMake(0, 75, suggestionFigureWidth, 73))
        leavebedmaxView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(leavebedmaxView)
        var turnoverrateView = UIView(frame:CGRectMake(suggestionFigureWidth+2, 75, suggestionFigureWidth, 73))
        turnoverrateView.backgroundColor = UIColor.whiteColor()
        SuggestionFiguresView.addSubview(turnoverrateView)
        
        
        var leavebedtimesLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        leavebedtimesLabel.font = self.font28
        leavebedtimesLabel.text = "35"
        leavebedtimesLabel.textAlignment = NSTextAlignment.Center
        leavebedtimesLabel.textColor = self.sleeptextcolor
        leavebedtimesView.addSubview(leavebedtimesLabel)
        var leavebedtimesTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        leavebedtimesTitleLabel.font = self.font14
        leavebedtimesTitleLabel.text = "离床次数"
        leavebedtimesTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedtimesTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedtimesView.addSubview(leavebedtimesTitleLabel)
      
        var turnovertimesLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        turnovertimesLabel.font = self.font28
        turnovertimesLabel.text = "45"
       turnovertimesLabel.textAlignment = NSTextAlignment.Center
        turnovertimesLabel.textColor = self.sleeptextcolor
        turnovertimesView.addSubview(turnovertimesLabel)
        var turnovertimesTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        turnovertimesTitleLabel.font = self.font14
        turnovertimesTitleLabel.text = "翻身次数"
        turnovertimesTitleLabel.textAlignment = NSTextAlignment.Center
        turnovertimesTitleLabel.textColor = UIColor.lightGrayColor()
        turnovertimesView.addSubview(turnovertimesTitleLabel)
        
        var leavebedmaxLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        leavebedmaxLabel.font = self.font28
        leavebedmaxLabel.text = "45"
        leavebedmaxLabel.textAlignment = NSTextAlignment.Center
        leavebedmaxLabel.textColor = self.sleeptextcolor
        leavebedmaxView.addSubview(leavebedmaxLabel)
        var leavebedmaxTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        leavebedmaxTitleLabel.font = self.font14
        leavebedmaxTitleLabel.text = "最高离床时间"
        leavebedmaxTitleLabel.textAlignment = NSTextAlignment.Center
        leavebedmaxTitleLabel.textColor = UIColor.lightGrayColor()
        leavebedmaxView.addSubview(leavebedmaxTitleLabel)
        
        var turnoverrateLabel = UILabel(frame:CGRectMake(0, 7, suggestionFigureWidth, 38))
        turnoverrateLabel.font = self.font28
        turnoverrateLabel.text = "10"
        turnoverrateLabel.textAlignment = NSTextAlignment.Center
       turnoverrateLabel.textColor = self.sleeptextcolor
        turnoverrateView.addSubview(turnoverrateLabel)
        var turnoverrateTitleLabel = UILabel(frame:CGRectMake(0, 46, suggestionFigureWidth, 20))
        turnoverrateTitleLabel.font = self.font14
        turnoverrateTitleLabel.text = "翻身频率"
        turnoverrateTitleLabel.textAlignment = NSTextAlignment.Center
        turnoverrateTitleLabel.textColor = UIColor.lightGrayColor()
        turnoverrateView.addSubview(turnoverrateTitleLabel)
        
        
        self.mainscrollView.addSubview(SuggestionFiguresView)
    }
    
    func AddSuggestionContent(){
     var SuggestionContentView = UIView(frame:CGRectMake(0, 1267, screenwidth, 103))
        SuggestionContentView.backgroundColor = UIColor.whiteColor()
        var suggestionContent = UITextView(frame:CGRectMake(30, 10, screenwidth-50, 90))
        suggestionContent.text = "医惠科技系列智能电动软床以时尚的外观、全面的功能、简单的操作，稳定的性能等高科技、人性化的功能优势，带给您更加舒适的睡眠体验。"
        suggestionContent.editable = false
        suggestionContent.font = self.font14
        suggestionContent.textColor = UIColor.lightGrayColor()
        SuggestionContentView.addSubview(suggestionContent)
        self.mainscrollView.addSubview(SuggestionContentView)
    
    }
    
    
}

