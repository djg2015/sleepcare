//
//  ILoginController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class ILoginController: IBaseViewController {
    
  
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var btnLogin: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    var iloginViewModel:IloginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeColor[themeName]
        rac_settings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      
    }
    
    override func Clean() {
        self.iloginViewModel = nil
    }

    
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iloginViewModel = IloginViewModel()
       
        
        //属性绑定
        self.btnLogin!.rac_command = self.iloginViewModel?.loginCommand
        RACObserve(self.iloginViewModel, "LoginName") ~> RAC(self.txtLoginName, "text")
        RACObserve(self.iloginViewModel, "Pwd") ~> RAC(self.txtPwd, "text")
        self.txtLoginName.rac_textSignal() ~> RAC(self.iloginViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iloginViewModel, "Pwd")
        
        self.btnRegist!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.RegistConnect()
                if(!isconnect){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
             var nextcontroller = IRegistViewController(nibName: "IRegist", bundle: nil)
             IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IRegist",reload: true)
                }
        }
    }

    @IBAction func imageViewTouch(sender:AnyObject){
             var nextcontroller = IServerSettingController(nibName:"IServerSettingView", bundle:nil)
            IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IServerSettingView",reload: true)
        }
    
    
    @IBAction func ForgetPwd(sender:AnyObject){
    
    }
    
    
}
