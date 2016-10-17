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
    
 //圆圈内当前心率
    @IBOutlet weak var circleHRLabel: UILabel!
    // 值
    @IBOutlet weak var currentHRLabel: HrRrSleepTabLabel!
    @IBOutlet weak var avgHRLabel: HrRrSleepTabLabel!
    
    //滑动栏
    @IBOutlet weak var SelectUnderline: UILabel!
    @IBOutlet weak var HourBtn: UIButton!
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var WeekBtn: UIButton!
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    @IBOutlet weak var longlineLabel: UILabel!
    
    //-------------------------------变量定义-------------------------------
    //滑动栏内选中的button
    var selectButton:UIButton!
    var hrTabViewModel:HRTabViewModel!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    //两个hr圆圈
    var outercircleView: STLoopProgressView!
   
    
    //心率最高值120（30-100-120三档）
    var currentHR:String?{
        didSet{
            if currentHR != nil{
                self.outercircleView.persentage = CGFloat((currentHR! as NSString).floatValue)/120.0
                
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
    var currentHRImageName:String?
        {
        didSet{
            if currentHRImageName != ""{
               
                
                if currentHRImageName == "icon_gray circle.png"{
                    self.circleHRLabel.textColor = grayColor
                   
                }
                if currentHRImageName == "icon_blue circle.png"{
                    self.circleHRLabel.textColor = startColor
                }
                else if currentHRImageName == "icon_purple circle.png"{
                    self.circleHRLabel.textColor = centerColor
                }
                else if currentHRImageName == "icon_red circle.png"{
                    self.circleHRLabel.textColor = endColor
                }
                
            }
            else{
                currentHRImageName == "icon_gray circle.png"
                self.circleHRLabel.textColor = grayColor
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
                self.patientDownlist.append(item)
            }

        }
        self.popDownListForIphone?.Show("选择老人", source:self.patientDownlist)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.popDownListForIphone = nil
        
        if  self.hrTabViewModel == nil{
            self.hrTabViewModel = HRTabViewModel()
        }
        
        self.RefreshHRView()
        
        currentController = self
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        rac_settings()
        if SessionForSingle.GetSession()!.CurPatientCode == ""{
            self.ChangePatient()
        }
        //第一次显示页面时手动调用viewwillappear？？bug
        self.viewWillAppear(true)
        
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
        
         let screenHeight = UIScreen.mainScreen().bounds.size.height
         if(screenHeight == 480){//4s
       //  outterCircleHeight = outterCircleHeight*0.9;
            circleHRLabel.font = UIFont.systemFontOfSize(55);
        }
         else if(screenHeight == 736){//6p 414
        //  outterCircleHeight = outterCircleHeight*1.1;
             circleHRLabel.font = UIFont.systemFontOfSize(75);
        }

        //
        self.currentHRLabel.textColor = selectColor
        self.avgHRLabel.textColor = avgColor
        
       
        //画圆
        let outteroriginX = (UIScreen.mainScreen().bounds.width-outterCircleHeight)/2
       
        //圆圈粗细根据不同机型确定
        var outterlinewidth:CGFloat = 0
        if(screenHeight == 480){//4s
            outterlinewidth = 11
           
        }else if(screenHeight == 568){//5-5s
            outterlinewidth = 14
            
        }else if(screenHeight == 667){//6
            outterlinewidth = 16
            
        }else if(screenHeight == 736){//6p 414
            outterlinewidth = 18
            
        }
        
        //6以上的scrollview没有边框，需要手动添加longline
//        if(screenHeight > 650){
//        longlineLabel.hidden = false
//        }

        
        self.outercircleView = STLoopProgressView()
        self.outercircleView.addCircleView(CGRectMake(outteroriginX, 10, outterCircleHeight, outterCircleHeight), withdefaultcolor: defaultColor,withstartcolor: startColor,withcentercolor: centerColor,withendcolor: endColor, withlinewidth:outterlinewidth)
        self.view1.addSubview(self.outercircleView)
        
        
        //往scrollview里添加chartview集合
    
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        self.chartScrollView.addSubview(chartScrollView.chartView2)
        self.chartScrollView.addSubview(chartScrollView.chartView3)
        

        //模型绑定页面控件
        RACObserve(self.hrTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.hrTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.hrTabViewModel, "AlarmNoticeImage") ~> RAC(self.alarmNoticeImg, "image")
        RACObserve(self.hrTabViewModel, "CurrentHRImage") ~> RAC(self, "currentHRImageName")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self.circleHRLabel, "text")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self, "currentHR")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self.currentHRLabel, "text")
         RACObserve(self.hrTabViewModel, "LastAvgHR") ~> RAC(self.avgHRLabel, "text")
        
        //点击名字，切换老人
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ChangePatient")
        self.NameLabel.addGestureRecognizer(singleTap)
        self.NameLabel.userInteractionEnabled = true
      
    }
    
    
    //左右滑动图表
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //topview中的导航栏label随着scrollview滑动
        var offset = self.chartScrollView.contentOffset.x
        var offsetScale = offset/(self.view.frame.size.width-40)
        self.SelectUnderline.frame = CGRectMake(offsetScale*selectunderlineWidth,31,selectunderlineWidth, 2)
        
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
        var index:Int = Int(Float(offset)/Float(UIScreen.mainScreen().bounds.width-40 ))
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
        if self.hrTabViewModel.BedUserCode != item.key!{
        self.hrTabViewModel.realtimeFlag = false
        SessionForSingle.GetSession()?.CurPatientCode = item.key!
        SessionForSingle.GetSession()?.CurPatientName = item.value!
            
        
        self.hrTabViewModel.BedUserCode = item.key!
        self.hrTabViewModel.BedUserName = item.value!
        
            
            PLISTHELPER.CurPatientName = item.value!
             PLISTHELPER.CurPatientCode = item.key!
            
            
        self.RefreshHRView()
        self.hrTabViewModel.realtimeFlag = true
        }
    }
    
    //---------------------刷新页面数据---------------------
    func RefreshHRView(){
        
        let flag = self.hrTabViewModel.LoadPatientHR()
        //显示内容
        if flag == "1"{
            //清除scrollview中chartview的内容
            self.chartScrollView.chartView1.RemoveTrendChartView()
            self.chartScrollView.chartView2.RemoveTrendChartView()
            self.chartScrollView.chartView3.RemoveTrendChartView()
            
            //刷新数据
            if self.hrTabViewModel.HRDayReport.flag{
            self.chartScrollView.chartView1.valueAll =  self.hrTabViewModel.HRDayReport.ValueY as [AnyObject]
            self.chartScrollView.chartView1.valueXList = self.hrTabViewModel.HRDayReport.ValueX as [AnyObject]
            self.chartScrollView.chartView1.valueTitleNames = self.hrTabViewModel.HRDayReport.ValueTitles as [AnyObject]
            chartScrollView.chartView1.Type = self.hrTabViewModel.HRDayReport.Type
            chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
            }
            
            if self.hrTabViewModel.HRWeekReport.flag {
            self.chartScrollView.chartView2.valueAll =  self.hrTabViewModel.HRWeekReport.ValueY as [AnyObject]
            self.chartScrollView.chartView2.valueXList = self.hrTabViewModel.HRWeekReport.ValueX as [AnyObject]
            self.chartScrollView.chartView2.valueTitleNames = self.hrTabViewModel.HRWeekReport.ValueTitles as [AnyObject]
            chartScrollView.chartView2.Type = self.hrTabViewModel.HRWeekReport.Type
            chartScrollView.chartView2.addTrendChartView(CGRectMake(chartwidth, 0, chartwidth, chartheight))
            }
            
            if self.hrTabViewModel.HRMonthReport.flag{
            self.chartScrollView.chartView3.valueAll =  self.hrTabViewModel.HRMonthReport.ValueY as [AnyObject]
            self.chartScrollView.chartView3.valueXList = self.hrTabViewModel.HRMonthReport.ValueX as [AnyObject]
            self.chartScrollView.chartView3.valueTitleNames = self.hrTabViewModel.HRMonthReport.ValueTitles as [AnyObject]
            chartScrollView.chartView3.Type = self.hrTabViewModel.HRMonthReport.Type
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
