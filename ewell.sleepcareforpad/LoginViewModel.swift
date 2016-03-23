//
//  LoginViewModel.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/23
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class LoginViewModel: BaseViewModel,ClearLoginInfoDelegate {
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
        
        self.loadInitData()
    }
    
    //点击登录按钮操作
    func Login() -> RACSignal{
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                    //设置当前session
                    let testBLL = SleepCareBussiness()
                    var user:User = testBLL.GetLoginInfo(self.UserName!, LoginPassword: self.UserPwd!)
                    Session.SetSession(user)
                   
                    //加载当前用户所有的科室信息
                    var roleList:RoleList = testBLL.ListRolesByParentCode(user.role!.RoleCode)
                    var session = Session.GetSession()
                    for(var i = 0;i < roleList.roleList.count; i++){
                        if(roleList.roleList[i].RoleType == "Floor"){
                            session.PartCodes.append(roleList.roleList[i])
                        }
                    }
                    //                    if(session.PartCodes.count > 0){
                    //                        var curPartCode = session.PartCodes[0].RoleCode
                    //                    }
                    //登录成功，记住用户名密码处理
                    if(self.IschechedBool){
                        SetValueIntoPlist("loginusername", self.UserName!)
                        SetValueIntoPlist("loginuserpwd", self.UserPwd!)
                    }
                        //不记住，则清空
                    else{
                        SetValueIntoPlist("loginusername","")
                        SetValueIntoPlist("loginuserpwd", "")
                     
                    }
                    LOGINFLAG = true
                    
                    //跳转主页面
                    session.CurPartCode = GetValueFromPlist("curPartcode","sleepcare.plist")
                        let controller = SleepcareMainController(nibName:"MainView", bundle:nil)
                    if !self.IschechedBool{
                    controller.clearlogininfoDelegate = self
                    }
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
        return RACSignal.empty()
    }
    
    //点击“记住密码”按钮操作
    func RemeberPwd() -> RACSignal{
        self.IschechedBool = !self.IschechedBool
        return RACSignal.empty()
        
    }
    
     //初始加载记住密码的相关配置数据
    func loadInitData(){
        self.UserName = GetValueFromPlist("loginusername","sleepcare.plist")
        self.UserPwd = GetValueFromPlist("loginuserpwd","sleepcare.plist")
        if(self.UserName == "" || self.UserPwd == ""){
            self.IschechedBool = false
        }
        else{
            self.IschechedBool = true
        }
    }
    
    func ClearLoginInfo(){
    self.UserName = ""
        self.UserPwd = ""
    }
}
