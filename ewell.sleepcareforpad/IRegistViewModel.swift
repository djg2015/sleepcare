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
    var registCommand: RACCommand?
    
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
                let isLogin = xmppMsgManager!.Connect()
                if(!isLogin){
                    showDialogMsg("远程通讯服务器连接不上，返回后请重新连接！", "错误", buttonTitle: "确定", action: self.ConnectLost)
                }
                else{
                    var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                    var mainInfoList:IMainInfoList =  sleepCareForIPhoneBussinessManager.GetAllMainInfo()
                    for(var i=0;i<mainInfoList.mainInfoList.count;i++){
                        var item:PopDownListItem = PopDownListItem()
                        item.key = mainInfoList.mainInfoList[i].MainCode
                        item.value = mainInfoList.mainInfoList[i].MainName
                        self.MainBusinesses.append(item)
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
    
    //自定义处理----------------------
    //失去连接后处理
    func ConnectLost(isOtherButton: Bool){
        self.controllerForIphone?.dismissViewControllerAnimated(true, completion: nil)
    }
    //注册成功后处理
    func RegistSuccess(isOtherButton: Bool){
        self.controllerForIphone?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //注册
    func Regist() -> RACSignal{
        try {
            ({
                if(self.LoginName == ""){
                    showDialogMsg("账户名不能为空！")
                    return
                }
                if(self.Pwd == ""){
                    showDialogMsg("密码不能为空！")
                    return
                }
                if(self.Pwd != self.RePwd){
                    showDialogMsg("二次输入的密码不一样，请重新输入！")
                    self.RePwd = ""
                    return
                }
                if(self.MainCode == ""){
                    showDialogMsg("请选择所属养老院/医院！")
                    return
                }
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                sleepCareForIPhoneBussinessManager.Regist(self.LoginName, loginPassword: self.Pwd, mainCode: self.MainCode)
                 showDialogMsg("注册成功！", "提示", buttonTitle: "确定", action: self.RegistSuccess)
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