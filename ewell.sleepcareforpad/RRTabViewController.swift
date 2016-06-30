//
//  RRTabViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/27/16.
//
//

import UIKit

class RRTabViewController: UIViewController,UIScrollViewDelegate,PopDownListItemChoosed {

    @IBOutlet weak var adddeviceView: UIView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var rrTabbar: UITabBarItem!
    //标题老人名字(为空时显示“选择老人”)
    @IBOutlet weak var NameLabel: UILabel!
    
    //紧急状态图标：呼吸过高或过低
    @IBOutlet weak var alarmNoticeImg: UIImageView!
    //切换当前老人
    @IBOutlet weak var ChangePatientBtn: UIButton!
    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
    //实时／平均呼吸数据
    @IBOutlet weak var CurrentRRImg: UIImageView!
    @IBOutlet weak var CurrentRRLabel: UILabel!
    @IBOutlet weak var AvgRRLabel: UILabel!
    @IBOutlet weak var circleRRLabel: UILabel!
    
    //滑动栏
    @IBOutlet weak var SelectUnderline: UILabel!
    @IBOutlet weak var HourBtn: UIButton!
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var WeekBtn: UIButton!
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    
    //-------------------------------变量定义-------------------------------
    //滑动栏内选中的button
    var selectButton:UIButton!
    var rrTabViewModel:RRTabViewModel!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    //两个hr圆圈
    var outercircleView: STLoopProgressView!
    var innercircleView: STLoopProgressView!
    
    
    //呼吸最高值60(10-40-60三档)
    var currentRR:String?{
        didSet{
            if currentRR != nil{
                self.outercircleView.persentage = CGFloat((currentRR! as NSString).floatValue)/60.0
                
            }
        }
    }
    
