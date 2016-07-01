//
//  AccountSettingViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import UIKit

class AccountSettingViewModel: BaseViewModel {
    
    //构造函数
    override init(){
        super.init()

     
     
    }
    
    //根据开关设置alarmnoticeflag
   func SwitchAlarm(state:Bool){
    if state{
    AlarmNoticeFlag = true
        OpenNotice()
    }
    else{
     AlarmNoticeFlag = false
        CloseNotice()
    }
    
    PLISTHELPER.AlarmNotice = String(stringInterpolationSegment: AlarmNoticeFlag)
   //  SetValueIntoPlist("alarmnotice", String(stringInterpolationSegment: AlarmNoticeFlag))
    
    }
    

    
}
