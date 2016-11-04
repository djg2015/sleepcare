//
//  IloginViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//


import Foundation
class IloginViewModel: BaseViewModel {
    //------------属性定义------------
    var _loginname:String = ""
    //登录用户名
    dynamic var Loginname:String{
        get
        {
            return self._loginname
        }
        set(value)
        {
            self._loginname=value
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
    
    var _isRememberpwd:Bool=false
    //记住密码
    dynamic var IsRememberpwd:Bool{
        get
        {
            return self._isRememberpwd
        }
        set(value)
        {
            self._isRememberpwd=value
        }
    }
    
    
    //界面处理命令
    var loginCommand: RACCommand?
    var rememberCommand: RACCommand?
    //  var alarmHelper:IAlarmHelper?
    var session:SessionForIphone?
    
    var parentcontroller:IBaseViewController?
    var loginbuttonDelegate:LoginButtonDelegate!
    
    //构造函数
    override init(){
        super.init()
        
        
        
        loginCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
        
        rememberCommand = RACCommand(){
            (any:AnyObject!) -> RACSignal in
            return self.RememberPwd()
        }
        
        //显示alarm详细信息的代理
        //    self.alarmHelper = IAlarmHelper.GetAlarmInstance()
        
      
        
    }
    
    //读取本地文件中的登录名密码，非空则自动登录
    func LoadData(){
        let temploginname = PLISTHELPER.LoginUsername
        let temppwd = PLISTHELPER.LoginUserpwd
     let tempremember = PLISTHELPER.IsRemembered
        
        if(tempremember == "true"){
        self.IsRememberpwd = true
        }
        
        if (temploginname != "" && temppwd != ""){
            self.Loginname = temploginname
            self.Pwd = temppwd
            
            //自动登录
            self.Login()
        }
        
    }
    
    
    
    
    //点击记住密码框，选中或取消选中
    func RememberPwd()-> RACSignal{
        
        self.IsRememberpwd = !self.IsRememberpwd
        
        return RACSignal.empty()
    }
    
    
    
    
    /**
    登录操作
    */
    func Login()-> RACSignal{
        try {
            ({
                //点击登录按钮后，取消用户点击操作
                if self.loginbuttonDelegate != nil{
                    self.loginbuttonDelegate.DisableLoginButton()
                }
                
                
               // self.LoginAction()
                //检查输入是否合法
                if(self.Loginname == ""){
                    showDialogMsg(ShowMessage(MessageEnum.LoginnameNil))
                    //重新允许用户点击操作
                    if self.loginbuttonDelegate != nil{
                        self.loginbuttonDelegate.EnableLoginButton()
                    }
                    return
                }
                if(self.Pwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    //重新允许用户点击操作
                    if self.loginbuttonDelegate != nil{
                        self.loginbuttonDelegate.EnableLoginButton()
                    }
                    return
                }
                //给openfire username赋值，＝loginname@server address
                let xmppusernamephone = self.Loginname + "@" + PLISTHELPER.XmppServer
                PLISTHELPER.XmppUsernamePhone = xmppusernamephone
                
                
                //获取当前帐户下的用户信息
                var loginUser:ILoginUser = SleepCareForIPhoneBussiness().Login(self.Loginname, loginPassword: self.Pwd)
                
                //开启session
                SessionForIphone.SetSession(loginUser)
                self.session = SessionForIphone.GetSession()
                
                if self.session != nil{
                    self.session!.OldPwd = self.Pwd
                }
                

                
                
//                //关注的病人列表
//                var tempBedUserCodeList:Array<String> = Array<String>()
//                for equipment in tempEquipmentList.equipmentList{
//                    tempBedUserCodeList.append(equipment.BedUserCode)
//                }
//                self.session!.BedUserCodeList = tempBedUserCodeList
//                
//                
                
                //开启报警，获取未处理的报警信息
                IAlarmHelper.GetAlarmInstance().BeginWaringAttention()
                
                //开启远程通知（有token值的情况下）
                
                LOGINFLAG = true
                OpenNotice()
                
                //若选中记住密码，则在本地纪录登录名，密码;否则清空
                if self.IsRememberpwd{
                    PLISTHELPER.LoginUsername = self.Loginname
                    PLISTHELPER.LoginUserpwd = self.Pwd
                    PLISTHELPER.IsRemembered = "true"
                }
                else{
                    
                    PLISTHELPER.LoginUsername = ""
                    PLISTHELPER.LoginUserpwd  = ""
                    self.Loginname = ""
                    self.Pwd = ""
                     PLISTHELPER.IsRemembered = "false"
                }
                
                //跳转主页面
                if self.parentcontroller != nil{
                    self.parentcontroller!.performSegueWithIdentifier("patientlist",sender:self.parentcontroller!)
                }
                
                //登录业务完成后，重新允许用户点击登录按钮操作
                if self.loginbuttonDelegate != nil{
                    self.loginbuttonDelegate.EnableLoginButton()
                }
                
                
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                    if self.loginbuttonDelegate != nil{
                        self.loginbuttonDelegate.EnableLoginButton()
                    }
                },
                finally: {
                    
                }
            )}
        
        return RACSignal.empty()
    }
    
}

//防止重复点击登陆按钮
protocol LoginButtonDelegate{
    func DisableLoginButton()
    func EnableLoginButton()
}

