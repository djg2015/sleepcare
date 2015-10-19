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
    @IBOutlet weak var btnRemeber: UIButton!
    
    //属性变量定义
    var loginModel:LoginViewModel?
    var xmppMsgManager:XmppMsgManager?=nil
    var popDownList:PopDownList?
    
    var RemberImage:UIImage?{
        didSet{
          self.btnRemeber.setImage(self.RemberImage, forState: UIControlState.Normal)
            
        }
    }

    
    //-----------界面事件定义----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rac_settings()
        var chart:PNLineChart
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.loginModel = LoginViewModel()
        self.loginModel!.controller = self
        //属性绑定
        self.txtloginName.rac_textSignal() ~> RAC(self.loginModel, "UserName")
        self.txtloginPwd.rac_textSignal() ~> RAC(self.loginModel, "UserPwd")
        RACObserve(self.loginModel, "UserName") ~> RAC(self.txtloginName, "text")
        RACObserve(self.loginModel, "UserPwd") ~> RAC(self.txtloginPwd, "text")
        RACObserve(self.loginModel, "IsCheched") ~> RAC(self, "RemberImage")
        self.loginModel?.loadInitData()
        //事件绑定
        self.btnSubmit.rac_command = loginModel!.login
        self.btnRemeber.rac_command = loginModel!.remeberChecked
        //        self.btnReset!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
        //            .subscribeNext {
        //                _ in
        ////                var dataSource = Array<DownListModel>()
        ////                var item = DownListModel()
        ////                item.key = "1"
        ////                item.value = "科室"
        ////                dataSource.append(item)
        ////                item = DownListModel()
        ////                item.key = "2"
        ////                item.value = "病房"
        ////                dataSource.append(item)
        ////                self.popDownList = PopDownList(datasource: dataSource, dismissHandler: self.ChoosedItem)
        ////                self.popDownList!.Show(300, height: 200, uiElement: self.btnReset)
        //
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
