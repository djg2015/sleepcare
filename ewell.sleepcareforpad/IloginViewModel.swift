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
    
    
    //界面处理命令
    var loginCommand: RACCommand?
    var iBedUserList:IBedUserList?
    var alarmHelper:IAlarmHelper?
    var session:SessionForIphone?
    
    var controller:IBaseViewController?
    var loginbuttonDelegate:LoginButtonDelegate!
    
    //构造函数
    override init(){
        super.init()
        
        
        
        loginCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
        //显示alarm详细信息的代理
        self.alarmHelper = IAlarmHelper.GetAlarmInstance()
        //  self.alarmHelper!.alarmdelegate = self
        
        
    }
    
    func LoadData(){
        var temploginname = GetValueFromPlist("loginusernamephone","sleepcare.plist")
        var temppwd = GetValueFromPlist("loginuserpwdphone","sleepcare.plist")
        if (temploginname != "" && temppwd != ""){
            self.LoginName = temploginname
            self.Pwd = temppwd
            
            //  self.Login()
        }
        
    }
    
    
    
    //检查输入是否含空格,有空格返回true
    func IsBlankExist(input:String)->Bool{
        for char in input{
            if char == " " || char == " "{
                return true
            }
        }
        return false
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
                if(self.LoginName == ""){
                    showDialogMsg(ShowMessage(MessageEnum.LoginnameNil))
                    //重新允许用户点击操作
                    if self.loginbuttonDelegate != nil{
                        self.loginbuttonDelegate.EnableLoginButton()
                    }
                    return
                }
                if self.IsBlankExist(self.LoginName){
                    showDialogMsg(ShowMessage(MessageEnum.LoginNameExistBlank))
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
                if self.IsBlankExist(self.Pwd){
                    showDialogMsg(ShowMessage(MessageEnum.PwdExistBlank))
                    //重新允许用户点击操作
                    if self.loginbuttonDelegate != nil{
                        self.loginbuttonDelegate.EnableLoginButton()
                    }
                    
                    return
                }
                
                
                //给openfire username赋值，＝loginname@server address
                let xmppusernamephone = self.LoginName + "@" + GetValueFromPlist("xmppserver","sleepcare.plist")
                SetValueIntoPlist("xmppusernamephone", xmppusernamephone)
            
                //获取当前帐户下的用户信息
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var loginUser:ILoginUser = sleepCareForIPhoneBussinessManager.Login(self.LoginName, loginPassword: self.Pwd)
                
               
                //开启session，纪录登录名，密码
                SessionForIphone.SetSession(loginUser)
                self.session = SessionForIphone.GetSession()
                SetValueIntoPlist("loginusernamephone", self.LoginName)
                SetValueIntoPlist("loginuserpwdphone", self.Pwd)
                if self.session != nil{
                    self.session!.OldPwd = self.Pwd
                }
                
                if(loginUser.UserType == LoginUserType.UnKnow){
                    
                }
                else{
                    //获取当前关注的老人列表
                    if self.session != nil{
                        self.session!.BedUserCodeList = Array<String>()
                    }
                    self.iBedUserList = sleepCareForIPhoneBussinessManager.GetBedUsersByLoginName(loginUser.LoginName, mainCode: loginUser.MainCode)
                    
                    //设置session bedusercodeList
                    self.session!.BedUserCodeList = Array<String>()
                    if self.iBedUserList!.bedUserInfoList.count > 0{
                        for bedUser in self.iBedUserList!.bedUserInfoList{
                            self.session!.BedUserCodeList.append(bedUser.BedUserCode)
                        }
                        
                    }
                    
                    
                    //设置curBedUser。如果关注的老人列表不为空,若是使用者，则默认选择此老人
                    //                                  若是监护人，从plist文件中读取curBedUser相关信息,并验证是否在关注列表中
                    //               如果关注列表为空，则清空plist文件中的curBedUser信息
                    let _usertype = self.session!.User!.UserType
                    if self.iBedUserList!.bedUserInfoList.count > 0 {
                        if _usertype == LoginUserType.UserSelf{
                            //使用者：默认选择列表中的病人
                            let curPatient = self.iBedUserList!.bedUserInfoList[0]
                            SetValueIntoPlist("curPatientCode", curPatient.BedUserCode)
                            SetValueIntoPlist("curPatientName", curPatient.BedUserName)
                            self.session?.CurPatientCode = curPatient.BedUserCode
                            self.session?.CurPatientName = curPatient.BedUserName
                        }
                            
                        else{
                            let tempCurBedUserCode = GetValueFromPlist("curPatientCode","sleepcare.plist")
                            //  self.session?.CurPatientName = GetValueFromPlist("curPatientName","sleepcare.plist")
                            //监护人：验证之前关注的老人是否存在于beduserinfolist
                            let tempPatient = self.iBedUserList!.bedUserInfoList.filter(
                                {$0.BedUserCode == tempCurBedUserCode})
                            if tempPatient.count > 0{
                                SetValueIntoPlist("curPatientCode", tempPatient[0].BedUserCode)
                                SetValueIntoPlist("curPatientName", tempPatient[0].BedUserName)
                                self.session?.CurPatientCode = tempPatient[0].BedUserCode
                                self.session?.CurPatientName = tempPatient[0].BedUserName
                            }
                            else{
                                SetValueIntoPlist("curPatientCode", "")
                                SetValueIntoPlist("curPatientName", "")
                                self.session?.CurPatientCode = ""
                                self.session?.CurPatientName = ""
                            }
                        }
                    }
                    else{
                        self.session?.CurPatientCode = ""
                        self.session?.CurPatientName = ""
                        SetValueIntoPlist("curPatientCode", "")
                        SetValueIntoPlist("curPatientName", "")
                    }
                    
                    
                    //如果是监护人，开启报警监测
                    LOGIN = true
                    if _usertype == LoginUserType.Monitor{
                        self.alarmHelper!.BeginWaringAttention()
                        LOGINFLAG = true
                        //开启通知
                        OpenNotice()
                    }
                    
                    //跳转主页面
                    if self.controller != nil{
                        self.controller!.performSegueWithIdentifier("tabbarController",sender:self.controller!)
                    }
                    
                    
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


protocol LoginButtonDelegate{
    func DisableLoginButton()
    func EnableLoginButton()
}

