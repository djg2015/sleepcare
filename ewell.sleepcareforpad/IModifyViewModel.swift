//
//  IModifyViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/20/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class IModifyViewModel:BaseViewModel {
    //------------属性定义------------
    var _loginName:String = ""
    //登录用户名
    dynamic var LoginName:String{
        get
        {
            return self._loginName
        }
        set(value)
        {
            self._loginName=value
        }
    }
    
    var _pwd:String = ""
    //密码
    dynamic var Pwd:String{
        get
        {
            return self._pwd
        }
        set(value)
        {
            self._pwd=value
        }
    }
    
    var _rePwd:String = ""
    //密码
    dynamic var RePwd:String{
        get
        {
            return self._rePwd
        }
        set(value)
        {
            self._rePwd=value
        }
    }
    
  
    
   
    //界面处理命令
    var modifyCommand: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        modifyCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Modify()
        }
        
       self.LoginName = SessionForIphone.GetSession()!.User!.LoginName
        
    }
    
    
    //修改用户信息
    func Modify() -> RACSignal{
        try {
            ({
               
                    //检查输入是否合法
                    if(self.Pwd == ""){
                        showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                        return
                    }
                    if(self.Pwd != self.RePwd){
                        showDialogMsg(ShowMessage(MessageEnum.ConfirmPwdWrong))
                        self.RePwd = ""
                        return
                    }
                
                   
                    var session = SessionForIphone.GetSession()
                    
                                       //修改账户到服务器端
                    let result:ServerResult = SleepCareForIPhoneBussiness().ModifyLoginUser(self.LoginName, oldPassword: session!.OldPwd!, newPassword: self.Pwd, mainCode: session!.User!.MainCode)
                
                
                    //提示修改账户是否成功
                    if result.Result{
                         session?.OldPwd = self.Pwd
                        
                        showDialogMsg(ShowMessage(MessageEnum.ModifyAccountSuccess), "提示", buttonTitle: "确定", action: self.AfterModify)
                    }
                    else{
                        showDialogMsg(ShowMessage(MessageEnum.ModifyAccountFail),"提示" ,buttonTitle: "确定", action: nil)
                    }
                
                },
                catch: { ex in
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        return RACSignal.empty()
    }
    
   
    //关闭当前页面
    func AfterModify(isOtherButton: Bool){
        self.controller?.navigationController?.popViewControllerAnimated(true)
    }
    
}