    var avgRR:String?{
        didSet{
            if avgRR != nil{
                self.innercircleView.persentage = CGFloat((avgRR! as NSString).floatValue)/60.0
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
    
    
    //当前心率值（3个范围：低，正常，高）变化到其他范围时，变化点的颜色，圆圈内label的颜色
    var currentRRImageName:String?
        {
        didSet{
            if currentRRImageName != ""{
                self.CurrentRRImg.image = UIImage(named:currentRRImageName!)
                
                if currentRRImageName == "icon_gray circle.png"{
                    self.circleRRLabel.textColor = grayColor
                }
                if currentRRImageName == "icon_blue circle.png"{
                    self.circleRRLabel.textColor = startColor
                }
                else if currentRRImageName == "icon_purple circle.png"{
                    self.circleRRLabel.textColor = centerColor
                }
                else if currentRRImageName == "icon_red circle.png"{
                    self.circleRRLabel.textColor = endColor
                }
                
            }
            else{
                currentRRImageName == "icon_gray circle.png"
                self.circleRRLabel.textColor = grayColor
            }
        }
        
    }
    
    
    
    //选择老人下拉列表
    var popDownListForIphone:PopDownListForIphone?
     var patientDownlist:Array<PopDownListItem> = Array<PopDownListItem>()
    
    //-------------------------------方法定义-------------------------------
    //点击滑动栏的button，显示对应的chart
    @IBAction func ClickTimeButton(sender:UIButton){
        self.chartScrollView.setContentOffset(CGPointMake((CGFloat)(sender.tag) * chartwidth, 0.0),animated:true)
    }
    
    
    @IBAction func ClickChangePatient(sender:UIButton){
        self.ChangePatient()
        
    }
    
    
    
     func ChangePatient(){
        if(self.popDownListForIphone == nil){
            
            self.popDownListForIphone = PopDownListForIphone()
            self.popDownListForIphone?.delegate = self
            
            var tempPatientList:Array<EquipmentInfo> = SessionForSingle.GetSession()!.EquipmentList
            self.patientDownlist = Array<PopDownListItem>()
            for(var i=0;i<tempPatientList.count;i++){
                var item:PopDownListItem = PopDownListItem()
                item.key = tempPatientList[i].BedUserCode
                item.value = tempPatientList[i].BedUserName
                item.equipmentcode = tempPatientList[i].EquipmentID
                patientDownlist.append(item)
            }
            
        }
        
        self.popDownListForIphone?.Show("选择老人", source:patientDownlist)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
         self.popDownListForIphone = nil
        
        if  self.rrTabViewModel == nil{
            self.rrTabViewModel = RRTabViewModel()
        }
        
        self.RefreshRRView()
        
        currentController = self
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        rac_settings()
        //第一次显示页面时手动调用viewwillappear？？bug
      //  self.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rac_settings(){
        self.rrTabViewModel = RRTabViewModel()
        
        self.chartScrollView.contentSize = CGSize(width: chartwidth * 3, height:chartheight)
        self.chartScrollView.delegate = self
        self.selectButton = self.HourBtn
        
        //画圆
        let outteroriginX = (UIScreen.mainScreen().bounds.width-outterCircleHeight)/2
        let distance = (outterCircleHeight-innerCircleHeight)/2
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
        self.outercircleView.addCircleView(CGRectMake(outteroriginX, 15, outterCircleHeight, outterCircleHeight), withdefaultcolor: defaultColor,withstartcolor: startColor,withcentercolor: centerColor,withendcolor: endColor, withlinewidth:outterlinewidth)
        self.innercircleView = STLoopProgressView()
        self.innercircleView.addCircleView(CGRectMake(inneroriginX, 15+distance, innerCircleHeight, innerCircleHeight),withdefaultcolor:defaultColor,withstartcolor: avgColor,withcentercolor:avgColor,withendcolor: avgColor, withlinewidth:innerlinewidth)
        
        
        self.view1.addSubview(self.outercircleView)
        self.view1.addSubview(self.innercircleView)
        
        //往scrollview里添加chartview集合
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        //   self.chartScrollView.bringSubviewToFront(chartView1)
        self.chartScrollView.addSubview(chartScrollView.chartView2)
        //    self.chartScrollView.bringSubviewToFront(chartView2)
        self.chartScrollView.addSubview(chartScrollView.chartView3)
        
        
        
        
        //模型绑定页面控件
        RACObserve(self.rrTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.rrTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.rrTabViewModel, "AlarmNoticeImage") ~> RAC(self.alarmNoticeImg, "image")
        RACObserve(self.rrTabViewModel, "CurrentRRImage") ~> RAC(self, "currentRRImageName")
        RACObserve(self.rrTabViewModel, "CurrentRR") ~> RAC(self.CurrentRRLabel, "text")
        RACObserve(self.rrTabViewModel, "CurrentRR") ~> RAC(self.circleRRLabel, "text")
        RACObserve(self.rrTabViewModel, "LastAvgRR") ~> RAC(self.AvgRRLabel, "text")
        RACObserve(self.rrTabViewModel, "CurrentRR") ~> RAC(self, "currentRR")
        RACObserve(self.rrTabViewModel, "LastAvgRR") ~> RAC(self, "avgRR")
        
        
        //点击名字，切换老人
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ChangePatient")
        self.NameLabel.addGestureRecognizer(singleTap)
        self.NameLabel.userInteractionEnabled = true
     
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
                self.selectButton.titleLabel?.textColor = noselectColor
                self.selectButton = self.HourBtn
                self.selectButton.titleLabel?.textColor = selectColor
            }
        case 1:
            if self.selectButton.tag != 1{
                self.selectButton.titleLabel?.textColor = noselectColor
                self.selectButton = self.WeekBtn
                self.selectButton.titleLabel?.textColor = selectColor
            }
        case 2:
            if self.selectButton.tag != 2{
                self.selectButton.titleLabel?.textColor = noselectColor
                self.selectButton = self.MonthBtn
                self.selectButton.titleLabel?.textColor = selectColor
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
        if self.rrTabViewModel.BedUserCode != item.key!{
        self.rrTabViewModel.realtimeFlag = false
        
        SessionForSingle.GetSession()?.CurPatientCode = item.key!
        SessionForSingle.GetSession()?.CurPatientName = item.value!
        
        self.rrTabViewModel.BedUserCode = item.key!
        self.rrTabViewModel.BedUserName = item.value!
        
            SetValueIntoPlist("curPatientCode", item.key!)
            SetValueIntoPlist("curPatientName", item.value!)
           
            
        self.RefreshRRView()
        self.rrTabViewModel.realtimeFlag = true
    }
    }
    
    //---------------------刷新页面数据---------------------
    func RefreshRRView(){
        
        let flag = self.rrTabViewModel.LoadPatientRR()
        //显示内容
        if flag == "1"{
            //清除scrollview中chartview的内容
            self.chartScrollView.chartView1.RemoveTrendChartView()
            self.chartScrollView.chartView2.RemoveTrendChartView()
            self.chartScrollView.chartView3.RemoveTrendChartView()
            
            //刷新数据
            if self.rrTabViewModel.RRDayReport.flag{
            self.chartScrollView.chartView1.valueAll =  self.rrTabViewModel.RRDayReport.ValueY as [AnyObject]
            self.chartScrollView.chartView1.valueXList = self.rrTabViewModel.RRDayReport.ValueX as [AnyObject]
            self.chartScrollView.chartView1.valueTitleNames = self.rrTabViewModel.RRDayReport.ValueTitles as [AnyObject]
            chartScrollView.chartView1.Type = self.rrTabViewModel.RRDayReport.Type
            chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
            }
            
            if self.rrTabViewModel.RRWeekReport.flag{
            self.chartScrollView.chartView2.valueAll =  self.rrTabViewModel.RRWeekReport.ValueY as [AnyObject]
            self.chartScrollView.chartView2.valueXList = self.rrTabViewModel.RRWeekReport.ValueX as [AnyObject]
            self.chartScrollView.chartView2.valueTitleNames = self.rrTabViewModel.RRWeekReport.ValueTitles as [AnyObject]
            chartScrollView.chartView2.Type = self.rrTabViewModel.RRWeekReport.Type
            chartScrollView.chartView2.addTrendChartView(CGRectMake(chartwidth, 0, chartwidth, chartheight))
            }
            
            if self.rrTabViewModel.RRMonthReport.flag{
            self.chartScrollView.chartView3.valueAll =  self.rrTabViewModel.RRMonthReport.ValueY as [AnyObject]
            self.chartScrollView.chartView3.valueXList = self.rrTabViewModel.RRMonthReport.ValueX as [AnyObject]
            self.chartScrollView.chartView3.valueTitleNames = self.rrTabViewModel.RRMonthReport.ValueTitles as [AnyObject]
            chartScrollView.chartView3.Type = self.rrTabViewModel.RRMonthReport.Type
            chartScrollView.chartView3.addTrendChartView(CGRectMake(chartwidth*2, 0, chartwidth, chartheight))
            }
            
            //显示设置
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
        
    }
}
