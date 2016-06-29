//
//  MessageHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/15/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

func ShowMessage(MessageTitle:MessageEnum)->String {
    
var messageDescription = GetValueFromReadOnlyPlist(String(MessageTitle.rawValue),"Message")
return messageDescription
}


enum MessageEnum:Int{
    case ConnectOpenfireFail = 1
    case ConnectFail
    case TelephoneNil
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
    case LoginNameExistBlank
    case PwdExistBlank
    case AccountDontExist
    case RegistAccountFail
    case ModifyAccountFail
    case NeedCheckProtol
    case UserTypeInfo
    case CheckAlarmInfo
    case LoginTypeNil
    case VerifyNumberNil
    case ConfirmPatientInfo
case NeedPhonenumber
    case QRCodeNil
    case NameNil
    case ConfirmNewPwdSuccess
    case ConfirmNewPwdFail
    case AddDeviceReminder
    case ConfirmPatientFail
    case BindFail
}
