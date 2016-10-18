//
//  RootLoginViewController.swift
//
//
//  Created by Qinyuan Liu on 6/2/16.
//
//

import UIKit

class LoginViewController: IBaseViewController,LoginButtonDelegate{
    
    @IBOutlet weak var loginnameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rememberPwdBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    var iloginViewModel:IloginViewModel!
    
    @IBAction func UnwindLogout(unwindsegue:UIStoryboardSegue){
        
        CloseNotice()
        LOGINFLAG = false
        IAlarmHelper.GetAlarmInstance().CloseWaringAttention()
        PLISTHELPER.XmppUsernamePhone = ""
      
        
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        xmppMsgManager?.Close()
      
        
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
    
    func rac_settings(){
        self.iloginViewModel = IloginViewModel()
        self.iloginViewModel.parentcontroller = self
        self.iloginViewModel.loginbuttonDelegate = self
        
        
        self.rememberPwdBtn.setBackgroundImage(UIImage(named: "icon_square"), forState: UIControlState.Normal)
        self.rememberPwdBtn.setBackgroundImage(UIImage(named: "icon_square 1"), forState: UIControlState.Selected)
        self.rememberPwdBtn.selected = false
        
        //初始化页面数据
        self.iloginViewModel.LoadData()
        
        self.loginBtn.rac_command = self.iloginViewModel?.loginCommand
        self.rememberPwdBtn.rac_command = self.iloginViewModel?.rememberCommand
        
        RACObserve(self.iloginViewModel, "Loginname") ~> RAC(self.loginnameText, "text")
        RACObserve(self.iloginViewModel, "Pwd") ~> RAC(self.passwordText, "text")
        self.loginnameText.rac_textSignal() ~> RAC(self.iloginViewModel, "Telephone")
        self.passwordText.rac_textSignal() ~> RAC(self.iloginViewModel, "Pwd")
        RACObserve(self.iloginViewModel, "IsRememberpwd") ~> RAC(self.rememberPwdBtn, "selected")
        
        
    }
    
    func DisableLoginButton() {
        self.loginBtn.userInteractionEnabled = false
    }
    
    func EnableLoginButton() {
        self.loginBtn.userInteractionEnabled = true
    }
    
    
    
}
