//
//  IEmailViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IEmailViewModel: BaseViewModel {
    
    //------------属性定义------------
    var _emailAddress:String = ""
    // 邮件地址
    dynamic var EmailAddress:String{
        get
        {
            return self._emailAddress
        }
        set(value)
        {
            self._emailAddress=value
        }
    }
    
    var _bedUserCode:String = ""
    // 床位用户编码
    dynamic var BedUserCode:String{
        get
        {
            return self._bedUserCode
        }
        set(value)
        {
            self._bedUserCode=value
        }
    }

    var _sleepDate:String = ""
    // 分析日期
    dynamic var SleepDate:String{
        get
        {
            return self._sleepDate
        }
        set(value)
        {
            self._sleepDate=value
        }
    }
    
    var _parentController:IBaseViewController!
    // 控制器
    dynamic var ParentController:IBaseViewController!{
        get
        {
            return self._parentController
        }
        set(value)
        {
            self._parentController=value
        }
    }
    
    //界面处理命令
    var sendEmailCommand: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        sendEmailCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.SendEmail()
        }
    }
    
    // 发送邮件
    func SendEmail() -> RACSignal{
        try {
            ({

                var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                sleepCareForIPhoneBLL.SendEmail(self.BedUserCode, sleepDate: self.SleepDate, email: self.EmailAddress)
                //发送成功，则弹窗提示
                showDialogMsg(ShowMessage(MessageEnum.SendEmailSuccess), title: nil)
                //由父页面控制器关闭当前发送邮件子页面
                self.ParentController.dismissSemiModalView()

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