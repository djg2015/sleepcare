//
//  ILoginController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class ILoginController: IBaseViewController,LoginButtonDelegate {
    
  
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var btnLogin: BlueButtonForPhone!
   
    var iloginViewModel:IloginViewModel!

    override func viewWillAppear(animated: Bool) {
       
        tag = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.view.backgroundColor = themeColor[themeName]
        rac_settings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      
    }
    
  
    @IBAction func UnwindToLogin(unwindsegue:UIStoryboardSegue){
      //   self.navigationController?.popViewControllerAnimated(true)
        
    }
    
     //退出登录：清空本地plist文件内账户信息，清空当前session，如果是监护人账户则关闭报警，关闭xmpp。最后跳转登录页面
    @IBAction func UnwindLogout(unwindsegue:UIStoryboardSegue){
        var session = SessionForIphone.GetSession()
        if session != nil && session!.User!.UserType == LoginUserType.Monitor {
            
            CloseNotice()
            LOGINFLAG = false
            IAlarmHelper.GetAlarmInstance().CloseWaringAttention()
        }
        
        SetValueIntoPlist("loginusernamephone", "")
        SetValueIntoPlist("loginuserpwdphone", "")
        SetValueIntoPlist("xmppusernamephone", "")
      
        session = nil
        //关闭xmpp
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        xmppMsgManager?.Close()
        
    }
    
    @IBAction func UnwindCloseServerSetting(unwindsegue:UIStoryboardSegue){
        
        
    }
    
    func rac_settings(){
        self.iloginViewModel = IloginViewModel()
        self.iloginViewModel.controller = self
        self.iloginViewModel.loginbuttonDelegate = self
        self.iloginViewModel.LoadData()
        
        //属性绑定
        self.btnLogin!.rac_command = self.iloginViewModel?.loginCommand
        RACObserve(self.iloginViewModel, "LoginName") ~> RAC(self.txtLoginName, "text")
        RACObserve(self.iloginViewModel, "Pwd") ~> RAC(self.txtPwd, "text")
        self.txtLoginName.rac_textSignal() ~> RAC(self.iloginViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iloginViewModel, "Pwd")
        
         }
    
    func DisableLoginButton() {
        self.btnLogin.userInteractionEnabled = false
    }
    
    func EnableLoginButton() {
        self.btnLogin.userInteractionEnabled = true
    }
    
}
