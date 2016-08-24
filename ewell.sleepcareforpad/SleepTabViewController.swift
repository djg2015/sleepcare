//
//  SleepTabViewController.swift
//
//
//  Created by Qinyuan Liu on 6/28/16.
//
//

import UIKit

class SleepTabViewController: UIViewController,UIScrollViewDelegate,PopDownListItemChoosed,SelectDateDelegate {
    
    @IBOutlet weak var adddeviceView: UIView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var sleepTabbar: UITabBarItem!
    
    
    
    //标题老人名字(为空时显示“选择老人”)
    @IBOutlet weak var NameLabel: UILabel!
    //切换当前老人
    @IBOutlet weak var ChangePatientBtn: UIButton!
    
    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
    //睡眠时长数据
    @IBOutlet weak var AwakingLabel: UILabel!
    @IBOutlet weak var LightSleepLabel: UILabel!
    @IBOutlet weak var DeepSleepLabel: UILabel!
    @IBOutlet weak var circleHourLabel: UILabel!
    @IBOutlet weak var circleMinuteLabel: UILabel!
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    
    
    var sleepTabViewModel:SleepTabViewModel!
    //圆圈
    var bigcircleView: sleepcircle!
    
    
    
    //选择老人下拉列表
    var popDownListForIphone:PopDownListForIphone?
    var patientDownlist:Array<PopDownListItem> = Array<PopDownListItem>()
    
