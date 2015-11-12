//
//  ILoginController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class ILoginController: IBaseViewController {
    var datapicker:THDate?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var btnLogin: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    
    @IBAction func TouchButton(sender: AnyObject) {
//        self.datapicker?.ShowDate()
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.Connect()
        if(!isLogin){
            showDialogMsg("远程通讯服务器连接不上！")
        }
        var scBLL:SleepCareForIPhoneBussiness = SleepCareForIPhoneBussiness()
         self.presentViewController(IMainFrameViewController(nibName:"IMainFrame", bundle:nil), animated: true, completion: nil)
//        var loginUser:ILoginUser = scBLL.Login("李四", loginPassword: "111111")
//        var v = scBLL.Regist("李四", loginPassword: "123456", mainCode: "0001")
//        var v1 = scBLL.SaveUserType("李四", userType: "2")
//        var v2 = scBLL.GetPartInfoByMainCode("0001")
//        var v3 = scBLL.FollowBedUser("李四", bedUserCode: "00000001,00000002,00000003", mainCode: "0001")
//        var v4 = scBLL.RemoveFollowBedUser("李四", bedUserCode: "00000001")
//        var v5 = scBLL.GetBedUsersByLoginName("李四", mainCode: "0001")
//        var v6 = scBLL.GetHRTimeReport("00000001")
//        var v7 = scBLL.GetRRTimeReport("00000001")
//        var v8 = scBLL.GetSleepQualityByUser("00000001", reportDate: "2015-11-10")
//        var v9 = scBLL.SendEmail("00000001", sleepDate: "2015-09-23", email: "zhaoyin@ewell.cc")
//        var v10 = scBLL.ModifyLoginUser("李四", oldPassword: "123456", newPassword: "111111", mainCode: "0001")
//        var v11 = scBLL.GetEquipmentInfo("012700000037")
//        var v12 = scBLL.GetAllMainInfo()
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
        
        self.btnRegist!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
             self.presentViewController(IRegistViewController(nibName: "IRegist", bundle: nil), animated: true, completion: nil)   
        }
    }
}
