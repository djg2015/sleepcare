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
    @IBOutlet weak var imgLoginTitle: UIImageView!
    //属性变量定义
    var loginModel:LoginViewModel?
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
        //判断是否可以获取服务器信息
        let serverinfoflag = CheckServerInfo()
        if !serverinfoflag{
            GetServerInfoFail()
        }

        
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
        
        self.imgLoginTitle.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgLoginTitle .addGestureRecognizer(singleTap)
    }
    
    //点击查询类型
    func imageViewTouch(){
        self.presentViewController(ServerSettingController(nibName:"ServerSettingView", bundle:nil), animated: true, completion: nil)
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
