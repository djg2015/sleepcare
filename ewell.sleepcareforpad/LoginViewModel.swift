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
    
    //自定义方法
    func Login() -> RACSignal{
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
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
                    session.CurPartCode = GetValueFromPlist("curPartcode","sleepcare.plist")
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
        self.UserName = GetValueFromPlist("loginusername","sleepcare.plist")
        self.UserPwd = GetValueFromPlist("loginuserpwd","sleepcare.plist")
        if(self.UserName?.isEmpty == true){
            self.IschechedBool = false
        }
        else{
            self.IschechedBool = true
        }
    }
    
 
}
