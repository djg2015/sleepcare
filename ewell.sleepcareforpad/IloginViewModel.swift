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
    
    //构造函数
    override init(){
        super.init()
        
        loginCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
    }
    
    //自定义处理----------------------
    
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
                    if(loginUser.UserType == LoginUserType.UnKnow){
                        let controller = ISetUserTypeController(nibName:"ISetUserType", bundle:nil)
                        self.JumpPageForIpone(controller)
                        
                    }
                    else{
                        //获取当前关注的老人
                        var iBedUserList:IBedUserList = sleepCareForIPhoneBussinessManager.GetBedUsersByLoginName(loginUser.LoginName, mainCode: loginUser.MainCode)
                       
                        if(iBedUserList.bedUserInfoList.count > 0){
                            let controller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:iBedUserList.bedUserInfoList[0].BedUserCode)
                            self.JumpPageForIpone(controller)
                        }
                        else{
                            //跳转选择我的老人
                            let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                            self.JumpPageForIpone(controller)
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
}