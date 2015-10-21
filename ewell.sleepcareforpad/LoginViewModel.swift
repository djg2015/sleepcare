//
//  LoginViewModel.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/23
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {
    //属性定义
    var _userName:String?
    dynamic var UserName:String?{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName=value
        }
    }
    
    var _userPwd:String?
    dynamic var UserPwd:String?{
        get
        {
            return self._userPwd
        }
        set(value)
        {
            self._userPwd=value
        }
    }
    
    var _isCheched:UIImage?
    dynamic var IsCheched:UIImage?{
        get
        {
            return self._isCheched
        }
        set(value)
        {
            self._isCheched=value
        }
    }
    
    var _ischechedBool:Bool = false
    var IschechedBool:Bool{
        get
        {
            return self._ischechedBool
        }
        set(value)
        {
            self._ischechedBool = value
            if(self._ischechedBool){
                self.IsCheched = UIImage(named: "checkboxchoosed.png")
            }
            else{
                self.IsCheched = UIImage(named: "checkbox.png")
            }
        }
    }
    
    var login: RACCommand?
    var remeberChecked: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        login = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
        
        remeberChecked = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.RemeberPwd()
        }
    }
    
    //自定义方法ß
    func Login() -> RACSignal{
        try {
            ({                
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.Connect()
                if(!isLogin){
                    showDialogMsg("远程通讯服务器连接不上！")
                }
                else{
                    let testBLL = SleepCareBussiness()
                    var user:User = testBLL.GetLoginInfo(self.UserName!, LoginPassword: self.UserPwd!)
                    Session.SetSession(user)
                    var session = Session.GetSession()
                    session.CurPartCode = "00001"
                    let controller = SleepcareMainController(nibName:"MainView", bundle:nil)
                    self.JumpPage(controller)
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        //记住用户名密码处理
        if(self.IschechedBool){
            SetValueIntoPlist("loginusername", self.UserName!)
            SetValueIntoPlist("loginuserpwd", self.UserPwd!)
        }
        return RACSignal.empty()
    }
    
    func RemeberPwd() -> RACSignal{
        self.IschechedBool = !self.IschechedBool
        return RACSignal.empty()

    }
    
    func loadInitData(){
        
        //初始加载记住密码的相关配置数据
        self.UserName = GetValueFromPlist("loginusername")
        self.UserPwd = GetValueFromPlist("loginuserpwd")
        if(self.UserName?.isEmpty == true){
            self.IschechedBool = false
        }
        else{
            self.IschechedBool = true
        }
    }
    
    func ChoosedItem(downListModel:DownListModel){
        
    }
}
