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
    //先从网站拉取服务器连接信息，不成功则从本地plist文件读取服务器连接信息。返回是否操作成功
    func CheckServerInfo()->Bool{
        var jsonflag = JasonHelper.GetJasonInstance().ConnectJason()
        
        if jsonflag{//若成功从url获取所有server有关的数据
            var flag = JasonHelper.GetJasonInstance().GetFromJsonData()
            if flag{
                //成功，将jason数据写入本地plist文件
                JasonHelper.GetJasonInstance().SetJsonDataToPlistFile()
                return true
            }
        }
        else{//无法从网站读取sever信息，则查看本地plist信息
            var plistflag = IsPlistDataEmpty()
            if !plistflag {   //不为空，则用本地plist文件尝试登录
                return true
            }
        }
        return false
    }
    
    func AutoLogin(){
        //加载记住密码的相关配置数据
        var temploginname = GetValueFromPlist("loginusernamephone","sleepcare.plist")
        var temppwd = GetValueFromPlist("loginuserpwdphone","sleepcare.plist")
        
        if (temploginname != "" && temppwd != ""){
            self.LoginName = temploginname
            self.Pwd = temppwd
            self.Login()
        }
    }
    
    //获取server数据失败，显示提示信息
    func GetServerInfoFail(){
        SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.ConnectOpenfireFail), subTitle:"提示", style: AlertStyle.None,buttonTitle:"关闭",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"重试连接", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: self.ConnectAgain)
    }
    func ConnectAgain(isOtherButton: Bool){
        if !isOtherButton{
           self.CheckServerInfo()
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
    
    
    func Login() -> RACSignal{
        let serverinfoFlag = self.CheckServerInfo()
        if !serverinfoFlag{
            self.GetServerInfoFail()
        }
        else{
            try {
                ({
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
                       //登录
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
    
    func ShowAlarm() {
        let controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
        IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IAlarmView", reload: true)
    }
}