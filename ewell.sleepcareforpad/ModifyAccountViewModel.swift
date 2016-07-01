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
                self.Phone = SessionForSingle.GetSession()!.User == nil ? "" : SessionForSingle.GetSession()!.User!.LoginName
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
        try {
            ({
                //检查输入是否完全
                if(self.Phone == ""){
                    showDialogMsg(ShowMessage(MessageEnum.TelephoneNil))
                    return
                }
                if(self.OldPwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }

                if(self.NewPwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }
               
                if(self.ConfirmPwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }
                
                //两次密码是否相同
                if self.ConfirmPwd != self.NewPwd{
                    showDialogMsg(ShowMessage(MessageEnum.ConfirmPwdWrong))
                    return
                    
                }
                
              let result = SleepCareForSingle().ModifyAccount(self.Phone, oldPassword: self.OldPwd, newPassword: self.NewPwd)
                
                if result.Result{
                    showDialogMsg(ShowMessage(MessageEnum.ModifyAccountSuccess), "提示", buttonTitle: "确定", action: self.AfterModifySuccess)
                }
                else{
                 showDialogMsg(ShowMessage(MessageEnum.ModifyAccountFail),"提示" ,buttonTitle: "确定", action:nil)
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
    
    
    func AfterModifySuccess(isOtherButton: Bool){
    //修改本地文件信息 pwd
        if PLISTHELPER.LoginPwdSingle != ""{
            PLISTHELPER.LoginPwdSingle = self.NewPwd
            
       //  SetValueIntoPlist("loginpwdsingle", self.NewPwd)
        }
        //修改session信息 oldpwd
        SessionForSingle.GetSession()?.OldPwd = self.NewPwd
     
        //返回上一个页面
        if self.parentController != nil{
            self.parentController.navigationController?.popViewControllerAnimated(true)
        }
    }
}
