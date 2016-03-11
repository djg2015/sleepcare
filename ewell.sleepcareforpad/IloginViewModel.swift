//
//  IloginViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//


import Foundation
class IloginViewModel: BaseViewModel,ShowAlarmDelegate {
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
    
    //构造函数
    override init(){
        super.init()
        
        loginCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
        //显示alarm详细信息的代理
        self.alarmHelper = IAlarmHelper.GetAlarmInstance()
        self.alarmHelper!.alarmdelegate = self
        
        
    }
    
    
       
    //自动登录
    func AutoLogin(){
        //加载记住密码的相关配置数据
        var temploginname = GetValueFromPlist("loginusernamephone","sleepcare.plist")
        var temppwd = GetValueFromPlist("loginuserpwdphone","sleepcare.plist")
        //密码和用户名都不为空，则执行登录操作
        if (temploginname != "" && temppwd != ""){
            self.LoginName = temploginname
            self.Pwd = temppwd
            self.Login()
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
    func Login() -> RACSignal{
        let serverinfoFlag = CheckServerInfo()
        if !serverinfoFlag{
            GetServerInfoFail()
        }
        else{
            try {
                ({
                    //检查输入是否合法
                    if(self.LoginName == ""){
                        showDialogMsg(ShowMessage(MessageEnum.LoginnameNil))
                        return
                    }
                    if self.IsBlankExist(self.LoginName){
                        showDialogMsg(ShowMessage(MessageEnum.LoginNameExistBlank))
                        return
                    }
                    
                    if(self.Pwd == ""){
                        showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                        return
                    }
                    if self.IsBlankExist(self.Pwd){
                        showDialogMsg(ShowMessage(MessageEnum.PwdExistBlank))
                        return
                    }
                    

                    //给openfire username赋值，＝loginname@server address
                    let xmppusernamephone = self.LoginName + "@" + GetValueFromPlist("xmppserver","sleepcare.plist")
                    SetValueIntoPlist("xmppusernamephone", xmppusernamephone)
                    
                    var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                    let isLogin = xmppMsgManager!.Connect()
                    if(!isLogin){
                        SetValueIntoPlist("xmppusernamephone", "")
                        showDialogMsg(ShowMessage(MessageEnum.AccountDontExist))
                    }
                    else{
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
//
//                        var Token = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as? String
//                        if Token != nil{
//                        
//                        }
                       
                        
                        //跳转选择用户类型
                        if(loginUser.UserType == LoginUserType.UnKnow){
                                let nextcontroller = ISetUserTypeController(nibName:"ISetUserType", bundle:nil)
                                IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "ISetUserType", reload: true)
                        }
                        else{
                            //获取当前关注的老人
                             if self.session != nil{
                            self.session!.BedUserCodeList = Array<String>()
                            }
                            self.iBedUserList = sleepCareForIPhoneBussinessManager.GetBedUsersByLoginName(loginUser.LoginName, mainCode: loginUser.MainCode)
                            
                            //如果是监护人，开启报警监测
                            var _usertype = self.session!.User!.UserType
                            if _usertype == LoginUserType.Monitor{
                            self.alarmHelper!.BeginWaringAttention()
                            LOGINFLAG = true
                             //开启通知
                             OpenNotice()
                            }
                            
                            if(self.iBedUserList!.bedUserInfoList.count > 0){
                                //当前为使用者类型，直接跳转主页面
                                if(loginUser.UserType == LoginUserType.UserSelf){
                                    self.session!.BedUserCodeList.append(self.iBedUserList!.bedUserInfoList[0].BedUserCode)
                                    
                                    let nextcontroller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:self.iBedUserList!.bedUserInfoList[0].BedUserCode,equipmentID:self.iBedUserList!.bedUserInfoList[0].EquipmentID,bedUserName:self.iBedUserList!.bedUserInfoList[0].BedUserName)
                                    IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IMainFrame", reload: true)
                                }
                                else{
                                    //当前为监护人类型，则跳转我的老人页面，选择一个老人进行关注
                                    let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                                    controller.isGoLogin = true
                                    IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMyPatients", reload: true)
                                }
                            }
                            else{
                                //当前没有关注过老人，则跳转选择我的老人，提示添加老人
                                let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                                controller.isGoLogin = true
                                IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMyPatients", reload: true)
                            }
                        }
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
        return RACSignal.empty()
    }
    

    //跳转报警信息页面
    func ShowAlarm() {
        let controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
        IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IAlarmView", reload: true)
    }
}