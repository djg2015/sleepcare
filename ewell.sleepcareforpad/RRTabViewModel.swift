//
//  RRTabViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/27/16.
//
//

import UIKit

class RRTabViewModel: BaseViewModel,GetRealtimeDataDelegate  {
    // 属性
    var realTimeCaches:Array<RealTimeReport>?
    
    var realtimeFlag:Bool = false
    
    // 当前用户号
    var _bedUserCode:String=""
    dynamic var BedUserCode:String{
        get
        {
            return self._bedUserCode
        }
        set(value)
        {
            self._bedUserCode = value
        }
    }
    
    
    var _bedUserName:String="选择老人"
    dynamic var BedUserName:String{
        get
        {
            return self._bedUserName
        }
        set(value)
        {
            self._bedUserName = value
        }
    }
    
    // 在离床状态
    var _onBedStatus:String?
    dynamic var OnBedStatus:String?{
        get
        {
            return self._onBedStatus
        }
        set(value)
        {
            self._onBedStatus = value
            if value == "在床"{
                StatusImageName = "icon_onbed.png"
            }
            else if value == "离床"{
                StatusImageName = "icon_offbed.png"
            }
            else if value == "请假"{
                StatusImageName = "icon_请假.png"
                
            }
            else if value == "异常"{
                
                StatusImageName = "icon_异常.png"
            }
            else{
                StatusImageName = ""
            }
        }
    }
    //在离床状态的图片,默认“检测中。png”
    var _statusImageName:String="icon_检测中.png"
    dynamic var StatusImageName:String{
        get
        {
            return self._statusImageName
        }
        set(value)
        {
            self._statusImageName=value
        }
    }
    // 当前呼吸
    var _currentRR:String="0"
    dynamic var CurrentRR:String{
        get
        {
            return self._currentRR
        }
        set(value)
        {
            let oldvalue = self._currentRR.toInt()
            self._currentRR = value
            if (value.toInt() <= 0 ){
                if oldvalue > 0{
                    //非在床：点变灰，报警图标变白
                    if OnBedStatus == "在床"{
                        //在床：点变红，报警图标变红
                        CurrentRRImage = "icon_red circle.png"
                        AlarmNoticeImage = UIImage(named:"btn_有警报.png")!
                    }
                    else{
                        CurrentRRImage = "icon_gray circle.png"
                        AlarmNoticeImage = UIImage(named:"btn_无警报.png")!
                    }
                    
                }
                
            }
                
            else if (value.toInt() < 10 ){
                if oldvalue >= 10{
                    //点变蓝，报警图标变红
                    CurrentRRImage = "icon_blue circle.png"
                    AlarmNoticeImage = UIImage(named:"btn_有警报.png")!
                }
            }
            else if (value.toInt() > 40 ){
                //点变红，报警图标变红
                if oldvalue <= 40{
                    CurrentRRImage = "icon_red circle.png"
                    AlarmNoticeImage = UIImage(named:"btn_有警报.png")!
                }
            }
            else {
                //值处于10-40正常状态,圆紫色，报警图标变白色
                if (oldvalue > 40 || oldvalue < 10){
                    CurrentRRImage = "icon_purple circle.png"
                    AlarmNoticeImage = UIImage(named:"btn_无警报.png")!
                }
            }
            
            
        }
    }
    
    
    //实时呼吸值状态的图片，默认灰色点
    var _currentRRImage:String="icon_gray circle.png"
    dynamic var CurrentRRImage:String{
        get
        {
            return self._currentRRImage
        }
        set(value)
        {
            self._currentRRImage=value
        }
    }
    
    //报警状态的图片，默认无报警白色图
    var _alarmNoticeImage:UIImage=UIImage(named:"btn_无警报.png")!
    dynamic var AlarmNoticeImage:UIImage{
        get
        {
            return self._alarmNoticeImage
        }
        set(value)
        {
            self._alarmNoticeImage=value
        }
    }
    
    // 上一次平均呼吸
    var _lastAvgRR:String="0"
    dynamic var LastAvgRR:String{
        get
        {
            return self._lastAvgRR
        }
        set(value)
        {
            self._lastAvgRR = value
        }
    }
    
    
    
    //呼吸报告(近24小时)
    var _rrDayReport:RRReportList = RRReportList()
    dynamic var RRDayReport:RRReportList{
        get{
            return self._rrDayReport
        }
        set(value){
            self._rrDayReport = value
        }
    }
    
    //呼吸报告(近1周)
    var _rrWeekReport:RRReportList = RRReportList()
    dynamic var RRWeekReport:RRReportList{
        get{
            return self._rrWeekReport
        }
        set(value){
            self._rrWeekReport = value
        }
    }
    
    
    //呼吸报告(近1月)
    var _rrMonthReport:RRReportList = RRReportList()
    dynamic var RRMonthReport:RRReportList{
        get{
            return self._rrMonthReport
        }
        set(value){
            self._rrMonthReport = value
        }
    }
    
  
    
    //---------------------------初始化-----------------------
    override init()
    {
        super.init()
        
       
    
    }
    
