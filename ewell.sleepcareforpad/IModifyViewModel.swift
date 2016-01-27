//
//  IModifyViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/20/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
class IModifyViewModel:BaseViewModel {
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
    
    var _rePwd:String = ""
    //密码
    dynamic var RePwd:String{
        get
        {
            return self._rePwd
        }
        set(value)
        {
            self._rePwd=value
        }
    }
    
    var _mainCode:String = ""
    //所属养老院/医院
    dynamic var MainCode:String{
        get
        {
            return self._mainCode
        }
        set(value)
        {
            self._mainCode=value
        }
    }
    
    var _mainName:String = ""
    //所属养老院/医院名称
    dynamic var MainName:String{
        get
        {
            return self._mainName
        }
        set(value)
        {
            self._mainName=value
        }
    }
    
    var _mainBusinesses:Array<PopDownListItem> = Array<PopDownListItem>()
    //养老院/医院集合
    var MainBusinesses:Array<PopDownListItem>{
        get
        {
            return self._mainBusinesses
        }
        set(value)
        {
            self._mainBusinesses=value
        }
    }
    
    //界面处理命令
    var modifyCommand: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        modifyCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Modify()
        }
        
        try {
            ({
                
                    //获取当前所有养老院的名字
                    var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                    var mainInfoList:IMainInfoList =  sleepCareForIPhoneBussinessManager.GetAllMainInfo()
                    for(var i=0;i<mainInfoList.mainInfoList.count;i++){
                        var item:PopDownListItem = PopDownListItem()
                        item.key = mainInfoList.mainInfoList[i].MainCode
                        item.value = mainInfoList.mainInfoList[i].MainName
                        self.MainBusinesses.append(item)
                    }
                
                
                //初始化用户信息
                var session = SessionForIphone.GetSession()
                if(session != nil){
                    self.LoginName = session!.User!.LoginName
                    self.Pwd = session!.OldPwd!
                    self.RePwd = session!.OldPwd!
                    self.MainCode = session!.User!.MainCode
                    var mains = self.MainBusinesses.filter(
                        {$0.key == self.MainCode})
                    if(mains.count > 0){
                        let curMain:PopDownListItem = mains[0]
                        self.MainName = curMain.value!
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
    
    
    //修改用户信息
    func Modify() -> RACSignal{
        try {
            ({
                if(self.Pwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }
                if(self.Pwd != self.RePwd){
                    showDialogMsg(ShowMessage(MessageEnum.ConfirmPwdWrong))
                    self.RePwd = ""
                    return
                }
                if(self.MainCode == ""){
                    showDialogMsg(ShowMessage(MessageEnum.MainhouseNil))
                    return
                }
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var session = SessionForIphone.GetSession()
                
                //如果改变了养老院，则当前关注的老人bedusercode设置为nil，报警信息置空
                if session!.User!.MainCode != self.MainCode{
                    session!.CurPatientCode = ""
                }
                if session!.User!.UserType == LoginUserType.Monitor{
                IAlarmHelper.GetAlarmInstance().CloseWaringAttention()
                }
                
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.Connect()
                if(!isconnect){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                let result:ServerResult = sleepCareForIPhoneBussinessManager.ModifyLoginUser(self.LoginName, oldPassword: session!.OldPwd!, newPassword: self.Pwd, mainCode: self.MainCode)
                session?.OldPwd = self.Pwd
                session?.User?.MainCode = self.MainCode
               
                if result.Result{
                    showDialogMsg(ShowMessage(MessageEnum.ModifyAccountSuccess), "提示", buttonTitle: "确定", action: self.AfterModify)
                }
                else{
                    showDialogMsg(ShowMessage(MessageEnum.ModifyAccountFail),"提示" ,buttonTitle: "确定", action: self.AfterModify)
                }
                }
                },
                catch: { ex in
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        return RACSignal.empty()
    }
    
    //失去连接后处理
    func ConnectLost(isOtherButton: Bool){
        IViewControllerManager.GetInstance()!.CloseViewController()
        
    }
    
    func AfterModify(isOtherButton: Bool){
        IViewControllerManager.GetInstance()!.CloseViewController()
    }
    
}