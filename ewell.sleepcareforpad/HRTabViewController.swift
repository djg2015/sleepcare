//
//  HRTabViewController.swift
//
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class HRTabViewController: UIViewController,UIScrollViewDelegate,HRSetAlarmDelegate{
    
    @IBOutlet weak var backBtn: UIButton!
   
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
   
  
    @IBOutlet weak var AlarmBtn: UIButton!
    
    //标题老人名字
    @IBOutlet weak var NameLabel: UILabel!
    
    //在离床图标
    @IBOutlet weak var BedStatusImg: UIImageView!
    
 //圆圈内当前心率 view1
    @IBOutlet weak var circleHRLabel: UILabel!
    
    //滑动栏 view3
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
    var hrTabViewModel:HRTabViewModel!
    //当前查看的老人
    var _bedUserCode:String!
    var _bedUserName:String!
    
    //hr圆圈
    var outercircleView: STLoopProgressView!
   
    
    //心率最高值120（30-100-120三档）
    var currentHR:String?{
        didSet{
            if currentHR != nil{
                let hrfloat = (currentHR! as NSString).floatValue
                self.outercircleView.persentage = CGFloat(hrfloat)/120.0
                
                if((hrfloat<30.0) || (hrfloat > 100.0)){
                self.circleHRLabel.textColor = redColor
                }
                else{
                self.circleHRLabel.textColor = hrcolor
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
        if segue.identifier == "hrtoalarm" {
            let vc = segue.destinationViewController as! ShowAlarmViewController
            vc.usercode = self._bedUserCode
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        if  self.hrTabViewModel == nil{
            self.hrTabViewModel = HRTabViewModel()
        }
        
        self.RefreshHRView()
        
         alarmTimer =  NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
         alarmTimer.fire()
        
         IAlarmHelper.GetAlarmInstance()._hrSetAlarmDelegate = self
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
        
        IAlarmHelper.GetAlarmInstance()._hrSetAlarmDelegate = nil
        
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

        self.hrTabViewModel = HRTabViewModel()
     
        self.chartScrollView.contentSize = CGSize(width: chartwidth * 3, height:chartheight)
        self.chartScrollView.delegate = self
        self.selectButton = self.HourBtn
        
         let screenHeight = UIScreen.mainScreen().bounds.size.height
         if(screenHeight == 480){//4s
       //  outterCircleHeight = outterCircleHeight*0.9;
            circleHRLabel.font = UIFont.systemFontOfSize(65);
        }
         else if(screenHeight == 736){//6p 414
        //  outterCircleHeight = outterCircleHeight*1.1;
             circleHRLabel.font = UIFont.systemFontOfSize(85);
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
     
          RACObserve(self.hrTabViewModel, "BedUserCode") ~> RAC(self, "_bedUserCode")
        RACObserve(self.hrTabViewModel, "BedUserName") ~> RAC(self.NameLabel, "text")
        RACObserve(self.hrTabViewModel, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self.circleHRLabel, "text")
        RACObserve(self.hrTabViewModel, "CurrentHR") ~> RAC(self, "currentHR")
        
      
      
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
    
    
    //---------------------刷新页面数据---------------------
    func RefreshHRView(){
        
           self.hrTabViewModel.LoadPatientHR()
    
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
    }
    
    
    func HRSetAlarmPic(count:String){
        if count=="0"{
            
            self.backBtn.setTitle("", forState: UIControlState.Normal)
        }
        else{
            self.backBtn.setTitle(" 报警数"+count, forState: UIControlState.Normal)
        }
        
    }
    
}
