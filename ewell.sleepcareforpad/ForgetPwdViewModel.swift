//
//  ForgetPwdViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/24/16.
//
//

import UIKit

class ForgetPwdViewModel: BaseViewModel {
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
    
    var _confirmPwd:String = ""
    //确认密码
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
    
    
    var _verifyNumber:String = ""
    //验证码
    dynamic var VerifyNumber:String{
        get
        {
            return self._verifyNumber
        }
        set(value)
        {
            self._verifyNumber=value
        }
    }
    
    var _clickSendVerify:Bool = false
    //是否点击了“获取验证码”（60s后重置false）
    dynamic var ClickSendVerify:Bool{
        get
        {
            return self._clickSendVerify
        }
        set(value)
        {
            self._clickSendVerify=value
        }
    }
    
   
    
    
    //界面处理命令
    var ConfirmCommand: RACCommand?
    var SendVerifyCommand: RACCommand?
      var parentController:ForgetPwdController!
     var sendVerifyTimerDelegate:SendVerifyTimer2Delegate!
    
    
    //构造函数
    override init(){
        super.init()
        
        ConfirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Confirm()
        }
        
        
        SendVerifyCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.SendVerify()
        }
        
      
        
        
        
        try {
            ({
                //获取openfire连接信息
                GetOpenfireInfo()
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                //用默认账户连接openfire
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectOpenfireFail))
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
    }
    

    
    
    //修改新密码
    func Confirm() -> RACSignal{
        try {
            ({
                //检查输入是否完全
                if(self.Phone == ""){
                    showDialogMsg(ShowMessage(MessageEnum.TelephoneNil))
                    return
                }
                if(self.VerifyNumber == ""){
                    showDialogMsg(ShowMessage(MessageEnum.VerifyNumberNil))
                    return
                }
                if(self.Pwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }
                if IsBlankExist(self.Pwd){
                  showDialogMsg(ShowMessage(MessageEnum.PwdExistBlank))
                        return
                }

                if(self.ConfirmPwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }
                if IsBlankExist(self.ConfirmPwd){
                    showDialogMsg(ShowMessage(MessageEnum.PwdExistBlank))
                    return
                }
                //两次密码是否相同
                if self.ConfirmPwd != self.Pwd{
                    showDialogMsg(ShowMessage(MessageEnum.ConfirmPwdWrong))
                    return
                    
                }
              
                
                
                    let result:ServerResult = SleepCareForSingle().ConfirmNewPassword(self.Phone,vcCode:self.VerifyNumber,newPassword:self.Pwd)
                    if result.Result{
                        showDialogMsg(ShowMessage(MessageEnum.ConfirmNewPwdSuccess), "提示", buttonTitle: "确定", action: self.AfterConfirmSuccess)
                    }
                        
                    else{
                        showDialogMsg(ShowMessage(MessageEnum.ConfirmNewPwdFail),"提示" ,buttonTitle: "确定", action:nil)
                        
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
    
    

    func AfterConfirmSuccess(isOtherButton: Bool){
       
        SetValueIntoPlist("loginpwdsingle", self.Pwd)
        
        if self.parentController != nil{
            self.parentController.navigationController?.popViewControllerAnimated(true)
        }
    }

    
    //根据手机号 发送验证码到手机,错误抛异常
    func SendVerify() -> RACSignal{
        try {
            ({
                if self.Phone == ""{
                    showDialogMsg(ShowMessage(MessageEnum.NeedPhonenumber))
                }
                else{
                    self.ClickSendVerify = true
                    //开启60s定时器
                    if self.sendVerifyTimerDelegate != nil{
                        self.sendVerifyTimerDelegate.SendVerifyTimer2()
                    }
                    
                    SleepCareForSingle().GetVerificationCode(self.Phone)
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                    if self.parentController != nil{
                        self.parentController.CloseVerifyTimer()
                    }

                },
                finally: {
                    
                }
            )}
        
        return RACSignal.empty()
        
    }

}

protocol SendVerifyTimer2Delegate{
    
    func SendVerifyTimer2()
}