    //------------------------载入rr图标值--------------------------
    //返回值：1 正常 2没选择老人  3没添加设备
    func LoadPatientRR()->String {
        var flag = "3"
        try {({
            if SessionForSingle.GetSession() != nil{
                self.BedUserCode = SessionForSingle.GetSession()!.CurPatientCode
                self.BedUserName = SessionForSingle.GetSession()!.CurPatientName
                
                if self.BedUserCode != ""{
                    self.GetRRReport()
                    
                    //开启实时数据
                    self.realtimeFlag = true
                    RealTimeHelper.GetRealTimeInstance().SetDelegate("RRTabViewModel",currentViewModelDelegate: self)
                    RealTimeHelper.GetRealTimeInstance().setRealTimer()
                    flag = "1"
                }
                    //当前有老人设备但没有选择：隐藏除topview之外的subviews，提示先选择一个老人
                else if (SessionForSingle.GetSession()?.EquipmentList.count > 0){
                    self.ClearRRData()
                    flag = "2"
                }
                    //当前没有设备：隐藏页面内所有的subviews,提示添加noticeview提示先添加设备
                else{
                    self.ClearRRData()
                    flag = "3"
                }
                
            }
            },
            catch: { ex in
                //异常处理
                handleException(ex,showDialog: true)
            },
            finally: {
            }
            )}
        
        return flag
    }
    
    //获取chart图表数据
    func GetRRReport(){
        //获取某床位用户日呼吸报告
        var tempDayRange:RRRange = SleepCareForSingle().GetSingleRRTimeReport(self.BedUserCode,searchType:"1")
        var tempDayReportList:Array<RRTimeReport> = tempDayRange.rrTimeReportList
        //过滤原始日数据，赋值给RRDayReport(24个点选8个)
      
        var tempValueY:Array<String> = []
        var tempValueX: Array<String> = []
        var tempTitle = "平均呼吸"
        
        if tempDayReportList.count > 0{
        for (var i = 2;i<tempDayReportList.count;i+=3){
            tempValueX.append(tempDayReportList[i].ReportHour)
            tempValueY.append(tempDayReportList[i].AvgRR)
        }
          self.RRDayReport.flag = true
        }
        else{
         self.RRDayReport.flag = false
        }
        self.RRDayReport.ValueY = NSArray(objects:tempValueY)
        self.RRDayReport.ValueX = tempValueX
        self.RRDayReport.ValueTitles = NSArray(objects:tempTitle)
        self.RRDayReport.Type = "2"
        
        
        //获取某床位用户周心率报告
        var tempWeekRange:RRRange = SleepCareForSingle().GetSingleRRTimeReport(self.BedUserCode,searchType:"2")
        var tempWeekReportList:Array<RRTimeReport> = tempWeekRange.rrTimeReportList
        //过滤原始周数据，赋值给RRWeekReport
        
        tempValueY = []
        tempValueX = []
        tempTitle = "平均呼吸"
        if tempWeekReportList.count > 0{
        for tempWeekReport in tempWeekReportList{
            tempValueX.append(tempWeekReport.ReportHour)
            tempValueY.append(tempWeekReport.AvgRR)
        }
           self.RRWeekReport.flag = true
        }
        else{
        self.RRWeekReport.flag = false
        }
        self.RRWeekReport.ValueY = NSArray(objects:tempValueY)
        self.RRWeekReport.ValueX = tempValueX
        self.RRWeekReport.ValueTitles = NSArray(objects:tempTitle)
        self.RRWeekReport.Type = "2"
        
        
        
        //获取某床位用户月心率报告
        var tempMonthRange:RRRange = SleepCareForSingle().GetSingleRRTimeReport(self.BedUserCode,searchType:"3")
        var tempMonthReportList:Array<RRTimeReport> = tempMonthRange.rrTimeReportList
        //过滤原始月数据，赋值给RRMonthReport
        tempValueY = []
        tempValueX = []
        tempTitle = "平均呼吸"
        
        
        if tempMonthReportList.count > 10{
            for (var i = 0;i<tempMonthReportList.count;i+=3){
                tempValueX.append(tempMonthReportList[i].ReportHour)
                tempValueY.append(tempMonthReportList[i].AvgRR)
            }
             self.RRMonthReport.flag = true
        }
        else if tempMonthReportList.count > 0{
            for tempMonthReport in tempMonthReportList{
                tempValueX.append(tempMonthReport.ReportHour)
                tempValueY.append(tempMonthReport.AvgRR)
            }
             self.RRMonthReport.flag = true
        }
        else{
        self.RRMonthReport.flag = false
        }
        
        self.RRMonthReport.ValueY = NSArray(objects:tempValueY)
        self.RRMonthReport.ValueX = tempValueX
        self.RRMonthReport.ValueTitles = NSArray(objects:tempTitle)
        self.RRMonthReport.Type = "2"
        
        
    }
    
    //清空页面内数据
    func ClearRRData(){
        self.CleanRealtimeDelegate()
        self.realtimeFlag = false
        self.BedUserCode = ""
        self.BedUserName = ""
        self.RRDayReport = RRReportList()
        self.RRWeekReport = RRReportList()
        self.RRMonthReport = RRReportList()
    }
    
    
    //--------------------------获取实时rr数据--------------------------
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        if realtimeFlag{
            for realTimeReport in realtimeData.values{
                if self.BedUserCode == realTimeReport.BedUserCode{
                    self.OnBedStatus = realTimeReport.OnBedStatus
                    self.CurrentRR = realTimeReport.RR
                    self.LastAvgRR = realTimeReport.LastedAvgRR
                    
                    return
                }
            }
        }
    }
    //释放实时数据代理
    func CleanRealtimeDelegate(){
        RealTimeHelper.GetRealTimeInstance().SetDelegate("RRTabViewModel", currentViewModelDelegate: nil)
    }
    
    
}

//type ＝ 2
class RRReportList:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    var _valueTitles:NSArray = NSArray()
    dynamic var ValueTitles:NSArray{
        get
        {
            return self._valueTitles
        }
        set(value)
        {
            self._valueTitles=value
        }
    }
    
    var Type:String = ""
 var flag:Bool = true  //标志有没有chart数据
}
