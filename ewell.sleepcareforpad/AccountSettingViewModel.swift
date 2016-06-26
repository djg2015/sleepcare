//
//  AccountSettingViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import UIKit

class AccountSettingViewModel: BaseViewModel {
   
    var logoutCommand: RACCommand?
    
    //构造函数
    override init(){
        super.init()

       logoutCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Logout()
        }
        
     
    }
    
    
   func SwitchAlarm(state:Bool){
    
    
    }
    
    func Logout()-> RACSignal{
    
    
        return RACSignal.empty()
    }
    
}
