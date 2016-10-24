//
//  RRTabViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/27/16.
//
//

import UIKit

class RRTabViewController: UIViewController,UIScrollViewDelegate,RRSetAlarmDelegate{

  @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    
      @IBOutlet weak var AlarmBtn: UIButton!
  
    //标题老人名字
    @IBOutlet weak var NameLabel: UILabel!
 

    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
    //圆圈内当前呼吸数据
    @IBOutlet weak var circleRRLabel: UILabel!
    
    
    //滑动栏
    @IBOutlet weak var SelectUnderline: UILabel!
    @IBOutlet weak var HourBtn: UIButton!
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var WeekBtn: UIButton!
     @IBOutlet weak var longlineLabel: UILabel!
    //放图表的容器scrollview
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    //定时器：检查病人是否有报警
    var alarmTimer:NSTimer!
    
    //-------------------------------变量定义-------------------------------
    //滑动栏内选中的button
    var selectButton:UIButton!
    var rrTabViewModel:RRTabViewModel!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    //rr圆圈
    var outercircleView: STLoopProgressView!
 
    
    
    //呼吸最高值60(8-30-40三档)
    var currentRR:String?{
        didSet{
            if currentRR != nil{
                let rrfloat = (currentRR! as NSString).floatValue
                self.outercircleView.persentage = CGFloat(rrfloat)/40.0
                
                if((rrfloat<8.0) || (rrfloat > 30.0)){
                    self.circleRRLabel.textColor = redColor
                }
                else{
                    self.circleRRLabel.textColor = rrcolor
                }
            }
        }
    }
    
  
    
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
    
    
    
    
        //-------------------------------方法定义-------------------------------
    //点击滑动栏的button，显示对应的chart
    @IBAction func ClickTimeButton(sender:UIButton){
        self.chartScrollView.setContentOffset(CGPointMake((CGFloat)(sender.tag) * chartwidth, 0.0),animated:true)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rrtoalarm" {
            let vc = segue.destinationViewController as! ShowAlarmViewController
            vc.usercode = self._bedUserCode
        }
    }

   
    
    
    override func viewWillAppear(animated: Bool) {
        if  self.rrTabViewModel == nil{
            self.rrTabViewModel = RRTabViewModel()
        }
        
        self.RefreshRRView()
        
        alarmTimer =  NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        alarmTimer.fire()
        
         IAlarmHelper.GetAlarmInstance()._rrSetAlarmDelegate = self

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
    
    override func viewDidDisappear(animated: Bool) {
        alarmTimer.invalidate()
     IAlarmHelper.GetAlarmInstance()._rrSetAlarmDelegate = nil
        
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
        self.rrTabViewModel = RRTabViewModel()
        
        self.chartScrollView.contentSize = CGSize(width: chartwidth * 3, height:chartheight)
        self.chartScrollView.delegate = self
        self.selectButton = self.HourBtn
        
        
         let screenHeight = UIScreen.mainScreen().bounds.size.height
        if(screenHeight == 480){//4s
        //    outterCircleHeight = outterCircleHeight*0.9;
            circleRRLabel.font = UIFont.systemFontOfSize(65);
        }
        else if(screenHeight == 736){//6p 414
       //     outterCircleHeight = outterCircleHeight*1.1;
            circleRRLabel.font = UIFont.systemFontOfSize(85);
        }
        
        //画圆
        let outteroriginX = (SCREENWIDTH-outterCircleHeight)/2
      
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
//            longlineLabel.hidden = false
//        }
        
        
        self.outercircleView = STLoopProgressView()
        self.outercircleView.addCircleView(CGRectMake(outteroriginX, 10, outterCircleHeight, outterCircleHeight), withdefaultcolor: defaultColor,withstartcolor: startColor,withcentercolor: centerColor,withendcolor: endColor, withlinewidth:outterlinewidth)
        self.view1.addSubview(self.outercircleView)
      
        
        //往scrollview里添加chartview集合
        self.chartScrollView.addSubview(chartScrollView.chartView1)
        self.chartScrollView.addSubview(chartScrollView.chartView2)
        self.chartScrollView.addSubview(chartScrollView.chartView3)
        
        
        
        
        //模型绑定页面控件
         RACObserve(self.rrTabViewModel, "BedUserCode") ~> RAC(self, "_bedUserCode")
        RACObserve(self.rrTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.rrTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.rrTabViewModel, "CurrentRR") ~> RAC(self.circleRRLabel, "text")
        RACObserve(self.rrTabViewModel, "CurrentRR") ~> RAC(self, "currentRR")
       
        
        
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
        var index:Int = Int(Float(offset)/Float(UIScreen.mainScreen().bounds.width-40))
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
        
        SessionForIphone.GetSession()?.CurPatientCode! = item.key!
        SessionForIphone.GetSession()?.CurPatientName! = item.value!
        
        self.rrTabViewModel.BedUserCode = item.key!
        self.rrTabViewModel.BedUserName = item.value!
        
            
            PLISTHELPER.CurPatientName = item.value!
            PLISTHELPER.CurPatientCode = item.key!
            
        self.RefreshRRView()
        self.rrTabViewModel.realtimeFlag = true
    }
    }
    
    //---------------------刷新页面数据---------------------
    func RefreshRRView(){
        
          self.rrTabViewModel.LoadPatientRR()
       
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
            
               
    }
    
    func RRSetAlarmPic(count:String){
        if count=="0"{
            
            self.backBtn.setTitle("", forState: UIControlState.Normal)
        }
        else{
            self.backBtn.setTitle("   报警数"+count, forState: UIControlState.Normal)
        }
        
    }
}