    @IBAction func ClickChangePatient(sender:UIButton){
        
        self.ChangePatient()
    }
    
    
    var circlevaluelist:Array<CGFloat>?{
        didSet{
            if(circlevaluelist != nil && (circlevaluelist!.count==3)){
                self.bigcircleView.deepsleepvalue = circlevaluelist![0]
                self.bigcircleView.lightsleepvalue = circlevaluelist![1]
                self.bigcircleView.awakevalue = circlevaluelist![2]
                self.bigcircleView.drawcircle()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.popDownListForIphone = nil
        
        if  self.sleepTabViewModel == nil{
            self.sleepTabViewModel = SleepTabViewModel()
        }
        
        self.RefreshSleepView()
        
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
    
    
    
    func rac_settings(){
        self.sleepTabViewModel = SleepTabViewModel()
        
        self.chartScrollView.contentSize = CGSize(width: chartwidth , height:chartheight)
        self.chartScrollView.delegate = self
        
        //画圆
        let bigoriginX = (UIScreen.mainScreen().bounds.width-bigCircleHeight)/2
        
        AwakingLabel.textColor = awakeColor
        LightSleepLabel.textColor = lightsleepColor
        DeepSleepLabel.textColor = deepsleepColor
        
        
        //圆圈粗细根据不同机型确定
        var biglinewidth:CGFloat = 0
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        if(screenHeight == 480){//4s
            biglinewidth = 10
            
        }else if(screenHeight == 568){//5-5s
            biglinewidth = 14
            
            
        }else if(screenHeight == 667){//6
            biglinewidth = 16
            
        }else if(screenHeight == 736){//6p 414
            biglinewidth = 18
            
        }
        
        self.bigcircleView = sleepcircle(frame: CGRectMake(bigoriginX, 30, bigCircleHeight, bigCircleHeight))
        self.bigcircleView.lineWidth = biglinewidth
        self.bigcircleView.lightsleeplineColor = lightsleepColor
         self.bigcircleView.lightsleepvalue = 0.0
        self.bigcircleView.deepsleeplineColor = deepsleepColor
        self.bigcircleView.deepsleepvalue = 0.0
        self.bigcircleView.awakelineColor = awakeColor
       self.bigcircleView.awakevalue = 0.0
        self.bigcircleView.drawcircle()
        self.view1.addSubview(self.bigcircleView)
        
        
        
        //chart放入scroolview
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        
        
        
        //控件绑定
        RACObserve(self.sleepTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.sleepTabViewModel, "StatusImage") ~> RAC(self.BedStatusImg, "image")
        RACObserve(self.sleepTabViewModel, "AwakeningTimespan") ~> RAC(self.AwakingLabel, "text")
        RACObserve(self.sleepTabViewModel, "LightSleepTimespan") ~> RAC(self.LightSleepLabel, "text")
        RACObserve(self.sleepTabViewModel, "DeepSleepTimespan") ~> RAC(self.DeepSleepLabel, "text")
        RACObserve(self.sleepTabViewModel, "BedTimespanHour") ~> RAC(self.circleHourLabel, "text")
        RACObserve(self.sleepTabViewModel, "BedTimespanMinute") ~> RAC(self.circleMinuteLabel, "text")
        RACObserve(self.sleepTabViewModel, "CircleValueList") ~> RAC(self, "circlevaluelist")
        
        
        
        
        //点击名字，切换老人
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ChangePatient")
        self.NameLabel.addGestureRecognizer(singleTap2)
        self.NameLabel.userInteractionEnabled = true
        
    }
    
    //scrollview内发生点击事件，重写touchesbegan方法。（手势操作默认会被scrollview捕获，无法用button的action进行监听）
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        print("ok2")
        self.chartScrollView.delaysContentTouches = false
        self.chartScrollView.chartView1.touchesBegan(touches, withEvent: event)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        print("ok4")
        self.chartScrollView.delaysContentTouches = true
    }
    
    
    //选择日期，弹窗
    func ChangeDate(){
        if self.sleepTabViewModel.BedUserCode == ""{
            showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
        }
        else{
            //设置日期弹出窗口
            var alertview:DatePickerView = DatePickerView(frame:UIScreen.mainScreen().bounds)
            alertview.datedelegate = self
            self.view.addSubview(alertview)
        }
        
    }
    
    func SelectDate(sender: UIView, dateString: String) {
        self.sleepTabViewModel.SelectDate = dateString
        
        self.RefreshSleepView()
    }
    
    
    //弹窗选择老人，进行点击后的操作
    func ChoosedItem(item:PopDownListItem){
        if self.sleepTabViewModel.BedUserCode != item.key!{
            
            SessionForSingle.GetSession()?.CurPatientCode = item.key!
            SessionForSingle.GetSession()?.CurPatientName = item.value!
            
            self.sleepTabViewModel.BedUserCode = item.key!
            self.sleepTabViewModel.BedUserName = item.value!
            
            PLISTHELPER.CurPatientName = item.value!
            PLISTHELPER.CurPatientCode = item.key!
            
            self.RefreshSleepView()
        }
    }
    
    //---------------------刷新页面数据---------------------
    func RefreshSleepView(){
        
        let flag = self.sleepTabViewModel.LoadPatientSleep()
        //显示内容
        if flag == "1"{
            //清除scrollview中chartview的内容
            self.chartScrollView.chartView1.RemoveTrendChartView()
            
            if self.sleepTabViewModel.SleepReport.flag{
                //刷新数据
                self.chartScrollView.chartView1.valueAll =  self.sleepTabViewModel.SleepReport.ValueY as [AnyObject]
                self.chartScrollView.chartView1.valueXList = self.sleepTabViewModel.SleepReport.ValueX as [AnyObject]
                self.chartScrollView.chartView1.valueTitleNames = self.sleepTabViewModel.SleepReport.ValueTitles as [AnyObject]
                chartScrollView.chartView1.Type = self.sleepTabViewModel.SleepReport.Type
                
                chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
                print( chartScrollView.frame)
                
                print("\n")
            }
            
            
            
            
            //显示设置
            self.adddeviceView.hidden = true
            self.view1.hidden = false
            self.view2.hidden = false
            self.chartScrollView.hidden = false
            
            
            
        }
            //当前有老人设备但没有选择：隐藏除topview之外的subviews，需要选择一个老人后再刷新页面显示具体内容
        else if flag == "2"{
            self.view1.hidden = true
            self.view2.hidden = true
            self.chartScrollView.hidden = true
            self.adddeviceView.hidden = true
            self.NameLabel.text = "选择老人"
            
        }
            //当前没有设备：隐藏页面内所有的subviews,提示添加noticeview提示先添加设备
        else if  flag == "3"{
            self.view1.hidden = true
            self.view2.hidden = true
            self.chartScrollView.hidden = true
            self.adddeviceView.hidden = false
            self.NameLabel.text = "选择老人"
        }
    }
    
}
