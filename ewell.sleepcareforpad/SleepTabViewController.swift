//
//  SleepTabViewController.swift
//
//
//  Created by Qinyuan Liu on 6/28/16.
//
//

import UIKit

class SleepTabViewController: UIViewController,UIScrollViewDelegate,SelectDateDelegate,SleepSetAlarmDelegate{
     @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
   
     @IBOutlet weak var AlarmBtn: UIButton!
    
    
    //标题老人名字(为空时显示“选择老人”)
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
    
     @IBOutlet weak var SleepQualityLabel: UILabel!
    
    
    @IBOutlet weak var OnBedTimeLabel: UILabel!
    
    //睡眠时长数据
    @IBOutlet weak var AwakingLabel: UILabel!
    @IBOutlet weak var LightSleepLabel: UILabel!
    @IBOutlet weak var DeepSleepLabel: UILabel!
  
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    
    //定时器：检查病人是否有报警
    var alarmTimer:NSTimer!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    var sleepTabViewModel:SleepTabViewModel!
    //圆圈
    var bigcircleView: sleepcircle!
     var biglinewidth:CGFloat = 0
    
    //画圆
    let bigoriginX = (SCREENWIDTH-bigCircleHeight)/2
    
   
    var statusImageName:String?
        {
        didSet{
            if (statusImageName != nil && statusImageName != ""){
                self.BedStatusImg.image = UIImage(named:statusImageName!)
            }
            else if statusImageName == ""{
                self.BedStatusImg.image = nil
            }
        }
    }
    
    @IBAction func ClickChangeDate(sender:UIButton){
        
        self.ChangeDate()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sleeptoalarm" {
            let vc = segue.destinationViewController as! ShowAlarmViewController
            vc.usercode = self._bedUserCode
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        if  self.sleepTabViewModel == nil{
            self.sleepTabViewModel = SleepTabViewModel()
        }
        
        
        self.RefreshSleepView()
        
        alarmTimer =  NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        alarmTimer.fire()
        
        IAlarmHelper.GetAlarmInstance()._sleepSetAlarmDelegate = self

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = IAlarmHelper.GetAlarmInstance().Warningcouts
        if count==0{
            
            self.backBtn.setTitle("", forState: UIControlState.Normal)
        }
        else{
            self.backBtn.setTitle(" 报警数" + String(count), forState: UIControlState.Normal)
        }
        // Do any additional setup after loading the view.
        rac_settings()
          }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        alarmTimer.invalidate()
        
        IAlarmHelper.GetAlarmInstance()._sleepSetAlarmDelegate = nil

    }
 
    //bedusercode 和alarmlist中的usercode匹配，设置"报警"是否显示
    func alarmTimerFireMethod(timer: NSTimer) {
        if(self._bedUserCode != nil){
            AlarmBtn.hidden = self.AlarmNotice(self._bedUserCode)
            
        }
    }
    
    func AlarmNotice(currentusercode:String)->Bool{
        var alarmPatientlist = IAlarmHelper.GetAlarmInstance().WarningList.filter({$0.UserCode == currentusercode})
        if(alarmPatientlist.count>0){
            return false
        }
        return true
    }
    
    
    func rac_settings(){
        self.sleepTabViewModel = SleepTabViewModel()
        
        self.chartScrollView.contentSize = CGSize(width: chartwidth , height:chartheight)
        self.chartScrollView.delegate = self
        
       
        
        AwakingLabel.textColor = awakeColor
        LightSleepLabel.textColor = lightsleepColor
        DeepSleepLabel.textColor = deepsleepColor
        
        
        //圆圈粗细根据不同机型确定
    
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
        
      
        
        
        
        //chart放入scroolview
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        
        
        
        //控件绑定
        
         RACObserve(self.sleepTabViewModel, "SelectDate") ~> RAC(self.DateLabel, "text")
         RACObserve(self.sleepTabViewModel, "BedUserCode") ~> RAC(self, "_bedUserCode")
        RACObserve(self.sleepTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.sleepTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.sleepTabViewModel, "AwakeningTimespan") ~> RAC(self.AwakingLabel, "text")
        RACObserve(self.sleepTabViewModel, "LightSleepTimespan") ~> RAC(self.LightSleepLabel, "text")
        RACObserve(self.sleepTabViewModel, "DeepSleepTimespan") ~> RAC(self.DeepSleepLabel, "text")
       
        RACObserve(self.sleepTabViewModel, "CircleValueList") ~> RAC(self, "circlevaluelist")
        
         RACObserve(self.sleepTabViewModel, "SleepQuality") ~> RAC(self.SleepQualityLabel, "text")
         RACObserve(self.sleepTabViewModel, "BedTimespan") ~> RAC(self.OnBedTimeLabel, "text")
        
       
        
        //点击日期lable，切换
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ChangeDate")
        self.DateLabel.addGestureRecognizer(singleTap2)
        self.DateLabel.userInteractionEnabled = true
        
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
    
    
   
    func ChangeDate(){
        if self.sleepTabViewModel.BedUserCode != ""{
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
    
    
  
    
    //---------------------刷新页面数据---------------------
    func RefreshSleepView(){
        //清除圆圈
        if(self.bigcircleView != nil){
        self.bigcircleView.removeFromSuperview()
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
        
       self.sleepTabViewModel.LoadPatientSleep()
       
            //清除scrollview中chartview的内容
            self.chartScrollView.chartView1.RemoveTrendChartView()

            if self.sleepTabViewModel.SleepReport.flag{
                //刷新数据
                self.chartScrollView.chartView1.valueAll =  self.sleepTabViewModel.SleepReport.ValueY as [AnyObject]
                self.chartScrollView.chartView1.valueXList = self.sleepTabViewModel.SleepReport.ValueX as [AnyObject]
                self.chartScrollView.chartView1.valueTitleNames = self.sleepTabViewModel.SleepReport.ValueTitles as [AnyObject]
                chartScrollView.chartView1.Type = self.sleepTabViewModel.SleepReport.Type
                chartScrollView.chartView1.addTrendChartView(CGRectMake(0, 0, chartwidth, chartheight))
              
            } 
    }
    
    func SleepSetAlarmPic(count:String){
        if count=="0"{
            
            self.backBtn.setTitle("", forState: UIControlState.Normal)
        }
        else{
            self.backBtn.setTitle(" 报警数"+count, forState: UIControlState.Normal)
        }
        
    }
    
}
