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
    var _loginType:String = ""
    //账户类型
    dynamic var LoginType:String{
        get
        {
            return self._loginType
        }
        set(value)
        {
            self._loginType=value
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
    
    //账户类型集合
    var _typeBusinesses:Array<PopDownListItem> = Array<PopDownListItem>()
    var TypeBusinesses:Array<PopDownListItem>{
        get
        {
            return self._typeBusinesses
        }
        set(value)
        {
            self._typeBusinesses=value
        }
    }
 
    
    //界面处理命令
    var registCommand: RACCommand?
    var IsChecked:Bool = false
    
    //构造函数
    override init(){
        super.init()
        
        registCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Regist()
        }
        
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                //用默认账户pad密码123连接openfire
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                    //获取当前所有养老院的名字
                    var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                    var mainInfoList:IMainInfoList =  sleepCareForIPhoneBussinessManager.GetAllMainInfo()
                    for(var i=0;i<mainInfoList.mainInfoList.count;i++){
                        var item:PopDownListItem = PopDownListItem()
                        item.key = mainInfoList.mainInfoList[i].MainCode
                        item.value = mainInfoList.mainInfoList[i].MainName
                        self.MainBusinesses.append(item)
                    }
                    
                    //设置账户类型：使用者，监护人
                    var item:PopDownListItem = PopDownListItem()
                    item.key = LoginUserType.UserSelf
                    item.value = "使用者"
                    self.TypeBusinesses.append(item)
                    item.key = LoginUserType.Monitor
                    item.value = "监护人"
                    self.TypeBusinesses.append(item)
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
    
    
   
    
    //注册账户
    func Regist() -> RACSignal{
        try {
            ({
                //检查输入是否完全
                if(self.LoginName == ""){
                    showDialogMsg(ShowMessage(MessageEnum.LoginnameNil))
                    return
                }
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
                
                //已经勾选了服务协议，尝试注册账户
                if self.IsChecked{
                    var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                    let isconnect = xmppMsgManager!.RegistConnect()
                    if(!isconnect){
                        showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                    }
                    else{
                        var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                        let result:ServerResult =  sleepCareForIPhoneBussinessManager.Regist(self.LoginName, loginPassword: self.Pwd, mainCode: self.MainCode)
                        //注册账户成功后，继续设置账户类型
                        if result.Result{
                        let result2:ServerResult = sleepCareForIPhoneBussinessManager.SaveUserType(self.LoginName, userType: self.LoginType)
                            if result2.Result{
                                showDialogMsg(ShowMessage(MessageEnum.RegistAccountSuccess), "提示", buttonTitle: "确定", action: self.AfterRegist)
                            }
                        }
                        else{
                            showDialogMsg(ShowMessage(MessageEnum.RegistAccountFail),"提示" ,buttonTitle: "确定", action: self.AfterRegist)
                        }
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
    
    
    //点击注册,弹窗后的操作
    func AfterRegist(isOtherButton: Bool){
        //关闭默认openfire账户的连接
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        xmppMsgManager!.Close()
    }
    
    
}

