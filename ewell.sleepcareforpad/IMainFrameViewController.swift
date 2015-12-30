//
//  IMainFrameViewController.swift
//
//
//  Created by djg on 15/11/10.
//
//

import UIKit

class IMainFrameViewController: IBaseViewController,LoadingHRDelegate,LoadingRRDelegate,GetAlarmCountDelegate {
    @IBOutlet weak var uiHR: BackgroundCommon!
    @IBOutlet weak var uiRR: BackgroundCommon!
    @IBOutlet weak var uiSleepCare: BackgroundCommon!
    @IBOutlet weak var uiMe: BackgroundCommon!
    @IBOutlet weak var svMain: UIScrollView!
    @IBOutlet weak var uiMenu: UIView!
    @IBOutlet weak var btnHR: UIButton!
    @IBOutlet weak var btnRR: UIButton!
    @IBOutlet weak var btnSleep: UIButton!
    @IBOutlet weak var btnMe: UIButton!
    @IBOutlet weak var lblAlarmCount: UILabel!
    
    var spinner:JHSpinnerView?
    
    var _curMenu:BackgroundCommon?
    var curMenu:BackgroundCommon?{
        get{
            return self._curMenu
        }
        set(value){
            if(self._curMenu != nil){
                self._curMenu?.backgroundColor = UIColor.clearColor()
            }
            self._curMenu = value
            for menu in  self.uiMenu.subviews{
                if(menu as? BackgroundCommon !=  self._curMenu)
                {
                    (menu as! BackgroundCommon).backgroundColor = UIColor.clearColor()
                }
            }
            
            self._curMenu?.backgroundColor = UIColor(red: 0.85490196078431369, green: 0.85490196078431369, blue: 0.85490196078431369, alpha: 1)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,bedUserCode:String?,equipmentID:String?,bedUserName:String?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.bedUserCode = bedUserCode
        self.equipmentID = equipmentID
        self.bedUserName = bedUserName
    }
    
    var bedUserCode:String?
    var equipmentID:String?
    var bedUserName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAlarmHelper.GetAlarmInstance().alarmcountdelegate = self
        
        
        self.svMain.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-46)
        
        //右划
        var swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRightGesture)
        //左划
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        //设置按钮事件
        self.btnHR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.ClickHR()
        }
        self.btnRR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
               self.ClickRR()
        }
        self.btnSleep!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.ClickSleep()
        }
        self.btnMe!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
               self.ClickMe()
        }
        
        //设置主体界面
        if(nil != self.bedUserCode)
        {
            let firstVew = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
            firstVew.viewInit(self, bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            
            firstVew.HRdelegate = self
            
            showBody(firstVew, nibName:"IHRMonitor")
        }
        else
        {
            self.curMenu = self.uiMe
            let firstVew = NSBundle.mainBundle().loadNibNamed("IMySelfConfiguration", owner: self, options: nil).first as! IMySelfConfiguration
            firstVew.viewInit(self,bedUserCode: nil,equipmentID:self.equipmentID)
            showBody(firstVew,nibName: "IMySelfConfiguration")
        }
        
    }
    
    func ClickHR(){
        if(nil != self.bedUserCode)
        {
            self.curMenu = self.uiHR
            let iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
            
            iHRMonitorView.viewInit(self, bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            
            iHRMonitorView.HRdelegate = self
            
            self.showBody(iHRMonitorView,nibName: "IHRMonitor")
        }
        else
        {
            showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
        }
        
    }
    
    func ClickRR(){
        if(nil != self.bedUserCode)
        {
            self.curMenu = self.uiRR
            let iRRMonitorView = NSBundle.mainBundle().loadNibNamed("IRRMonitor", owner: self, options: nil).first as! IRRMonitor
            
            iRRMonitorView.viewInit(self, bedUserCode: self.bedUserCode!, bedUserName: self.bedUserName!)
            iRRMonitorView.RRdelegate = self
            
            self.showBody(iRRMonitorView,nibName: "IRRMonitor")
        }
        else
        {
            showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
        }
    }
    
    func ClickSleep(){
        if(nil != self.bedUserCode)
        {
            self.curMenu = self.uiSleepCare
            let sleepQualityMonitorView = NSBundle.mainBundle().loadNibNamed("ISleepQualityMonitor", owner: self, options: nil).first as! ISleepQualityMonitor
            
            sleepQualityMonitorView.viewInit(self,bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            
            self.showBody(sleepQualityMonitorView,nibName: "ISleepQualityMonitor")
        }
        else
        {
            showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
        }
}
    func ClickMe(){
        self.curMenu = self.uiMe
        let selfConfiguration = NSBundle.mainBundle().loadNibNamed("IMySelfConfiguration", owner: self, options: nil).first as! IMySelfConfiguration
        
        selfConfiguration.viewInit(self, bedUserCode: self.bedUserCode,equipmentID: self.equipmentID)
        self.showBody(selfConfiguration,nibName: "IMySelfConfiguration")
    }
    
    //左右滑动手势，对应菜单改变
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        var direction = sender.direction
        //判断是左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            if self.curMenu == self.uiHR{
                self.ClickRR()
            }else if self.curMenu == self.uiRR{
            self.ClickSleep()
            }else if self.curMenu == self.uiSleepCare{
            self.ClickMe()
            }
            break
        case UISwipeGestureRecognizerDirection.Right:
            if self.curMenu == self.uiMe{
                self.ClickSleep()
            }else if self.curMenu == self.uiSleepCare{
                self.ClickRR()
            }else if self.curMenu == self.uiRR{
                self.ClickHR()
            }
            break
        default:
            break
        }
    }
    
    func LoadingView() {
        
        self.spinner  = JHSpinnerView.showOnView(self.svMain, spinnerColor:UIColor.whiteColor(), overlay:.FullScreen, overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.6), fullCycleTime:4.0, text:"")
        
    }
    
    //显示菜单界面
    func showBody(jumpview:UIView, nibName:String){
        //        for(var i = 0 ; i < self.svMain.subviews.count; i++) {
        //            self.svMain.subviews[i].removeFromSuperview()
        //        }
        
        jumpview.frame = CGRectMake(0, 0, self.svMain.frame.width, self.svMain.frame.height)
        self.svMain.addSubview(jumpview)
        if nibName == "IHRMonitor" || nibName == "IRRMonitor"{
            self.LoadingView()
        }
    }
    
    func CloseLoadingHR(){
        self.spinner!.dismiss()
    }
    
    func CloseLoadingRR(){
        self.spinner!.dismiss()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func FirstBtnClick(){
        
    }
    
    
    func SecondBtnClick(){
        
    }
    
    
    func ThirdBtnClick(){
        
    }
    
    func FourthBtnClick(){
        
    }
    
    func GetAlarmCount(count:Int){
        if count>0{
            self.lblAlarmCount.text = String(count)
        }
        else{
            self.lblAlarmCount.text = ""
        }
    }
    
}
