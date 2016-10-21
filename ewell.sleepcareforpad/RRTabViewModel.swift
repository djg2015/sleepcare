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
    
    
    var _bedUserName:String=""
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
                StatusImageName = "icon_onbed"
            }
            else if value == "离床"{
                StatusImageName = "icon_offbed"
            }
            else if value == "请假"{
                StatusImageName = "icon_请假"
                
            }
            else if value == "异常"{
                
                StatusImageName = "icon_异常"
            }
            else{
                StatusImageName = ""
            }
        }
    }
    //在离床状态的图片
    var _statusImageName:String=""
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
          
            self._currentRR = value
        
            
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
   
    func LoadPatientRR(){
       
        try {({
            if SessionForIphone.GetSession() != nil{
                self.BedUserCode = SessionForIphone.GetSession()!.CurPatientCode!
                self.BedUserName = SessionForIphone.GetSession()!.CurPatientName!
                
                if self.BedUserCode != ""{
                    self.GetRRReport()
                    
                    //开启实时数据
                    self.realtimeFlag = true
                    RealTimeHelper.GetRealTimeInstance().SetDelegate("RRTabViewModel",currentViewModelDelegate: self)
                    RealTimeHelper.GetRealTimeInstance().setRealTimer()
                  
                }
                    
                else{
                    self.ClearRRData()
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
    
    }
    
    //获取chart图表数据
    func GetRRReport(){
        //获取某床位用户日呼吸报告
        var tempDayRange:RRRange = SleepCareForIPhoneBussiness().GetSingleRRTimeReport(self.BedUserCode,searchType:"1")
        var tempDayReportList:Array<RRTimeReport> = tempDayRange.rrTimeReportList
        //过滤原始日数据，赋值给RRDayReport(24个点选8个)
      
        var tempValueY:Array<String> = []
        var tempValueX: Array<String> = []
        var tempTitle = "平均呼吸"
        
        if tempDayReportList.count > 0{
        for (var i = 0;i<tempDayReportList.count;i++){
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
        var tempWeekRange:RRRange = SleepCareForIPhoneBussiness().GetSingleRRTimeReport(self.BedUserCode,searchType:"2")
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
        var tempMonthRange:RRRange = SleepCareForIPhoneBussiness().GetSingleRRTimeReport(self.BedUserCode,searchType:"3")
        var tempMonthReportList:Array<RRTimeReport> = tempMonthRange.rrTimeReportList
        //过滤原始月数据，赋值给RRMonthReport
        tempValueY = []
        tempValueX = []
        tempTitle = "平均呼吸"
        
       if tempMonthReportList.count > 0{
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
                if self.BedUserCode == realTimeReport.UserCode{
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
