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
    
    //自定义处理----------------------
    
    
    func AutoLogin(){
        //初始加载记住密码的相关配置数据
        self.LoginName = GetValueFromPlist("loginusernamephone")
        self.Pwd = GetValueFromPlist("loginuserpwdphone")
        
        if (self.LoginName != "" && self.Pwd != ""){
            self.Login()
        }
        
    }
    
    //登录
    func Login() -> RACSignal{
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.Connect()
                if(!isLogin){
                    showDialogMsg("远程通讯服务器连接不上，请检查网络！")
                }
                else{
                    
                    if(self.LoginName == ""){
                        showDialogMsg("账户名不能为空！")
                        return
                    }
                    if(self.Pwd == ""){
                        showDialogMsg("密码不能为空！")
                        return
                    }
                    
                    var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                    var loginUser:ILoginUser = sleepCareForIPhoneBussinessManager.Login(self.LoginName, loginPassword: self.Pwd)
                    
                    SessionForIphone.SetSession(loginUser)
                    SetValueIntoPlist("loginusernamephone", self.LoginName)
                    SetValueIntoPlist("loginuserpwdphone", self.Pwd)
                    self.alarmHelper!.BeginWaringAttention()
                    
                    var session = SessionForIphone.GetSession()
                    session!.OldPwd = self.Pwd
                    
                    if(loginUser.UserType == LoginUserType.UnKnow){
                        if IViewControllerManager.GetInstance()!.IsExist("ISetUserType") {
                            IViewControllerManager.GetInstance()!.ShowViewController(nil, nibName: "ISetUserType", reload: false)
                        }
                        else{
                            let nextcontroller = ISetUserTypeController(nibName:"ISetUserType", bundle:nil)
                            IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "ISetUserType", reload: false)
                        }
                        // self.JumpPageForIpone(nextcontroller)
                        
                    }
                    else{
                        var session = SessionForIphone.GetSession()
                        session!.BedUserCodeList = Array<String>()
                        //获取当前关注的老人
                        self.iBedUserList = sleepCareForIPhoneBussinessManager.GetBedUsersByLoginName(loginUser.LoginName, mainCode: loginUser.MainCode)
                        
                        if(self.iBedUserList!.bedUserInfoList.count > 0){
                            if(loginUser.UserType == LoginUserType.UserSelf){
                                session!.BedUserCodeList!.append(self.iBedUserList!.bedUserInfoList[0].BedUserCode)
                                
                                let nextcontroller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:self.iBedUserList!.bedUserInfoList[0].BedUserCode,equipmentID:self.iBedUserList!.bedUserInfoList[0].EquipmentID,bedUserName:self.iBedUserList!.bedUserInfoList[0].BedUserName)
                                IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IMainFrame", reload: true)
                                
                                //self.JumpPageForIpone(nextcontroller)
                            }
                            else{
                                //跳转选择我的老人
                                 let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                                    controller.isGoLogin = true
                                    IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMyPatients", reload: true)
                                
                                //self.JumpPageForIpone(controller)
                            }
                        }
                        else{
                            //跳转选择我的老人
                            let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                            controller.isGoLogin = true
                            IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMyPatients", reload: true)
                            //self.JumpPageForIpone(controller)
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
        
        return RACSignal.empty()
        
    }
    
    func ShowAlarm() {
        let controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
        IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IAlarmView", reload: true)
    }
}