//
//  MessageHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/15/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

func ShowMessage(MessageTitle:Int)->String {
var messageDescription = GetValueFromPlist(String(MessageTitle),"MessageEnum.plist")
return messageDescription
}


enum MessageEnum:Int{
    case ConnectOpenfireFail = 1
    case ConnectFail
    case LoginnameNil
    case PwdNil
    case ConfirmPwdWrong
    case MainhouseNil
    case ModifyAccountSuccess
    case RegistAccountSuccess
    case SendEmailSuccess
    case DeletePatientReminder
    case ChoosePatientReminder
    case ServerSettingSuccess
    case ChooseUsertypeReminder
    case GetDataOvertime
    case NeedUpdate
    case DontNeedUpdate

}
