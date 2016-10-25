//
//  SleepCareForIPhoneBussinessManager.swift
//  ewell.sleepcareforpad
//


import Foundation

protocol SleepCareForIPhoneBussinessManager{
    
    // 获取登录信息
    // 参数：loginName->登录账户
    //      loginPassword->登录密码
    func Login(loginName:String,loginPassword:String) -> ILoginUser
    
    
    // 根据医院/养老院编号获取楼层以及床位用户信息（排除已经关注的老人）S
    // 参数：mainCode->医院/养老院编号
    //      loginName->登录账户
    func GetPartInfoWithoutFollowBedUser(loginName:String,mainCode:String)->IMainInfo
    
    // 确认关注床位用户信息
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    //      mainCode->医院/养老院编号
    func FollowBedUser(loginName:String,bedUserCode:String,mainCode:String)-> ServerResult
    
    // 移除已关注的床位用户
    // 参数：loginName->登录账户
    //      bedUserCode->床位用户编码
    func RemoveFollowBedUser(loginName:String,bedUserCode:String)-> ServerResult
    
    // 根据当前登录用户获取所关注的床位用户
    // 参数：loginName->登录账户
    //      mainCode->医院/养老院编号
    func GetBedUsersByLoginName(loginName:String,mainCode:String)->IBedUserList
    

    
    // 根据床位用户编码和邮箱信息发送邮件(指定日期所在周的报表)
    // 参数：bedUserCode->床位用户编号
    //      sleepDate->分析日期
    //      email->要发送的邮箱地址
    func SendEmail(bedUserCode:String,sleepDate:String,email:String)->ServerResult
    
    // 修改登录用户密码和所属医院/养老院
    // 参数：loginName->登录账户
    //      oldPassword->旧的登录密码
    //      newPassword->新的登录密码
    //      mainCode->医院/养老院编码
    func ModifyLoginUser(loginName:String,oldPassword:String,newPassword:String,mainCode:String)->ServerResult
    
   
    //注册设备
    // 参数：token->设备token
    //      deviceType->设备类型
    func RegistDevice(token:String, deviceType:String)-> ServerResult
    
    
    //开启远程通知
    func OpenNotification(token:String, loginName:String)->ServerResult
    
    //关闭远程通知
    func CloseNotification(token:String, loginName:String)->ServerResult
    
    //12获取心率曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleHRTimeReport(bedUserCode:String,searchType:String)->HRRange
    
    
    
    //13获取呼吸曲线图
    //参数：bedUserCode
    //     searchType－>查询类型（1：近 24 小时 2：近一周  3：近一月）
    func GetSingleRRTimeReport(bedUserCode:String,searchType:String)->RRRange
    
    
    
    //14查询老人睡眠质量
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetSleepQualityofBedUser(bedUserCode:String,reportDate:String)->SleepQualityReport

    
   
    
    //根据当前登录用户、报警类型、报警时间段、报警处理状态等多条件获取关注老人的报警信息
    func GetAlarmByLoginUser(mainCode:String,loginName:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String,transferTypeCode:String,from:String?,max:String?)-> AlarmList
    
    //处理报警信息 "002"处理，“003”误报警
    func TransferAlarmMessage(alarmCode:String,transferType:String)
    
    //16查询指定日期所在周的老人睡眠报表,周报表
    //参数：bedUserCode
    //     reportDate ->查询时间yyyy-MM-dd
    func GetWeekSleepofBedUser(bedUserCode:String,reportDate:String)->WeekSleep
}