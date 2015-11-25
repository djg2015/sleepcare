//
//  IMainFrameViewController.swift
//
//
//  Created by djg on 15/11/10.
//
//

import UIKit

class IMainFrameViewController: IBaseViewController {
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
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,bedUserCode:String?,equipmentID:String?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.bedUserCode = bedUserCode
        self.equipmentID = equipmentID
    }
    
    var bedUserCode:String?
    var equipmentID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置按钮事件
        self.btnHR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(nil != self.bedUserCode)
                {
                    self.curMenu = self.uiHR
                    let iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
                    
                    iHRMonitorView.viewInit(self, bedUserCode: self.bedUserCode!)
                    
                    self.showBody(iHRMonitorView)
                }
                else
                {
                    showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
                }
        }
        self.btnRR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(nil != self.bedUserCode)
                {
                    self.curMenu = self.uiRR
                    let iRRMonitorView = NSBundle.mainBundle().loadNibNamed("IRRMonitor", owner: self, options: nil).first as! IRRMonitor
                    
                    iRRMonitorView.viewInit(self, bedUserCode: self.bedUserCode!)
                    
                    self.showBody(iRRMonitorView)
                }
                else
                {
                    showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
                }
        }
        self.btnSleep!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(nil != self.bedUserCode)
                {
                    self.curMenu = self.uiSleepCare
                    let sleepQualityMonitorView = NSBundle.mainBundle().loadNibNamed("ISleepQualityMonitor", owner: self, options: nil).first as! ISleepQualityMonitor
                    
                    sleepQualityMonitorView.viewInit(self,bedUserCode: self.bedUserCode!)
                    
                    self.showBody(sleepQualityMonitorView)
                }
                else
                {
                    showDialogMsg("请先到【我】->【我的老人】下选择一位老人再查看！", title: "")
                }
        }
        self.btnMe!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.curMenu = self.uiMe
                let selfConfiguration = NSBundle.mainBundle().loadNibNamed("IMySelfConfiguration", owner: self, options: nil).first as! IMySelfConfiguration
                selfConfiguration.viewInit(self, bedUserCode: self.bedUserCode!,equipmentID: self.equipmentID!)
                self.showBody(selfConfiguration)
        }
        
        //设置主体界面
        if(nil != self.bedUserCode)
        {
            let firstVew = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
            firstVew.viewInit(self, bedUserCode: self.bedUserCode!)
            showBody(firstVew)
        }
        else
        {
            self.curMenu = self.uiMe
            let firstVew = NSBundle.mainBundle().loadNibNamed("IMySelfConfiguration", owner: self, options: nil).first as! IMySelfConfiguration
            firstVew.viewInit(self,bedUserCode: nil,equipmentID:self.equipmentID)
            showBody(firstVew)
        }
    }
    
    //显示菜单界面
    func showBody(jumpview:UIView){
        //        for(var i = 0 ; i < self.svMain.subviews.count; i++) {
        //            self.svMain.subviews[i].removeFromSuperview()
        //        }
        jumpview.frame = CGRectMake(0, 0, self.svMain.frame.width, self.svMain.frame.height)
        self.svMain.addSubview(jumpview)
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
