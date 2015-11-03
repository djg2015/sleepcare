//
//  SleepcareMainViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainViewModel:BaseViewModel,RealTimeDelegate,WaringAttentionDelegate {
    //初始化
    override init() {
        super.init()
        //定时器
        self.CurTime = getCurrentTime()
        self.ChoosedSearchType = SearchType.byBedNum as String
        doTimer()
        var beds = Array<BedModel>()
        try {
            ({
                var session = Session.GetSession()
                let loginUser = session.LoginUser
                self.MainName = loginUser!.role?.RoleName
                self.PartBedsSearch(session.CurPartCode, searchType: "", searchContent: "")
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        //实时数据处理代理设置
        var xmppMsgManager = XmppMsgManager.GetInstance()
        xmppMsgManager?._realTimeDelegate = self
        xmppMsgManager?._waringAttentionDelegate = self
        self.realTimeCaches = Dictionary<String,RealTimeReport>()
        self.setRealTimer()
        //开启警告信息
        self.wariningCaches = Array<AlarmInfo>()
        self.BeginWaringAttention()
    }
    
    //属性定义
    var realTimeCaches:Dictionary<String,RealTimeReport>?
    var wariningCaches:Array<AlarmInfo>!
    //医院/养老院名称
    var _mainName:String?
    dynamic var MainName:String?{
        get
        {
            return self._mainName
        }
        set(value)
        {
            self._mainName=value
        }
    }
    
    //当前时间
    var _curTime:String?
    dynamic var CurTime:String?{
        get
        {
            return self._curTime
        }
        set(value)
        {
            self._curTime=value
        }
    }
    
    //楼层号
    var _partCode:String?
    dynamic var PartCode:String?{
        get
        {
            return self._partCode
        }
        set(value)
        {
            self._partCode=value
        }
    }
    
    //楼层号
    var _floorName:String?
    dynamic var FloorName:String?{
        get
        {
            return self._floorName
        }
        set(value)
        {
            self._floorName=value
        }
    }
    
    //房间总数
    var _roomCount:String?
    dynamic var RoomCount:String?{
        get
        {
            return self._roomCount
        }
        set(value)
        {
            self._roomCount=value
        }
    }
    
    //床位总数
    var _bedCount:String?
    dynamic var BedCount:String?{
        get
        {
            return self._bedCount
        }
        set(value)
        {
            self._bedCount=value
        }
    }
    
    //绑定的床位总数
    var _bindBedCount:String?
    dynamic var BindBedCount:String?{
        get
        {
            return self._bindBedCount
        }
        set(value)
        {
            self._bindBedCount=value
        }
    }
    
    //查询类型
    var _searchType:String?
    dynamic var ChoosedSearchType:String?{
        get
        {
            return self._searchType
        }
        set(value)
        {
            self._searchType=value
        }
    }
    
    //查询内容
    var _searchTypeContent:String?
    dynamic var SearchTypeContent:String?{
        get
        {
            return self._searchTypeContent
        }
        set(value)
        {
            self._searchTypeContent=value
        }
    }
    
    //床位集合
    var _bedModelList:Array<BedModel> = []
    dynamic var BedModelList:Array<BedModel>{
        get
        {
            return self._bedModelList
        }
        set(value)
        {
            self._bedModelList=value
        }
    }
    
    //分页数
    var _pageCount:Int = 0
    dynamic var PageCount:Int{
        get
        {
            return self._pageCount
        }
        set(value)
        {
            self._pageCount=value
        }
    }
    
    //警告数
    var _wariningCount:Int = 0
    dynamic var WariningCount:Int{
        get
        {
            return self._wariningCount
        }
        set(value)
        {
            self._wariningCount=value
        }
    }
    
    
    //界面命令
    
    
    
    
    //自定义事件
    //获取指定分页对应的床位集合
    func GetBedsOfPage(pageIndex:Int, count:NSInteger) -> Array<BedModel> {
        var result = Array<BedModel>()
        for(var i = (pageIndex - 1) * count;i < ((pageIndex - 1) * count + count); i++){
            if(self.BedModelList.count <= i){
                break
            }
            result.append(self.BedModelList[i])
        }
        return result
    }
    
    //时间显示
    func doTimer(){
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer.fire()
    }
    
    func timerFireMethod(timer: NSTimer) {
        self.CurTime = getCurrentTime()
    }
    
    //实时数据显示
    func setRealTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "realtimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    func realtimerFireMethod(timer: NSTimer) {
        
        for realTimeReport in self.realTimeCaches!.values{
            if(!self.BedModelList.isEmpty){
                var bed = self.BedModelList.filter(
                    {$0.BedCode == realTimeReport.BedCode})
                if(bed.count > 0){
                    let curBed:BedModel = bed[0]
                    if(curBed.BedNumber == "107"){
                        println(realTimeReport)
                    }
                    curBed.HR = realTimeReport.HR
                    curBed.RR = realTimeReport.RR
                    if(realTimeReport.OnBedStatus == "在床"){
                        curBed.BedStatus = BedStatusType.onbed
                    }
                    else if(realTimeReport.OnBedStatus == "离床"){
                        curBed.BedStatus = BedStatusType.leavebed
                    }
                    //                            let todoItem1 = TodoItem(deadline: NSDate(timeIntervalSinceNow: 1), title: "111", UUID: NSUUID().UUIDString)
                    //                            TodoList.sharedInstance.addItem(todoItem1)
                }
            }
        }
        
    }
    
    //开始报警提醒
    private var IsOpen:Bool = false
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWarining", name: "TodoListShouldRefresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        self.IsOpen = true
        self.setWarningTimer()
    }
    
    
    //关闭报警提醒
    func CloseWaringAttention(){
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        xmppMsgManager?.Close()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        TodoList.sharedInstance.removeItemAll()
    }
    
    //实时报警处理线程
    func setWarningTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "warningTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程处理报警信息
    func warningTimerFireMethod(timer: NSTimer) {
        if(self.wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self.wariningCaches[0] as AlarmInfo
            var session = Session.GetSession()
            if(session.CurPartCode == alarmInfo.PartCode){
                let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.UserName + alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
                TodoList.sharedInstance.addItem(todoItem)
                self.WariningCount++
            }
            self.wariningCaches.removeAtIndex(0)
        }
    }
    
    //点击报警通知直接打开报警界面
    func showWarining() {
        let controller = QueryAlarmController(nibName:"QueryAlarmView", bundle:nil)
        self.JumpPage(controller)        
        self.WariningCount = 0
    }
    
    //实时数据处理
    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
        let key = realTimeReport.BedCode
        if(self.realTimeCaches?.count > 0){
            var keys = self.realTimeCaches?.keys.filter({$0 == key})
            if(keys?.array.count == 0)
            {
                self.realTimeCaches?[key] = realTimeReport
            }
            else
            {
                self.realTimeCaches?.updateValue(realTimeReport, forKey: key)
            }
        }
        else{
            self.realTimeCaches?[key] = realTimeReport
        }
        
    }
    
    //报警数据处理
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                self.wariningCaches.append(alarmList.alarmInfoList[i])
            }
            
        }
        
    }
    
    //按房间号或床位号搜索
    func SearchByBedOrRoom(searchContent:String){
        var session = Session.GetSession()
        var searcgType = "2"
        if(self.ChoosedSearchType == SearchType.byRoomNum){
            searcgType = "1"
        }
        self.PartBedsSearch(session.CurPartCode, searchType: searcgType, searchContent: searchContent)
    }
    
    //房间床位查询设置
    private func PartBedsSearch(partCode:String,searchType:String,searchContent:String){
        self.BedModelList = Array<BedModel>()
        let sleepCareBussiness = SleepCareBussiness()
        //获取医院下的床位信
        var partInfo:PartInfo = sleepCareBussiness.GetPartInfoByPartCode(partCode, searchType: searchType, searchContent: searchContent, from: nil, max: nil)
        self.FloorName = partInfo.Location
        self.PartCode = partInfo.PartCode
        self.BedCount = partInfo.BedCount
        self.BindBedCount = partInfo.BindingCount
        self.RoomCount = partInfo.RoomCount
        var beds = Array<BedModel>()
        for(var i = 0;i < partInfo.BedList.count; i++) {
            var bed = BedModel()
            bed.UserName = partInfo.BedList[i].UserName
            bed.RoomNumber = partInfo.BedList[i].RoomNumber
            bed.BedCode = partInfo.BedList[i].BedCode
            bed.BedNumber = partInfo.BedList[i].BedNumber
            bed.BedStatus = BedStatusType.unline
            bed.UserCode = partInfo.BedList[i].UserCode
            beds.append(bed)
        }
        self.BedModelList = beds
    }
}

struct SearchType{
    static var byBedNum = "按床位号"
    static var byRoomNum = "按房间号"
}
