//
//  LoginController.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class LoginController: BaseViewController {
    
    //控件定义
    @IBOutlet weak var txtloginName: UITextField!
    @IBOutlet weak var txtloginPwd: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    //属性变量定义
    var loginModel = LoginViewModel()
    var xmppMsgManager:XmppMsgManager?=nil
    //-----------界面事件定义----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rac_settings()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------自定义方法处理---------------    
    func rac_settings(){
       
        //属性绑定
         self.txtloginName.rac_textSignal() ~> RAC(self.loginModel, "UserName")
         RACObserve(self.loginModel, "UserName") ~> RAC(self.txtloginName, "text")
        
        //事件绑定
        self.btnSubmit.rac_command = loginModel.login
        self.btnReset!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                //RACObserve(self.loginModel, "UserName") ~> RAC(self.txtloginPwd, "text")
                self.loginModel.UserName="2222"
                
//                var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//                var user_text:NSString = "test@192.168.0.19"
//                var pass_text:NSString = "123"
//                var server_text:NSString = "192.168.0.19"
//                defaults.setObject(user_text,forKey:USERID)
//                defaults.setObject(pass_text,forKey:PASS)
//                defaults.setObject(server_text,forKey:SERVER)
//                defaults.synchronize()
//                self.xmppMsgManager = XmppMsgManager.GetInstance(XMPPStreamTimeoutNone)
//                let isLogin = self.xmppMsgManager?.Connect()
                self.presentViewController(SleepcareMainController(nibName:"MainView", bundle:nil), animated: true, completion: nil)
                
        }
        
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
