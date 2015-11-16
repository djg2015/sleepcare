//
//  IFirstChoosePatientViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class IFirstChoosePatientViewModel: BaseViewModel {
    //界面处理命令
    var userselfCommand: RACCommand?
    var monitorCommand: RACCommand?
    
    
    //构造函数
    override init(){
        super.init()
        
        userselfCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.ModifyUserType(LoginUserType.UserSelf)
        }
        
        monitorCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.ModifyUserType(LoginUserType.Monitor)
        }
    }
    
    //自定义处理----------------------
    
    //登录
    func ModifyUserType(userType:String) -> RACSignal{
        try {
            ({
                
                
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var loginUser:SessionForIphone = SessionForIphone.GetSession()
                sleepCareForIPhoneBussinessManager.SaveUserType(loginUser.User!.LoginName, userType: userType)
                let controller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil)
                self.JumpPageForIpone(controller)
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