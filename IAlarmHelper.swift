//
//  IAlarmHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/17/15.
//  Copyright (c) 2015 djg. All rights reserved.
//
import Foundation
import ObjectiveC

class IAlarmHelper:NSObject, WaringAttentionDelegate {
    
    private static var alarmInstance: IAlarmHelper? = nil
    private var IsOpen:Bool = false
    var alarmdelegate:ShowAlarmDelegate!
    var alarmcountdelegate:GetAlarmCountDelegate!
    var alarmpicdelegate:SetAlarmPicDelegate!
    private var _wariningCaches:Array<AlarmInfo>!
    
    var _warningcouts:Int = 0
    dynamic var Warningcouts:Int{
        get
        {
            return self._warningcouts
        }
        set(value)
        {
            self._warningcouts = value
        }
    }
    var _codes:Array<String> = []
    dynamic var Codes:Array<String>{
        get
        {
            return self._codes
        }
        set(value)
        {
            self._codes = value
        }
    }
    
    var _warningList:Array<WarningInfo>=[]
    dynamic var WarningList:Array<WarningInfo>{
        get
        {
            return self._warningList
        }
        set(value)
        {
            self._warningList = value
        }
    }
    
    private override init(){
        
    }
    
    class func GetAlarmInstance()->IAlarmHelper{
        if self.alarmInstance == nil {
            self.alarmInstance = IAlarmHelper()
            //实时数据处理代理设置
            var xmppMsgManager = XmppMsgManager.GetInstance()
            xmppMsgManager?._waringAttentionDelegate = self.alarmInstance
            //开启警告信息
            self.alarmInstance!._wariningCaches = Array<AlarmInfo>()
        }
        return self.alarmInstance!
    }
    
    //取消对某个病人的关注，需要删除todolist(和warningList,codes)里对应的报警信息
    func DeletePatientAlarm(username:String){
        var currentCount = self.WarningList.count
        var willDeleteCodes = Array<String>()
        for(var i = 0;i<currentCount;i++){
            if self.WarningList[i].UserName == username{
                TodoList.sharedInstance.removeItemByID(self.WarningList[i].AlarmCode)
                willDeleteCodes.append(self.WarningList[i].AlarmCode)
            }
        }
        
        for(var i=0;i<willDeleteCodes.count;i++){
            for(var j=0;j<self.Codes.count;j++){
                if self.Codes[j] == willDeleteCodes[i]{
                    self.Codes.removeAtIndex(j)
                    break
                }
            }
        }
        
        for(var i=0;i<willDeleteCodes.count;i++){
            for(var j=0;j<self.WarningList.count;j++){
                if self.WarningList[j].AlarmCode == willDeleteCodes[i]{
                    self.WarningList.removeAtIndex(j)
                    break
                }
            }
        }
    }
    
