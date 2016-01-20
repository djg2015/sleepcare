//
//  IFirstChoosePatientViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class ISetUserTypeViewModel: BaseViewModel {
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
    
    //设置账户类型
    func ModifyUserType(userType:String) -> RACSignal{
        try {
            ({
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var loginUser:SessionForIphone = SessionForIphone.GetSession()!
                sleepCareForIPhoneBussinessManager.SaveUserType(loginUser.User!.LoginName, userType: userType)
                loginUser.User?.UserType = userType
                let controller = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                controller.isGoLogin = true
                //设置成功后，跳转我的老人页面
                IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMyPatients", reload: true)
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