//
//  IloginViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//


import Foundation
class IloginViewModel: BaseViewModel,AutoLoginAfterRegistDelegate {
    //------------属性定义------------
    var _telephone:String = ""
    //登录用户名
    dynamic var Telephone:String{
        get
        {
            return self._telephone
        }
        set(value)
        {
            self._telephone=value
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
    
    var _isRememberpwd:Bool=true
    //记住密码:首次注册后登录默认true，本地有记录登录名密码时为true，其他情况为false
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
    var session:SessionForSingle?
    
    var controller:IBaseViewController?
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
      
        //注册后自动登录的代理
         AutologinDelegate = self
        
        
    }
    
    //读取本地文件中的登录名密码，非空则自动登录
    func LoadData(){
       let temptelephone = GetValueFromPlist("logintelephonesingle","sleepcare.plist")
        let temppwd = GetValueFromPlist("loginpwdsingle","sleepcare.plist")
        let tempisregist = GetValueFromPlist("isRegist","sleepcare.plist")
        
        if (temptelephone != "" && temppwd != ""){
            self.Telephone = temptelephone
            self.Pwd = temppwd
            
            //自动登录
            self.Login()
        }
            //已注册且本地没有用户名密码的纪录，“记住密码”不选中。等待用户输入后再点击登录
        else if tempisregist == "true"{
        self.IsRememberpwd = false

        }
        
    }
    

    
    
    //点击记住密码框，选中或取消选中
    func RememberPwd()-> RACSignal{
    
        self.IsRememberpwd = !self.IsRememberpwd
        
        return RACSignal.empty()
    }
    
    
    //代理：实现新注册成功后自动登录
    func AutoLoginAfterRegist() {
        self.Telephone = GetValueFromPlist("logintelephonesingle","sleepcare.plist")
        self.Pwd = GetValueFromPlist("loginpwdsingle","sleepcare.plist")
        //等待层？？？？
        self.Login()
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
                
                //获取服务器连接信息
                let openfireHelper = OpenFireServerInfoHelper(_backActionHandler:self.LoginAction)
                openfireHelper.CheckServerInfo()
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
    
    //登录业务处理，拉取服务器登录信息后回调此方法
    func LoginAction(){
        try {
            ({
                //检查输入是否合法
                if(self.Telephone == ""){
                    showDialogMsg(ShowMessage(MessageEnum.TelephoneNil))
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

                 //获取当前帐户下的用户信息
                var loginUser:LoginUser = SleepCareForSingle().SingleLogin(self.Telephone, loginPassword: self.Pwd)
                
               //给openfire username赋值，＝loginname@server address
                let xmppusernamephone = self.Telephone + "@" + GetValueFromPlist("xmppserver","sleepcare.plist")
                SetValueIntoPlist("xmppusernamephone", xmppusernamephone)
                      
                //开启session
                SessionForSingle.SetSession(loginUser)
                self.session = SessionForSingle.GetSession()
                
                if self.session != nil{
                    self.session!.OldPwd = self.Pwd
                }
                
                
                   //获取关注的设备列表
                var tempEquipmentList:EquipmentList =  SleepCareForSingle().GetEquipmentsByLoginName(self.Telephone)
                    self.session!.EquipmentList = tempEquipmentList.equipmentList
                
                var tempBedUserCodeList:Array<String> = Array<String>()
                for equipment in tempEquipmentList.equipmentList{
                tempBedUserCodeList.append(equipment.BedUserCode)
                }
                self.session!.BedUserCodeList = tempBedUserCodeList

                
               // 获取当前关注的设备；如果只有一个设备，默认选中
               let localcode = GetValueFromPlist("curPatientCode","sleepcare.plist")
                let localname = GetValueFromPlist("curPatientName","sleepcare.plist")
                if (localcode != "" && localname != ""){
                    self.session!.CurPatientCode = localcode
                    self.session!.CurPatientName = localname
                }
                else if tempEquipmentList.equipmentList.count == 1{
                    let tempcode = tempEquipmentList.equipmentList[0].BedUserCode
                     let tempname = tempEquipmentList.equipmentList[0].BedUserName
                    self.session!.CurPatientCode = tempcode
                    self.session!.CurPatientName = tempname
                    SetValueIntoPlist("curPatientCode", tempcode)
                    SetValueIntoPlist("curPatientName", tempname)
                    
                }
                
                
                //开启报警监测
                 LOGIN = true
                //开启报警，获取未处理的报警信息
                IAlarmHelper.GetAlarmInstance().BeginWaringAttention()

                 //开启远程通知（有token值的情况下）
                LOGINFLAG = true
                OpenNotice()
                 
                
                //若选中记住密码，则在本地纪录登录名，密码;否则清空
                if self.IsRememberpwd{
                    SetValueIntoPlist("logintelephonesingle", self.Telephone)
                    SetValueIntoPlist("loginpwdsingle", self.Pwd)
                }
                else{
                    SetValueIntoPlist("logintelephonesingle", "")
                    SetValueIntoPlist("loginpwdsingle", "")
                    self.Telephone = ""
                    self.Pwd = ""
                }

                
                 //跳转主页面
                    if self.controller != nil{
                   self.controller!.performSegueWithIdentifier("logintotabbar",sender:self.controller!)
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
    }
    
}

//防止重复点击登陆按钮
protocol LoginButtonDelegate{
    func DisableLoginButton()
    func EnableLoginButton()
}

