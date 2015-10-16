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
    var UserPwd:String?{
        get
        {
            return self._userPwd
        }
        set(value)
        {
            self._userPwd=value
        }
    }
    
    var login: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        login = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
    }
    
    //自定义方法ß
    func Login() -> RACSignal{
        try {
            ({
                var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                var user_text:NSString = "test@192.168.0.19"
                var pass_text:NSString = "123"
                var server_text:NSString = "192.168.0.19"
                defaults.setObject(user_text,forKey:USERID)
                defaults.setObject(pass_text,forKey:PASS)
                defaults.setObject(server_text,forKey:SERVER)
                defaults.synchronize()
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.Connect()
                if(!isLogin){
                    showDialogMsg("远程通讯服务器连接不上！")
                }
                else{
                    let testBLL = SleepCareBussiness()
                    var user:User = testBLL.GetLoginInfo(self.UserName!, LoginPassword: self.UserPwd!)
                    Session.SetSession(user)
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
        
        return RACSignal.empty()
    }
    
    func ChoosedItem(downListModel:DownListModel){
        
    }
}
