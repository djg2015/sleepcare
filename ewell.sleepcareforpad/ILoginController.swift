//
//  ILoginController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class ILoginController: IBaseViewController,THDateChoosedDelegate {
    var datapicker:THDate?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    @IBAction func TouchButton(sender: AnyObject) {
//        self.datapicker?.ShowDate()
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.Connect()
        if(!isLogin){
            showDialogMsg("远程通讯服务器连接不上！")
        }
        var scBLL:SleepCareForIPhoneBussiness = SleepCareForIPhoneBussiness()
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
    
    func ChoosedDate(choosedDate:String?){
        self.lblDate.text = choosedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datapicker = THDate(parentControl: self)
        datapicker?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
