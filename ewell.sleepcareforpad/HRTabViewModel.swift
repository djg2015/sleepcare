//
//  HRTabViewModel.swift
//
//
//  Created by Qinyuan Liu on 6/22/16.
//
//

import UIKit

class HRTabViewModel: BaseViewModel,GetRealtimeDataDelegate {
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
    // 当前心率
    var _currentHR:String="0"
    dynamic var CurrentHR:String{
        get
        {
            return self._currentHR
        }
        set(value)
        {
           
            self._currentHR = value
            
        }
        
    }
    
    
   
    
    
    // 上一次平均心率
    var _lastAvgHR:String="0"
    dynamic var LastAvgHR:String{
        get
        {
            return self._lastAvgHR
        }
        set(value)
        {
            self._lastAvgHR = value
        }
    }
    
    
    
    //心率报告(近24小时)
    var _hrDayReport:HRReportList = HRReportList()
    dynamic var HRDayReport:HRReportList{
        get{
            return self._hrDayReport
        }
        set(value){
            self._hrDayReport = value
        }
    }
    
    //心率报告(近1周)
    var _hrWeekReport:HRReportList = HRReportList()
    dynamic var HRWeekReport:HRReportList{
        get{
            return self._hrWeekReport
        }
        set(value){
            self._hrWeekReport = value
        }
    }
    
    
    //心率报告(近1月)
    var _hrMonthReport:HRReportList = HRReportList()
    dynamic var HRMonthReport:HRReportList{
        get{
            return self._hrMonthReport
        }
        set(value){
            self._hrMonthReport = value
        }
    }
    
  
 //---------------------------初始化-----------------------
    override init()
    {
        super.init()
        
    
    }
    
//------------------------载入hr图标值--------------------------
   
    func LoadPatientHR(){
      
        try {({
            if SessionForIphone.GetSession() != nil{
            self.BedUserCode = SessionForIphone.GetSession()!.CurPatientCode!
            self.BedUserName = SessionForIphone.GetSession()!.CurPatientName!
            
            if self.BedUserCode != ""{
               self.GetHRReport()
                
                //开启实时数据
                self.realtimeFlag = true
                RealTimeHelper.GetRealTimeInstance().SetDelegate("HRTabViewModel",currentViewModelDelegate: self)
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
               
            }
           
               
            else{
                self.ClearHRData()
               
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
    func GetHRReport(){
        //获取某床位用户日心率报告
        var tempDayRange:HRRange = SleepCareForIPhoneBussiness().GetSingleHRTimeReport(self.BedUserCode,searchType:"1")
        var tempDayReportList:Array<HRTimeReport> = tempDayRange.hrTimeReportList
        //过滤原始日数据，赋值给HRDayReport(24个点选8个)

        var tempValueY:Array<String> = []
        var tempValueX: Array<String> = []
        var tempTitle = "平均心率"
        
        //24个值
        if tempDayReportList.count > 0{
        for (var i = 0;i<tempDayReportList.count;i++){
            tempValueX.append(tempDayReportList[i].ReportHour)
            tempValueY.append(tempDayReportList[i].AvgHR)
        }
           self.HRDayReport.flag = true
        }
        else{
        self.HRDayReport.flag = false
        }
         self.HRDayReport.ValueY = NSArray(objects:tempValueY)
         self.HRDayReport.ValueX = tempValueX
         self.HRDayReport.ValueTitles = NSArray(objects:tempTitle)
         self.HRDayReport.Type = "1"
    
        
        //获取某床位用户周心率报告
        var tempWeekRange:HRRange = SleepCareForIPhoneBussiness().GetSingleHRTimeReport(self.BedUserCode,searchType:"2")
        var tempWeekReportList:Array<HRTimeReport> = tempWeekRange.hrTimeReportList
        //过滤原始周数据，赋值给HRWeekReport
    
        tempValueY = []
        tempValueX = []
        tempTitle = "平均心率"

        //7个值
        if tempWeekReportList.count > 0{
        for tempWeekReport in tempWeekReportList{
            tempValueX.append(tempWeekReport.ReportHour)
            tempValueY.append(tempWeekReport.AvgHR)
        }
          self.HRWeekReport.flag = true
        }
        else{
        self.HRWeekReport.flag = false
        }
        self.HRWeekReport.ValueY = NSArray(objects:tempValueY)
        self.HRWeekReport.ValueX = tempValueX
        self.HRWeekReport.ValueTitles = NSArray(objects:tempTitle)
        self.HRWeekReport.Type = "1"

        
        
        //获取某床位用户月心率报告
        var tempMonthRange:HRRange = SleepCareForIPhoneBussiness().GetSingleHRTimeReport(self.BedUserCode,searchType:"3")
        var tempMonthReportList:Array<HRTimeReport> = tempMonthRange.hrTimeReportList
        //过滤原始月数据，赋值给HRMonthReport
        tempValueY = []
        tempValueX = []
        tempTitle = "平均心率"
        
        //<=31个值
        if (tempMonthReportList.count>0){
        for (var i = 0;i<tempMonthReportList.count;i++){
            tempValueX.append(tempMonthReportList[i].ReportHour)
            tempValueY.append(tempMonthReportList[i].AvgHR)
        }
            self.HRMonthReport.flag = true
        }
       
            else{
            self.HRMonthReport.flag = false
            }
        
        self.HRMonthReport.ValueY = NSArray(objects:tempValueY)
        self.HRMonthReport.ValueX = tempValueX
        self.HRMonthReport.ValueTitles = NSArray(objects:tempTitle)
        self.HRMonthReport.Type = "1"
      

    }
    
    //清空页面内数据
    func ClearHRData(){
        self.CleanRealtimeDelegate()
        self.realtimeFlag = false
        self.BedUserCode = ""
        self.BedUserName = ""
        self.HRDayReport = HRReportList()
        self.HRWeekReport = HRReportList()
        self.HRMonthReport = HRReportList()
    }
    

    //--------------------------获取实时hr数据--------------------------
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        if realtimeFlag{
            for realTimeReport in realtimeData.values{
                if self.BedUserCode == realTimeReport.UserCode{
                    self.OnBedStatus = realTimeReport.OnBedStatus
                    self.CurrentHR = realTimeReport.HR
                    // self.InnerCircleValue = CGFloat((realTimeReport.LastedAvgHR as NSString).floatValue)/120.0
                    self.LastAvgHR = realTimeReport.LastedAvgHR
                    
                    return
                }
            }
        }
    }
    //释放实时数据代理
    func CleanRealtimeDelegate(){
        RealTimeHelper.GetRealTimeInstance().SetDelegate("HRTabViewModel", currentViewModelDelegate: nil)
    }
    
    
}

//type ＝ 1
class HRReportList:NSObject{
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
