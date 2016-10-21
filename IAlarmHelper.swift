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
    private var _wariningCaches:Array<AlarmInfo>!

    var AlarmAlert = SweetAlert(contentHeight: 300)
    var equipmentid = ""
    
    //-------------------类字段--------------------------
    //未读的未处理报警总数
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
    
    //所有未读的未处理报警code
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
    
    //未处理报警列表
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
    
    //------------------------------------开始／结束报警器-------------------------------------
    //开始报警提醒
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWariningAction", name: "OpenAlarmView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        self.IsOpen = true
        
        //清除已经overdue的todoitem
        for item in TodoList.sharedInstance.allItems(){
            if item.isOverdue {
                TodoList.sharedInstance.removeItemByID(item.UUID)
            }
        }
        //初始化，加入未处理的报警信息到warningList／codes/unreadcodes
        self.ReloadUndealedWarning()
        
        //初始化定时器
        self.setAlarmTimer()
        
    }
    
    //关闭报警提醒
    func CloseWaringAttention(){
        TodoList.sharedInstance.removeItemAll()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        self.Codes.removeAll()
        
        self.WarningList.removeAll()
    }
    
    
    //-----------------------------刷新报警列表，todolist-------------------------------
    //加入未处理的报警信息到warningList／codes/unreadcodes
    func ReloadUndealedWarning(){
        try {
            ({
                var session = SessionForIphone.GetSession()
               var curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
              
                var alarmList:AlarmList = SleepCareForIPhoneBussiness().GetAlarmByLoginUser(session!.User!.MainCode,loginName:session!.User!.LoginName,schemaCode:"",alarmTimeBegin:"2016-01-01",alarmTimeEnd:curDateString,transferTypeCode:"001",from:nil,max:nil)
                
                var alarmInfo:AlarmInfo
                var tempWarningList:Array<WarningInfo>=[]
                var tempCodes:Array<String> = []
                for(var i=0;i<alarmList.alarmInfoList.count;i++){
                    
                    alarmInfo = alarmList.alarmInfoList[i]
                   
                    
                    let warningInfo = WarningInfo(alarmCode: alarmInfo.AlarmCode,userName: alarmInfo.UserName,userCode: alarmInfo.UserCode,bedNumber:alarmInfo.BedNumber,alarmContent: alarmInfo.SchemaContent,alarmTime: alarmInfo.AlarmTime,equipmentID:self.equipmentid,sex:alarmInfo.UserSex,alarmType:alarmInfo.SchemaCode)
                    
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
        
        
//        if self.alarmpicdelegate != nil{
//            self.alarmpicdelegate.SetAlarmPic(self.Warningcouts)
//        }
       
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
    
  
    
    //--------------------------------------定时器--------------------------------------------
//    //若存在未读信息，则弹窗提示是否查看
//    func setTimer(){
//        var  realtimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "RunAlarmThread", userInfo: nil, repeats:true);
//        realtimer.fire()
//    }
//    
//    func RunAlarmThread(){
//        
//        var unread = self.WarningList.filter({$0.IsRead == false})
//        if unread.count>0{
//            self.showWariningNotification()
//        }
//        
//    }
    
    //实时报警处理线程
    func setAlarmTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程处理报警信息，赋值给todolist
    func alarmTimerFireMethod(timer: NSTimer) {
        if(self._wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self._wariningCaches[0] as AlarmInfo
            //deadline为报警信息收到后,立刻
            let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
           let warningInfo = WarningInfo(alarmCode: alarmInfo.AlarmCode,userName: alarmInfo.UserName,userCode: alarmInfo.UserCode,bedNumber:alarmInfo.BedNumber,alarmContent: alarmInfo.SchemaContent,alarmTime: alarmInfo.AlarmTime,equipmentID:equipmentid,sex:alarmInfo.UserSex,alarmType:alarmInfo.SchemaCode)
            
            self.WarningList.append(warningInfo)
             self._codes.append(alarmInfo.AlarmCode)
            
            //同意接收通知，才往todolist里加
            TodoList.sharedInstance.addItem(todoItem)
            self._wariningCaches.removeAtIndex(0)
            
        }
        self.Warningcouts = self.WarningList.count
        
//        if self.alarmpicdelegate != nil{
//            self.alarmpicdelegate.SetAlarmPic(self.Warningcouts)
//        }
        
       
    }
    
    
    
    //---------------取消对某个病人的关注，需要删除todolist(和warningList,codes)里对应的报警信息------------------
    func DeletePatientAlarm(username:String){
        var currentCount = self.WarningList.count
        var willDeleteCodes = Array<String>()
        
        //需要删除的报警code放在willDeleteCodes中
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
    
    
    //--------------------------------报警弹窗和页面跳转---------------------------------
    //点击远程消息通知后的操作：若已登录且当前不是报警页面，则直接跳转报警信息页面
    func showWariningAction(){
        if (LOGINFLAG && currentController != nil){
            let nextController = ShowAlarmViewController(nibName:"AlarmView", bundle:nil)
            nextController.parentController = currentController
            currentController.presentViewController(nextController, animated: true, completion: nil)
        }
    }
    
    
   
    
    //----------------------------------报警delegate-------------------------------------
    //获取原始报警数据warningcaches,通过bedcode过滤为需要的报警信息
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
                                    
                                    //不存在此code信息，则加入到warningCaches里
                                else{
                                    if alarmList.alarmInfoList[i].HandleFlag == "0"
                                    {
                                       
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

//------------------------------协议：设置页面上报警数字和图标---------------------------
////设置”我的“页面报警信息图标
//protocol SetAlarmPicDelegate{
//    func SetAlarmPic(count:Int)
//}




//----------------------------------报警信息类--------------------------------------
class WarningInfo{
    var AlarmCode:String = ""
    var AlarmType:String = ""
    var UserName:String = ""
    var UserCode:String = ""
    var Sex:String=""   //"男"“女”
    var BedNumber:String = ""
    var AlarmContent:String = ""
    var AlarmTime:String = ""
    var EquipmentID:String = ""
    var IsRead:Bool = false
    init(alarmCode:String, userName:String,userCode:String,bedNumber:String, alarmContent:String,alarmTime:String,equipmentID:String,sex:String,alarmType:String){
        self.AlarmCode = alarmCode
        self.AlarmContent = alarmContent
        self.UserName = userName
        self.UserCode = userCode
        self.Sex = sex
        self.BedNumber = bedNumber
        self.AlarmTime = alarmTime
        self.EquipmentID = equipmentID
        self.AlarmType = alarmType
        
    }
}

