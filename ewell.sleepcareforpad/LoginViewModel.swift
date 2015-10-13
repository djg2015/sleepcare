//
//  LoginViewModel.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/23
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
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
            return self._userName
        }
        set(value)
        {
            self._userName=value
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
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var user_text:NSString = "test@192.168.0.19"
        var pass_text:NSString = "123"
        var server_text:NSString = "192.168.0.19"
        defaults.setObject(user_text,forKey:USERID)
        defaults.setObject(pass_text,forKey:PASS)
        defaults.setObject(server_text,forKey:SERVER)
        defaults.synchronize()
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.Connect()
        let testBLL = SleepCareBussiness()
        let user1 = testBLL.GetPartInfoByPartCode("00001", searchType: "", searchContent: "", from: 1, max: 30)

        var user:User = testBLL.GetLoginInfo("yuanzhang", LoginPassword: "123456")
        Session.SetSession(user)
        
        return RACSignal.empty()
    }
    
    func ChoosedItem(downListModel:DownListModel){
        
    }
}
