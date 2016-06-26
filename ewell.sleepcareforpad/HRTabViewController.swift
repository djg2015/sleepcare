//
//  HRTabViewController.swift
//
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class HRTabViewController: UIViewController,UIScrollViewDelegate,PopDownListItemChoosed {
    
    @IBOutlet weak var adddeviceView: UIView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
   
    
    @IBOutlet weak var hrTabbar: UITabBarItem!
    //标题老人名字(为空时显示“选择老人”)
    @IBOutlet weak var NameLabel: UILabel!
  
    //紧急状态图标：心率过高或过低
    @IBOutlet weak var alarmNoticeImg: UIImageView!
    //切换当前老人
    @IBOutlet weak var ChangePatientBtn: UIButton!
    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
    //实时／平均心率数据
    @IBOutlet weak var CurrentHRImg: UIImageView!
    @IBOutlet weak var CurrentHRLabel: UILabel!
    @IBOutlet weak var AvgHRLabel: UILabel!
    @IBOutlet weak var circleHRLabel: UILabel!
    
    //滑动栏
    @IBOutlet weak var SelectUnderline: UILabel!
    @IBOutlet weak var HourBtn: UIButton!
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var WeekBtn: UIButton!
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    //滑动栏内选中的button
    var selectButton:UIButton!
    var hrTabViewModel:HRTabViewModel!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    
    //常量值定义
    let selectunderlineWidth = (UIScreen.mainScreen().bounds.width-40)/3
    let chartwidth = UIScreen.mainScreen().bounds.width
    let chartheight = UIScreen.mainScreen().bounds.height/570*200
    let selectColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
    let noselectColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
    let outterCircleHeight = UIScreen.mainScreen().bounds.height/570*150
    let innerCircleHeight = UIScreen.mainScreen().bounds.height/570*150/150*125
    let startColor = UIColor(red: 86/255, green: 163/255, blue: 253/255, alpha: 1.0)
    let centerColor = UIColor(red: 195/255, green: 114/255, blue: 168/255, alpha: 1.0)
    let endColor = UIColor(red: 254/255, green: 79/255, blue: 74/255, alpha: 1.0)
    let avgColor = UIColor(red: 75/255, green: 224/255, blue: 211/255, alpha: 1.0)
    let defaultColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
    let grayColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)
    
    
    //两个hr圆圈
    var outercircleView: STLoopProgressView!
    var innercircleView: STLoopProgressView!
    
    
    var currentHR:String?{
        didSet{
            if currentHR != nil{
              self.outercircleView.persentage = CGFloat((currentHR! as NSString).floatValue)/120.0

            }
        }
    }
    
    var avgHR:String?{
        didSet{
            if avgHR != nil{
                self.innercircleView.persentage = CGFloat((avgHR! as NSString).floatValue)/120.0
            }
        }
    }
    
    var statusImageName:String?
        {
        didSet{
            if statusImageName != nil{
                self.BedStatusImg.image = UIImage(named:statusImageName!)
            }
            else if statusImageName == ""{
                self.BedStatusImg.image = nil
            }
        }
    }
    
    var alarmNoticeImageName:String?
        {
        didSet{
            if alarmNoticeImageName != nil{
                self.alarmNoticeImg.image = UIImage(named:alarmNoticeImageName!)
            }
            else if alarmNoticeImageName == ""{
            self.alarmNoticeImg.image = nil
            }
        }
        
    }
    
    //当前心率值（3个范围：低，正常，高）变化到其他范围时，变化点的颜色，圆圈内label的颜色
    var currentHRImageName:String?
        {
        didSet{
            if currentHRImageName != ""{
                self.CurrentHRImg.image = UIImage(named:currentHRImageName!)
                
                if currentHRImageName == "icon_gray circle.png"{
                    self.circleHRLabel.textColor = self.grayColor
                }
                if currentHRImageName == "icon_blue circle.png"{
                self.circleHRLabel.textColor = self.startColor
                }
                else if currentHRImageName == "icon_purple circle.png"{
                self.circleHRLabel.textColor = self.centerColor
                }
                else if currentHRImageName == "icon_red circle.png"{
                self.circleHRLabel.textColor = self.endColor
                }
                
            }
            else{
            currentHRImageName == "icon_gray circle.png"
                self.circleHRLabel.textColor = self.grayColor
            }
        }
        
    }
    
   
    var HRDayReportList:HRReportList? {
        didSet{
            if HRDayReportList?.valueY.count > 0 {
            //初始化chartview1数据
            self.chartScrollView.chartView1.valueAll =  HRDayReportList!.valueY as [AnyObject]
            self.chartScrollView.chartView1.valueXList = HRDayReportList!.valueX as [AnyObject]
            self.chartScrollView.chartView1.valueTitleNames = HRDayReportList!.valueTitles as [AnyObject]
            chartScrollView.chartView1.Type = HRDayReportList?.Type
            
            //chartview1加入scrollview容器中
            chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
            }
        }
    }
    
   
    var HRWeekReportList:HRReportList? {
        didSet{
            if HRWeekReportList?.valueY.count > 0 {
                //初始化chartview1数据
                self.chartScrollView.chartView2.valueAll =  HRWeekReportList!.valueY as [AnyObject]
                self.chartScrollView.chartView2.valueXList = HRWeekReportList!.valueX as [AnyObject]
                self.chartScrollView.chartView2.valueTitleNames = HRWeekReportList!.valueTitles as [AnyObject]
                chartScrollView.chartView2.Type = HRWeekReportList?.Type
                
                //chartview1加入scrollview容器中
                chartScrollView.chartView2.addTrendChartView(CGRectMake(chartwidth, 0, chartwidth, chartheight))
            }
 
            
        }
    }
    
   
    var HRMonthReportList:HRReportList? {
        didSet{
            
            if HRMonthReportList?.valueY.count > 0 {
                //初始化chartview1数据
                self.chartScrollView.chartView3.valueAll =  HRMonthReportList!.valueY as [AnyObject]
                self.chartScrollView.chartView3.valueXList = HRMonthReportList!.valueX as [AnyObject]
                self.chartScrollView.chartView3.valueTitleNames = HRMonthReportList!.valueTitles as [AnyObject]
                chartScrollView.chartView3.Type = HRMonthReportList?.Type
                
                //chartview1加入scrollview容器中
                chartScrollView.chartView3.addTrendChartView(CGRectMake(chartwidth*2, 0, chartwidth, chartheight))
            }
 
        }
    }
    
    var popDownListForIphone:PopDownListForIphone?


    
    //点击滑动栏的button，显示对应的chart
    @IBAction func ClickTimeButton(sender:UIButton){
        self.chartScrollView.setContentOffset(CGPointMake((CGFloat)(sender.tag) * chartwidth, 0.0),animated:true)
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
       
        if  self.hrTabViewModel == nil{
             self.hrTabViewModel = HRTabViewModel()
        }
       
       let flag = self.hrTabViewModel!.LoadPatientHR()
        //显示内容
        if flag == "1"{
            //清除scrollview中chartview的内容
           self.chartScrollView.chartView1.RemoveTrendChartView()
            self.chartScrollView.chartView2.RemoveTrendChartView()
             self.chartScrollView.chartView3.RemoveTrendChartView()
            
            self.adddeviceView.hidden = true
           
            self.view1.hidden = false
            self.view2.hidden = false
            self.view3.hidden = false
            self.chartScrollView.hidden = false
          
            
        }
        //当前有老人设备但没有选择：隐藏除topview之外的subviews，需要选择一个老人后再刷新页面显示具体内容
        else if flag == "2"{
            self.view1.hidden = true
            self.view2.hidden = true
            self.view3.hidden = true
            self.chartScrollView.hidden = true
            self.adddeviceView.hidden = true
            self.NameLabel.text = "选择老人"
            
        }
        //当前没有设备：隐藏页面内所有的subviews,提示添加noticeview提示先添加设备
        else if  flag == "3"{
            self.view1.hidden = true
            self.view2.hidden = true
            self.view3.hidden = true
            self.chartScrollView.hidden = true
            self.adddeviceView.hidden = false
            self.NameLabel.text = "选择老人"
        }
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
         self.hrTabViewModel = HRTabViewModel()
        
        self.chartScrollView.contentSize = CGSize(width: chartwidth * 3, height:chartheight)
        self.chartScrollView.delegate = self
        self.selectButton = self.HourBtn
        
        //画圆
        let outteroriginX = (UIScreen.mainScreen().bounds.width-self.outterCircleHeight)/2
        let distance = (self.outterCircleHeight-self.innerCircleHeight)/2
        let inneroriginX = outteroriginX + distance
        //圆圈粗细根据不同机型确定
        var outterlinewidth:CGFloat = 0
        var innerlinewidth:CGFloat = 0
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        if(screenHeight == 480){//4s
            outterlinewidth = 9
            innerlinewidth = 5
        }else if(screenHeight == 568){//5-5s
            outterlinewidth = 10
            innerlinewidth = 6
        }else if(screenHeight == 667){//6
            outterlinewidth = 11
            innerlinewidth = 7
        }else if(screenHeight == 736){//6p 414
            outterlinewidth = 12
            innerlinewidth = 8
        }
        
        
        self.outercircleView = STLoopProgressView()
        self.outercircleView.addCircleView(CGRectMake(outteroriginX, 15, self.outterCircleHeight, self.outterCircleHeight), withdefaultcolor: self.defaultColor,withstartcolor: self.startColor,withcentercolor: self.centerColor,withendcolor: self.endColor, withlinewidth:outterlinewidth)
        self.innercircleView = STLoopProgressView()
        self.innercircleView.addCircleView(CGRectMake(inneroriginX, 15+distance, self.innerCircleHeight, self.innerCircleHeight),withdefaultcolor: self.defaultColor,withstartcolor: self.avgColor,withcentercolor: self.avgColor,withendcolor: self.avgColor, withlinewidth:innerlinewidth)

        
        self.view1.addSubview(self.outercircleView)
        self.view1.addSubview(self.innercircleView)
        
        
//        //初始化chartview1的值
//        let valueList1 = [ "20","35","97","70","30","40","20"]
//        let valueListForX1:NSArray = NSArray(objects: "1","2","3","4","5","6")
//        let titleNameList1 = "心率"
//        chartScrollView.chartView1.valueAll =  NSArray(objects:valueList1) as [AnyObject]
//        chartScrollView.chartView1.valueXList = valueListForX1 as [AnyObject]
//        chartScrollView.chartView1.valueTitleNames =  NSArray(objects:titleNameList1) as [AnyObject]
//        chartScrollView.chartView1.Type = "1"
//        chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
//        
//        
//        let valueList2 = ["20","15","9","10","30","40"]
//        let valueListForX2:NSArray = NSArray(objects: "1","2","3","4","5","6")
//        let titleNameList2 = "呼吸"
//        chartScrollView.chartView2.valueAll =  NSArray(objects:valueList2) as [AnyObject]
//        chartScrollView.chartView2.valueXList = valueListForX2 as [AnyObject]
//        chartScrollView.chartView2.valueTitleNames = NSArray(objects:titleNameList2) as [AnyObject]
//        chartScrollView.chartView2.Type = "2"
//        chartScrollView.chartView2.addTrendChartView(CGRectMake(chartwidth, 0, chartwidth, chartheight))
//        
//        let valueList3 = ["30","40","20","50","0","0"]
//        let valueListForX3:NSArray = NSArray(objects: "1","2","3","4","5","6")
//        let titleNameList3 = "呼吸"
//        chartScrollView.chartView3.valueAll =  NSArray(objects:valueList3) as [AnyObject]
//        chartScrollView.chartView3.valueXList = valueListForX3 as [AnyObject]
//        chartScrollView.chartView3.valueTitleNames =  NSArray(objects:titleNameList3) as [AnyObject]
//        chartScrollView.chartView3.Type = "2"
//        chartScrollView.chartView3.addTrendChartView(CGRectMake(chartwidth*2, 0, chartwidth, chartheight))
//        
        //往scrollview里添加chartview集合
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        //   self.chartScrollView.bringSubviewToFront(chartView1)
        self.chartScrollView.addSubview(chartScrollView.chartView2)
        //    self.chartScrollView.bringSubviewToFront(chartView2)
        self.chartScrollView.addSubview(chartScrollView.chartView3)
        
        
        
       
        //模型绑定页面控件
      
         RACObserve(self.hrTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.hrTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.hrTabViewModel, "AlarmNoticeImage") ~> RAC(self, "alarmNoticeImageName")
        RACObserve(self.hrTabViewModel, "CurrentHRImage") ~> RAC(self, "currentHRImageName")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self.CurrentHRLabel, "text")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self.circleHRLabel, "text")
        
        RACObserve(self.hrTabViewModel, "LastAvgHR") ~> RAC(self.AvgHRLabel, "text")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self, "currentHR")
        RACObserve(self.hrTabViewModel, "LastAvgHR") ~> RAC(self, "avgHR")
   
        RACObserve(self.hrTabViewModel, "HRDayReport") ~> RAC(self, "HRDayReportList")
        RACObserve(self.hrTabViewModel, "HRWeekReport") ~> RAC(self, "HRWeekReportList")
        RACObserve(self.hrTabViewModel, "HRMonthReport") ~> RAC(self, "HRMonthReportList")
        
        
        self.ChangePatientBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(self.popDownListForIphone == nil){
                    
                    self.popDownListForIphone = PopDownListForIphone()
                    self.popDownListForIphone?.delegate = self
                }
                self.popDownListForIphone?.Show("选择老人", source:self.hrTabViewModel.PatientList)
        }
    }
    
    
    //左右滑动图表
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //topview中的导航栏label随着scrollview滑动
        var offset = self.chartScrollView.contentOffset.x
        var offsetScale = offset/self.view.frame.size.width
        self.SelectUnderline.frame = CGRectMake(offsetScale*selectunderlineWidth,30,selectunderlineWidth, 2)
        
        var buttonindex = Int(offsetScale)
        switch(buttonindex){
        case 0:
            if self.selectButton.tag != 0{
                self.selectButton.titleLabel?.textColor = self.noselectColor
                self.selectButton = self.HourBtn
                self.selectButton.titleLabel?.textColor = self.selectColor
            }
        case 1:
            if self.selectButton.tag != 1{
                self.selectButton.titleLabel?.textColor = self.noselectColor
                self.selectButton = self.WeekBtn
                self.selectButton.titleLabel?.textColor = self.selectColor
            }
        case 2:
            if self.selectButton.tag != 2{
                self.selectButton.titleLabel?.textColor = self.noselectColor
                self.selectButton = self.MonthBtn
                self.selectButton.titleLabel?.textColor = self.selectColor
            }
            
        default:break
            
        }
    }
    
    //scrollview内发生点击事件，重写touchesbegan方法。（手势操作默认会被scrollview捕获，无法用button的action进行监听）
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        print("ok2")
        self.chartScrollView.delaysContentTouches = false
        //根据偏移量确定传递给哪个chatview
        var offset = self.chartScrollView.contentOffset.x
        var index:Int = Int(Float(offset)/Float(UIScreen.mainScreen().bounds.width))
        switch(index){
        case 0:
            self.chartScrollView.chartView1.touchesBegan(touches, withEvent: event)
        case 1:
            self.chartScrollView.chartView2.touchesBegan(touches, withEvent: event)
        case 2:
            self.chartScrollView.chartView3.touchesBegan(touches, withEvent: event)
        default:break
            
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        print("ok4")
        self.chartScrollView.delaysContentTouches = true
    }
    
    //弹窗选择老人，进行点击后的操作
    func ChoosedItem(item:PopDownListItem){
        self.hrTabViewModel.ChangePatient(item.key!, bedusername: item.value!, equipmentid: item.equipmentcode!)

    }
    
}
