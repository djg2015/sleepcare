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
            self._curMenu?.backgroundColor = UIColor(red: 0.85490196078431369, green: 0.85490196078431369, blue: 0.85490196078431369, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //设置按钮事件
        self.btnHR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.curMenu = self.uiHR
                 let iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
                self.showBody(iHRMonitorView)
        }
        self.btnRR!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.curMenu = self.uiRR
                let iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
                self.showBody(iHRMonitorView)
        }
        self.btnSleep!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.curMenu = self.uiSleepCare
                let iHRMonitorView = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
                self.showBody(iHRMonitorView)
        }
        self.btnMe!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.curMenu = self.uiMe
                let selfConfiguration = NSBundle.mainBundle().loadNibNamed("IMySelfConfiguration", owner: self, options: nil).first as! IMySelfConfiguration
                selfConfiguration.viewInit(self)
                self.showBody(selfConfiguration)
        }
        
        //设置主体界面
        self.curMenu = self.uiHR
        let firstVew = NSBundle.mainBundle().loadNibNamed("IHRMonitor", owner: self, options: nil).first as! IHRMonitor
        showBody(firstVew)
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
