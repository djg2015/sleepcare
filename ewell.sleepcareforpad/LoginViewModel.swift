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
              println(self.UserName)
        self.UserName = "aa1"
        println(self.UserPwd)
        
        return RACSignal.empty()
    }
    
    func ChoosedItem(downListModel:DownListModel){
        
    }
}
