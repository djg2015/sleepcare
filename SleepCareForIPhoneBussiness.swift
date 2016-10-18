//
//  SleepCareForIPhoneBussiness.swift
//  ewell.sleepcareforpad
//


import Foundation

class SleepCareForIPhoneBussiness: SleepCareForIPhoneBussinessManager {
    
    // 获取登录信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    func Login(loginName:String,loginPassword:String) -> ILoginUser{
        
        var subject = MessageSubject(opera: "Login", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("loginPassword", value: loginPassword)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ILoginUser
    }
    
    
  
    
    
       
    // 根据医院/养老院编号获取楼层以及床位用户信息
    // 参数：mainCode->医院/养老院编号
    func GetPartInfoByMainCode(mainCode:String)->IMainInfo{
        
        var subject = MessageSubject(opera: "GetPartInfoByMainCode", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IMainInfo
    }
    
    //根据医院/养老院编号获取楼层以及床位用户信息（排除已经关注的老人）
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetPartInfoWithoutFollowBedUser(loginName:String,mainCode:String)->IMainInfo{
        
        var subject = MessageSubject(opera: "GetPartInfoWithoutFollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post,timeOut:20)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IMainInfo
    }
    
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "FollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 移除已关注的床位用户
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    func RemoveFollowBedUser(loginName:String,bedUserCode:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "RemoveFollowBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 根据当前登录用户获取所关注的床位用户
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetBedUsersByLoginName(loginName:String,mainCode:String)->IBedUserList{
        
        var subject = MessageSubject(opera: "GetBedUsersByLoginName", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IBedUserList
    }
    
    // 根据床位用户编码获取心率曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetHRTimeReport(bedUserCode:String)->IHRRange{
        
        var subject = MessageSubject(opera: "GetHRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IHRRange
    }
    
    // 根据床位用户编码获取呼吸曲线图(往前推12个小时)
    // 参数：bedUserCode->床位用户编号
    func GetRRTimeReport(bedUserCode:String)->IRRRange{
        
        var subject = MessageSubject(opera: "GetRRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IRRRange
    }
    
    // 根据床位用户编码分析日期查询用户的睡眠质量
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetSleepQualityByUser(bedUserCode:String,reportDate:String)->ISleepQualityReport{
        
        var subject = MessageSubject(opera: "GetSleepQualityByUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ISleepQualityReport
    }
    
    // 根据床位用户编码分析日期查询用户的周报表
    // 参数：bedUserCode->床位用户编号
    //      reportDate->报告日期
    func GetWeekReportByUser(bedUserCode:String,reportDate:String)->IWeekReport{
        
        var subject = MessageSubject(opera: "GetWeekReportByUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! IWeekReport
    }
    
    
    // 根据床位用户编码和邮箱信息发送邮件(指定日期所在周的报表)
    // 参数：bedUserCode->床位用户编号
    //      sleepDate->分析日期
    //      email->要发送的邮箱地址
    func SendEmail(bedUserCode:String,sleepDate:String,email:String)->ServerResult{
        
        var subject = MessageSubject(opera: "SendEmail", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("sleepDate", value: sleepDate)
        post.AddKeyValue("email", value: email)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    // 修改登录用户密码和所属医院/养老院
    // 参数：loginName->登录账户
    //      oldPassword->旧的登录密码
    //      newPassword->新的登录密码
    //      mainCode->医院/养老院编码
    func ModifyLoginUser(loginName:String,oldPassword:String,newPassword:String,mainCode:String)->ServerResult{
        
        var subject = MessageSubject(opera: "ModifyLoginUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("loginName", value: loginName)
        post.AddKeyValue("oldPassword", value: oldPassword)
        post.AddKeyValue("newPassword", value: newPassword)
        post.AddKeyValue("mainCode", value: mainCode)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
 
    //注册设备
    // 参数：token->设备token
    //      deviceType->设备类型
    func RegistDevice(token:String, deviceType:String)-> ServerResult{
        
        var subject = MessageSubject(opera: "RegistDevice", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("deviceType", value: deviceType)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    //开启远程通知
    func OpenNotification(token:String, loginName:String)->ServerResult{
        
        var subject = MessageSubject(opera: "OpenNotification", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("loginName", value: loginName)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    //关闭远程通知
    func CloseNotification(token:String, loginName:String)->ServerResult{
        var subject = MessageSubject(opera: "CloseNotification", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("token", value: token)
        post.AddKeyValue("loginName", value: loginName)
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
        
    }
    
    
    //12获取心率曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleHRTimeReport(bedUserCode:String,searchType:String)->HRRange{
        
        var subject = MessageSubject(opera: "GetSingleHRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("searchType", value: searchType)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! HRRange
        
    }
    
    //13获取呼吸曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleRRTimeReport(bedUserCode:String,searchType:String)->RRRange
    {
        var subject = MessageSubject(opera: "GetSingleRRTimeReport", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("searchType", value: searchType)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! RRRange
        
    }
    
    
    //14查询老人睡眠质量
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetSleepQualityofBedUser(bedUserCode:String,reportDate:String)->SleepQualityReport{
        var subject = MessageSubject(opera: "GetSleepQualityofBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! SleepQualityReport
    }
    
    
    // 处理报警信息
    // 参数：alarmCode-> 报警编号
    //      transferType-> 处理类型 002:处理 003:误警报
    func HandleAlarm(alarmCode:String,transferType:String)->ServerResult
    {
        var subject = MessageSubject(opera: "TransferAlarmMessage")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("alarmCode", value: alarmCode)
        post.AddKeyValue("transferType", value: transferType)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }
    
    //根据当前登录用户、报警类型、报警时间段、报警处理状态等多条件获取关注老人的报警信息
    //   mainCode 医院/养老院编号
    //   loginName 登录账户
    //   schemaCode 报警类型
    //   alarmTimeBegin 报警时间起始时间 //年-月-日 格式
    //   alarmTimeEnd 报警时间结束时间//年-月-日 格式
    //   transferTypeCode 报警处理类型
    //   from 开始记录序号(nil表示查询全部)
    //   max  返回最大记录数量(nil表示查询全部)
    func GetAlarmByLoginUser(mainCode:String,loginName:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String,transferTypeCode:String,from:String?,max:String?)-> AlarmList{
        
        var subject = MessageSubject(opera: "GetAlarmByLoginUser")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("mainCode", value:mainCode )
        post.AddKeyValue("loginName", value:loginName )
        post.AddKeyValue("schemaCode", value:schemaCode )
        post.AddKeyValue("alarmTimeBegin", value: alarmTimeBegin)
        post.AddKeyValue("alarmTimeEnd", value: alarmTimeEnd)
        post.AddKeyValue("transferTypeCode", value:transferTypeCode )
        if(from != nil)
        {
            post.AddKeyValue("from", value: from!)
        }
        if(max != nil)
        {
            post.AddKeyValue("max", value: max!)
        }
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
            
        }
        return message as! AlarmList
    }
    
    //删除报警信息（已读）
    //alarmCodes 报警编号(多个以半角逗号隔开)
    //loginName 登录用户名
    func DeleteAlarmMessage(alarmCodes:String,loginName:String)->ServerResult{
        
        var subject = MessageSubject(opera: "DeleteAlarmMessage",bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("alarmCodes", value: alarmCodes)
        post.AddKeyValue("loginName", value: loginName)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! ServerResult
    }

    //16查询指定日期所在周的老人睡眠报表
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetWeekSleepofBedUser(bedUserCode:String,reportDate:String)->WeekSleep
    {
        var subject = MessageSubject(opera: "GetWeekSleepofBedUser", bizcode: "sleepcareforiphone")
        var post = EMProperties(messageSubject: subject)
        post.AddKeyValue("bedUserCode", value: bedUserCode)
        post.AddKeyValue("reportDate", value: reportDate)
        
        var xmpp = XmppMsgManager.GetInstance(timeout: xmpp_Timeout)
        var message = xmpp?.SendData(post)
        if(message is EMServiceException)
        {
            throw((message as! EMServiceException).code, (message as! EMServiceException).message)
        }
        return message as! WeekSleep
        
    }

    
}