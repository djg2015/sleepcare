//
//  MofifyAccountViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import UIKit

class ModifyAccountViewModel: BaseViewModel {
    //------------属性定义------------
    var _phone:String = ""
    //登录用户名（手机号）
    dynamic var Phone:String{
        get
        {
            return self._phone
        }
        set(value)
        {
            self._phone=value
        }
    }
    
    var _oldpwd:String = ""
    //旧密码
    dynamic var OldPwd:String{
        get
        {
            return self._oldpwd
        }
        set(value)
        {
            self._oldpwd=value
        }
    }
    
    var _newpwd:String = ""
    //新密码
    dynamic var NewPwd:String{
        get
        {
            return self._newpwd
        }
        set(value)
        {
            self._newpwd=value
        }
    }
    
    var _confirmPwd:String = ""
    //确认新密码
    dynamic var ConfirmPwd:String{
        get
        {
            return self._confirmPwd
        }
        set(value)
        {
            self._confirmPwd=value
        }
    }

    
    var parentController:ModifyAccountController!
     var ConfirmCommand: RACCommand?
    
    
    
    //构造函数
    override init(){
        super.init()
        
        ConfirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Confirm()
        }
        
        
        try {
            ({
              //获取手机号
              
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}

    }
    
    
    func Confirm()-> RACSignal{
    
    return RACSignal.empty()
    }
}
