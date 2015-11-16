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
    var datapicker:THDate?
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var btnLogin: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    var iloginViewModel:IloginViewModel!
    @IBAction func TouchButton(sender: AnyObject) {
//        var dateFormatter:NSDateFormatter  = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        self.datapicker?.ShowDate(date: nil, returnformat:dateFormatter)
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.Connect()
        if(!isLogin){
            showDialogMsg("远程通讯服务器连接不上！")
        }
        var scBLL:SleepCareForIPhoneBussiness = SleepCareForIPhoneBussiness()
        self.presentViewController(IMainFrameViewController(nibName:"IMainFrame", bundle:nil), animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datapicker = THDate(parentControl: self)
        rac_settings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iloginViewModel = IloginViewModel()
        self.iloginViewModel.controllerForIphone = self
        self.btnLogin!.rac_command = self.iloginViewModel?.loginCommand
        self.txtLoginName.rac_textSignal() ~> RAC(self.iloginViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iloginViewModel, "Pwd")
        self.btnRegist!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.presentViewController(IRegistViewController(nibName: "IRegist", bundle: nil), animated: true, completion: nil)
        }
        // 给图片添加手势
        self.imgTitle.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgTitle .addGestureRecognizer(singleTap)
    }
    
    func imageViewTouch(){
        self.presentViewController(IServerSettingController(nibName:"IServerSettingView", bundle:nil), animated: true, completion: nil)
    }
}
