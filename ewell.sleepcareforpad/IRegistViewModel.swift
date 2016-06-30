//
//  IRegistViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class IRegistViewModel:BaseViewModel {
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
    
    
    var _qrCode:String = ""
    //设备编码
    dynamic var QRCode:String{
        get
        {
            return self._qrCode
        }
        set(value)
        {
            self._qrCode=value
        }
    }
    
    
    var _isChecked:Bool = false
    //是否勾选了同意服务协议
    dynamic var IsChecked:Bool{
        get
        {
            return self._isChecked
        }
        set(value)
        {
            self._isChecked=value
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
    var RegistCommand: RACCommand?
    var SendVerifyCommand: RACCommand?
    var AgreeProtocolCommand: RACCommand?
    var parentController:RootRegistViewController!
    var sendVerifyTimerDelegate:SendVerifyTimerDelegate!
    
    //构造函数
    override init(){
        super.init()
        
        RegistCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Regist()
        }
        
        
        SendVerifyCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.SendVerify()
        }
        
        AgreeProtocolCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.AgreeProtocol()
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
    
    
    //服务协议框选中，跳转"服务协议"页面
    func AgreeProtocol() -> RACSignal{
        self.IsChecked = !self.IsChecked
        
        if self.IsChecked{
            if self.parentController != nil{
                self.parentController.performSegueWithIdentifier("showprotocol", sender: self.parentController)
            }
        }
        
        
        return RACSignal.empty()
        
    }
    
    
    //注册账户
    func Regist() -> RACSignal{
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
                //设备二维码不为空
                if(self.QRCode == ""){
                    showDialogMsg(ShowMessage(MessageEnum.QRCodeNil))
                    return
                }
                
                //已经勾选了服务协议，尝试注册账户
                if self.IsChecked{
                    
                    let result:ServerResult = SleepCareForSingle().SingleRegist(self.Phone, loginPassword: self.Pwd, vcCode:self.VerifyNumber, equipmentID:self.QRCode)
                    if result.Result{
                        showDialogMsg(ShowMessage(MessageEnum.ConfirmPatientInfo), "提示", buttonTitle: "确定", action: self.AfterRegistSuccess)
                    }
                        
                    else{
                        showDialogMsg(ShowMessage(MessageEnum.RegistAccountFail),"提示" ,buttonTitle: "确定", action:nil)
                        
                    }
                }
                else{
                    showDialogMsg(ShowMessage(MessageEnum.NeedCheckProtol))
                    return
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
    
    
    //点击注册成功,弹窗后的操作:登录信息写入本地，跳转“老人信息”页面
    func AfterRegistSuccess(isOtherButton: Bool){
        SetValueIntoPlist("logintelephonesingle", self.Phone)
        SetValueIntoPlist("loginpwdsingle", self.Pwd)
        SetValueIntoPlist("isRegist", "true")
        
        
        if self.parentController != nil{
            self.parentController.performSegueWithIdentifier("patientinfo", sender: self.parentController)
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
                    let result =  SleepCareForSingle().GetVerificationCode(self.Phone)
                   
                    //开启60s定时器
                    if self.sendVerifyTimerDelegate != nil{
                        self.sendVerifyTimerDelegate.SendVerifyTimer()
                    }
                 
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                    if self.parentController != nil{
                        self.parentController.CloseVerifyTimer2()
                    }

                },
                finally: {
                    
                }
            )}
        
        return RACSignal.empty()
        
    }
    
    
    func VerifyQR(id:String)->Bool{
        var result:Bool = false
        try {
            ({
                result =  SleepCareForSingle().CheckEquipmentID(id).Result
                
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        return result
    }
}


protocol SendVerifyTimerDelegate{
    
    func SendVerifyTimer()
}