    //开始报警提醒
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWariningAction", name: "TodoListShouldRefresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector:"ReConnect", name:"ReConnectInternetForPhone", object: nil)
        self.IsOpen = true
        
        //清除已经overdue的todoitem
        for item in TodoList.sharedInstance.allItems(){
            if item.isOverdue {
                TodoList.sharedInstance.removeItemByID(item.UUID)
            }
        }
        //加入未处理的报警信息到warningList／codes
        self.ReloadUndealedWarning()
    
        self.setAlarmTimer()
    }
    
    //显示报警信息
    func showWariningAction(){
        if self.alarmdelegate != nil {
            self.alarmdelegate.ShowAlarm()
        }
    }
    
    //获取报警信息数
    func GetAlarmCount()->Int{
    return self.Warningcouts
    }
    
    //加入未处理的报警信息到warningList／codes
    func ReloadUndealedWarning(){
        try {
            ({
                var session = SessionForIphone.GetSession()
                var curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
                var sleepCareBussinessManager = BusinessFactory<SleepCareBussinessManager>.GetBusinessInstance("SleepCareBussinessManager")
                var alarmList:AlarmList = sleepCareBussinessManager.GetAlarmByLoginUser(session!.User!.MainCode,loginName:session!.User!.LoginName,schemaCode:"",alarmTimeBegin:"2016-01-01",alarmTimeEnd:curDateString,transferTypeCode:"001",from:nil,max:nil)
                
                var alarmInfo:AlarmInfo
                var tempWarningList:Array<WarningInfo>=[]
                var tempCodes:Array<String> = []
                for(var i=0;i<alarmList.alarmInfoList.count;i++){
                    
                    alarmInfo = alarmList.alarmInfoList[i]
                    let warningInfo = WarningInfo(alarmCode: alarmInfo.AlarmCode,userName: alarmInfo.UserName,partName: alarmInfo.PartName,bedNumber:alarmInfo.BedNumber,alarmContent: alarmInfo.SchemaContent,alarmDate: alarmInfo.AlarmTime)
                    tempWarningList.append(warningInfo)
                    tempCodes.append(alarmInfo.AlarmCode)
                }
                self.WarningList = tempWarningList
                self.Codes = tempCodes
                self.Warningcouts = self.WarningList.count
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        if self.alarmcountdelegate != nil{
            self.alarmcountdelegate.GetAlarmCount(self.Warningcouts)
        }
        
        if self.alarmpicdelegate != nil{
            self.alarmpicdelegate.SetAlarmPic(self.Warningcouts)
        }
        
        //外部图标上的badge number
        TodoList.sharedInstance.SetBadgeNumber(self.Warningcouts)
    }
    
    
    func ReloadTodoList(){
        var items:[TodoItem] = TodoList.sharedInstance.allItems()
        for(var i = 0; i < items.count; i++){
        //查看该todoitem的code是否在报警信息codes里，不在，则从tidolist里删去这个item
            if !contains(self._codes, items[i].UUID) {
            TodoList.sharedInstance.removeItemByID(items[i].UUID)
            }
        }
    }

    //断网后，重新登录
    func ReConnect(){
        //弹窗提示是否重连网络
         SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.ConnectFail), subTitle:"提示", style: AlertStyle.None,buttonTitle:"退出登录",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"重新连接", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: self.ConnectAfterFail)
    }
    
    func ConnectAfterFail(isOtherButton: Bool){
        if isOtherButton{
            if SessionForIphone.GetSession()!.User!.UserType == LoginUserType.Monitor{
            IAlarmHelper.GetAlarmInstance().CloseWaringAttention()
            }
            SessionForIphone.ClearSession()
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            xmppMsgManager?.Close()
            
            let logincontroller = ILoginController(nibName:"ILogin", bundle:nil)
            IViewControllerManager.GetInstance()!.ShowViewController(logincontroller, nibName: "ILogin", reload: true)
        }
        else{
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            let isLogin = xmppMsgManager!.Connect()
            if(!isLogin){
                self.ReConnect()
            }
        }
    }

    //关闭报警提醒
    func CloseWaringAttention(){
        TodoList.sharedInstance.removeItemAll()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        self.Codes.removeAll()
        self.WarningList.removeAll()
    }
    
    //实时报警处理线程
    func setAlarmTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程处理报警信息，赋值给todolist
    func alarmTimerFireMethod(timer: NSTimer) {
        var tempWarningList = self.WarningList
        if(self._wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self._wariningCaches[0] as AlarmInfo
            //deadline为报警信息收到后,立刻
            let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
            let warningInfo = WarningInfo(alarmCode: alarmInfo.AlarmCode,userName: alarmInfo.UserName,partName: alarmInfo.PartName,bedNumber:alarmInfo.BedNumber,alarmContent: alarmInfo.SchemaContent,alarmDate: alarmInfo.AlarmTime)
            tempWarningList.append(warningInfo)
            
            //同意接收通知，才往todolist里加
            
            TodoList.sharedInstance.addItem(todoItem)
            
            
            self._wariningCaches.removeAtIndex(0)
            self.WarningList = tempWarningList
        }
        self.Warningcouts = self.WarningList.count
        
        if self.alarmpicdelegate != nil{
            self.alarmpicdelegate.SetAlarmPic(self.Warningcouts)
        }
        if self.alarmcountdelegate != nil{
            self.alarmcountdelegate.GetAlarmCount(self.Warningcouts)
        }
        
    }
    
    //获取原始报警数据warningcaches,通过bedcode过滤为需要的报警信息
    //检查是否已有alarmcode
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            var session = SessionForIphone.GetSession()
            if (session != nil && session!.BedUserCodeList.count > 0){
                var bedusercodeList = session!.BedUserCodeList
                if bedusercodeList.count > 0 {
                    for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                        for code in bedusercodeList {
                            if code == alarmList.alarmInfoList[i].UserCode{
                                //如果存在此code的报警信息，判断是否已处理
                                if self.IsCodeExist(alarmList.alarmInfoList[i].AlarmCode){
                                    //已处理，则从codes&warninglist&todolist里删除
                                    if alarmList.alarmInfoList[i].HandleFlag == "1" {
                                        var code = alarmList.alarmInfoList[i].AlarmCode
                                        var tempwarningList = self.WarningList
                                        var codes = self.Codes
                                        TodoList.sharedInstance.removeItemByID(code)
                                        
                                        for(var i = 0; i < tempwarningList.count; i++){
                                            if code == tempwarningList[i].AlarmCode{
                                                tempwarningList.removeAtIndex(i)
                                                self.WarningList = tempwarningList
                                                break
                                            }
                                        }
                                        for (var i = 0; i < codes.count; i++){
                                            if code == codes[i]{
                                                codes.removeAtIndex(i)
                                                self.Codes = codes
                                                break
                                            }
                                        }
                                        break
                                    }//删除已处理的报警
                                }
                                    
                                    //不存在，则加入到codes和warningCaches里
                                else{
                                    if alarmList.alarmInfoList[i].HandleFlag == "0"
                                    {
                                        self._codes.append(alarmList.alarmInfoList[i].AlarmCode)
                                        self._wariningCaches.append(alarmList.alarmInfoList[i])
                                        break
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }//func
    
    func IsCodeExist(code:String)->Bool{
        if !self._codes.isEmpty{
            for cc in self._codes{
                if code == cc{
                    return true
                }
            }
        }
        return false
    }
    
}
//设置”我的“页面报警信息图标
protocol SetAlarmPicDelegate{
    func SetAlarmPic(count:Int)
}

//点击报警推送消息，跳转alarm信息页面
protocol ShowAlarmDelegate{
    func ShowAlarm()
}
//在imainframe页面中设置警告数
protocol GetAlarmCountDelegate{
    func GetAlarmCount(count:Int)
}
class WarningInfo{
    var AlarmCode:String = ""
    var UserName:String = ""
    var PartName:String = ""
    var BedNumber:String = ""
    var AlarmContent:String = ""
    var AlarmDate:String = ""
    init(alarmCode:String, userName:String, partName:String,bedNumber:String, alarmContent:String,alarmDate:String){
        self.AlarmCode = alarmCode
        self.AlarmContent = alarmContent
        self.UserName = userName
        self.BedNumber = bedNumber
        self.PartName = partName
        self.AlarmDate = alarmDate
        
    }
}
