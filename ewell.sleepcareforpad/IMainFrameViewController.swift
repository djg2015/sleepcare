//
//  IMainFrameViewController.swift
//
//
//  Created by djg on 15/11/10.
//
//

import UIKit

class IMainFrameViewController: IBaseViewController,LoadingHRDelegate,LoadingRRDelegate,GetAlarmCountDelegate {
    @IBOutlet weak var uiHR: UIView!
    @IBOutlet weak var uiRR: UIView!
    @IBOutlet weak var uiSleepCare: UIView!
    @IBOutlet weak var uiMe: UIView!
    @IBOutlet weak var svMain: UIScrollView!
    @IBOutlet weak var uiMenu: UIView!
    @IBOutlet weak var btnHR: UIButton!
    @IBOutlet weak var btnRR: UIButton!
    @IBOutlet weak var btnSleep: UIButton!
    @IBOutlet weak var btnMe: UIButton!
    @IBOutlet weak var lblAlarmCount: UILabel!
    @IBOutlet weak var imgAlarm: UIImageView!
    

    var spinner:JHSpinnerView?
    var iRRMonitorView:IRRMonitor? = nil
    var iHRMonitorView:IHRMonitor? = nil
    var _curMenu:UIView?
    var curMenu:UIView?{
        get{
            return self._curMenu
        }
        set(value){
            if(self._curMenu != nil){
                self._curMenu?.backgroundColor = UIColor.clearColor()
            }
            self._curMenu = value
            for menu in  self.uiMenu.subviews{
                if(menu as? UIView !=  self._curMenu)
                {
                    (menu as! UIView).backgroundColor = UIColor.clearColor()
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
    var session:SessionForIphone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAlarmHelper.GetAlarmInstance().alarmcountdelegate = self
        self.imgAlarm.hidden = true
        
        self.svMain.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-46)
        
        self.session = SessionForIphone.GetSession()
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
        if(nil != self.bedUserCode && session!.CurPatientCode != "")
        {
            let firstVew = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
            firstVew.viewInit(self, bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            firstVew.HRdelegate = self
            
            self.curMenu = self.uiHR
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
    
    override func Clean(){
        if self.iHRMonitorView != nil{
        self.iHRMonitorView!.Clean()
        }
        if self.iRRMonitorView != nil{
        self.iRRMonitorView!.Clean()
        }
    }
    
    
    
    func ClickHR(){
        if(nil != self.bedUserCode && session!.CurPatientCode != "")
        {
            self.curMenu = self.uiHR
            iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as? IHRMonitor
            
            iHRMonitorView!.viewInit(self, bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            
            iHRMonitorView!.HRdelegate = self
            
            self.showBody(iHRMonitorView!,nibName: "IHRMonitor")
        }
        else
        {
            showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder), title: "")
        }
        
    }
 
    func ClickRR(){
        if(nil != self.bedUserCode && session!.CurPatientCode != "")
        {
            self.curMenu = self.uiRR
            iRRMonitorView = NSBundle.mainBundle().loadNibNamed("IRRMonitor", owner: self, options: nil).first as? IRRMonitor
            
            iRRMonitorView!.viewInit(self, bedUserCode: self.bedUserCode!, bedUserName: self.bedUserName!)
            iRRMonitorView!.RRdelegate = self
            
            self.showBody(iRRMonitorView!,nibName: "IRRMonitor")
        }
        else
        {
            showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder), title: "")
        }
    }
    
    func ClickSleep(){
        if(nil != self.bedUserCode && session!.CurPatientCode != "")
        {
            self.curMenu = self.uiSleepCare
            let sleepQualityMonitorView = NSBundle.mainBundle().loadNibNamed("ISleepQualityMonitor", owner: self, options: nil).first as! ISleepQualityMonitor
            
            sleepQualityMonitorView.viewInit(self,bedUserCode: self.bedUserCode!,bedUserName: self.bedUserName!)
            
            self.showBody(sleepQualityMonitorView,nibName: "ISleepQualityMonitor")
        }
        else
        {
            showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder), title: "")
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
            self.imgAlarm.hidden = false
        }
        else{
            self.lblAlarmCount.text = ""
            self.imgAlarm.hidden = true
        }
    }

}
