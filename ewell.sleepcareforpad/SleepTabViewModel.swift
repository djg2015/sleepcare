//
//  SleepTabViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/28/16.
//
//

import UIKit

class SleepTabViewModel: BaseViewModel ,GetRealtimeDataDelegate{
    var realtimeFlag:Bool = false
    
    // 查看日期yyyy－mm－dd
    var _selectDate:String=""
    dynamic var SelectDate:String{
        get
        {
            return self._selectDate
        }
        set(value)
        {
            self._selectDate = value
        }
    }
    
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
                StatusImage = UIImage(named:"icon_onbed.png")!
            }
            else if value == "离床"{
                StatusImage = UIImage(named:"icon_offbed.png")!
            }
            else if value == "请假"{
                StatusImage = UIImage(named:"icon_请假.png")!
                
            }
            else if value == "异常"{
                
                StatusImage = UIImage(named:"icon_异常.png")!
            }
            else{
                StatusImage = UIImage(named:"icon_检测中.png")!
            }
        }
    }
    //在离床状态的图片,默认“检测中。png”
    var _statusImage:UIImage = UIImage(named:"icon_检测中.png")!
    dynamic var StatusImage:UIImage{
        get
        {
            return self._statusImage
        }
        set(value)
        {
            self._statusImage=value
        }
    }
    
    //圆圈内在床时长（时）
    var _bedTimespanHour:String="0"
    dynamic var BedTimespanHour:String{
        get
        {
            return self._bedTimespanHour
        }
        set(value)
        {
            self._bedTimespanHour = value
        }
    }
    //圆圈内在床时长（分）
    var _bedTimespanMinute:String="时0分"
    dynamic var BedTimespanMinute:String{
        get
        {
            return self._bedTimespanMinute
        }
        set(value)
        {
            self._bedTimespanMinute = value
        }
    }

    
    //清醒时长
    var _awakeningTimespan:String="0小时"
    dynamic var AwakeningTimespan:String{
        get
        {
            return self._awakeningTimespan
        }
        set(value)
        {
            self._awakeningTimespan = value
        }
    }
    
    //浅睡时长
    var _lightSleepTimespan:String="0小时"
    dynamic var LightSleepTimespan:String{
        get
        {
            return self._lightSleepTimespan
        }
        set(value)
        {
            self._lightSleepTimespan = value
        }
    }

    
    //深睡时长
    var _deepSleepTimespan:String="0小时"
    dynamic var DeepSleepTimespan:String{
        get
        {
            
            return self._deepSleepTimespan
        }
        set(value)
        {
            
            self._deepSleepTimespan = value
        }
    }
    
    var _awakeCircleValue:CGFloat = 0.0
    dynamic var AwakeCircleValue:CGFloat{
        get
        {
            return self._awakeCircleValue
        }
        set(value)
        {
            self._awakeCircleValue = value
        }
        
    }
    var _lightSleepCircleValue:CGFloat = 0.0
    dynamic var LightSleepCircleValue:CGFloat{
        get
        {
            return self._lightSleepCircleValue
        }
        set(value)
        {
            self._lightSleepCircleValue = value
        }
        
    }
    
    var _deepSleepCircleValue:CGFloat = 0.0
        dynamic var DeepSleepCircleValue:CGFloat{
                get
                {
                    return self._deepSleepCircleValue
                }
                set(value)
                {
                    self._deepSleepCircleValue = value
                }

    }
    

    
    //睡眠报告(近一周)
    var _sleepReport:SleepReportList = SleepReportList()
    dynamic var SleepReport:SleepReportList{
        get{
            return self._sleepReport
        }
        set(value){
            self._sleepReport = value
        }
    }
    
    
    override init()
    {
        super.init()
        
    
        
        //初始化selectDate
        
        let curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
        self.SelectDate = Date(string: curDateString, format: "yyyy-MM-dd").addDays(-1).description(format: "yyyy-MM-dd")
        
    }

    //------------------------载入sleep chart值--------------------------
    //返回值：1 正常 2没选择老人  3没添加设备
    func LoadPatientSleep()->String {
        var flag = "3"
        try {({
            if SessionForSingle.GetSession() != nil{
                self.BedUserCode = SessionForSingle.GetSession()!.CurPatientCode
                self.BedUserName = SessionForSingle.GetSession()!.CurPatientName
                
                if self.BedUserCode != ""{
                    self.GetSleepReport()
                    //开启实时数据
                    self.realtimeFlag = true
                    RealTimeHelper.GetRealTimeInstance().SetDelegate("SleepTabViewModel",currentViewModelDelegate: self)
                    RealTimeHelper.GetRealTimeInstance().setRealTimer()
                    flag = "1"
                }
                    //当前有老人设备但没有选择：隐藏除topview之外的subviews，提示先选择一个老人
                else if (SessionForSingle.GetSession()?.EquipmentList.count > 0){
                    self.ClearSleepData()
                    flag = "2"
                }
                    //当前没有设备：隐藏页面内所有的subviews,提示添加noticeview提示先添加设备
                else{
                    self.ClearSleepData()
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

    
    func GetSleepReport(){
        //获取某床位用户睡眠报告
        var tempSleepRange:SleepQualityReport = SleepCareForSingle().GetSleepQualityofBedUser(self.BedUserCode,reportDate:self.SelectDate)
        
       
        //圆圈内值
        if tempSleepRange.SleepTimespan != ""{
        self.BedTimespanHour = tempSleepRange.SleepTimespan.subString(0, length: 2)
        self.BedTimespanMinute = "时" + tempSleepRange.SleepTimespan.subString(3, length: 2) + "分"
        }
        else {
        self.BedTimespanHour = "0"
        self.BedTimespanMinute = "时0分"
        }
        //三个圆点值
        if tempSleepRange.AwakeningTimespan != ""{
        self.AwakeCircleValue = CGFloat((tempSleepRange.AwakeningTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.AwakeningTimespan.subString(3, length: 2) as NSString).floatValue/60.0)/12.0
        self.AwakeningTimespan = tempSleepRange.AwakeningTimespan.subString(0, length: 2) + "时" + tempSleepRange.AwakeningTimespan.subString(3, length: 2) + "分"
        }
        else{
            self.AwakeCircleValue = 0.0
         self.AwakeningTimespan = "0小时"
        }
        
        if tempSleepRange.LightSleepTimespan != ""{
             self.LightSleepCircleValue = CGFloat((tempSleepRange.LightSleepTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.LightSleepTimespan.subString(3, length: 2) as NSString).floatValue/60.0 )/12.0
            self.LightSleepTimespan = tempSleepRange.LightSleepTimespan.subString(0, length: 2) + "时" + tempSleepRange.LightSleepTimespan.subString(3, length: 2) + "分"
        }
        else{
             self.LightSleepCircleValue = 0.0
            self.LightSleepTimespan = "0小时"
        }
        
        if tempSleepRange.DeepSleepTimespan != ""{
             self.DeepSleepCircleValue = CGFloat((tempSleepRange.DeepSleepTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.DeepSleepTimespan.subString(3, length: 2) as NSString).floatValue/60.0)/12.0
            self.DeepSleepTimespan = tempSleepRange.DeepSleepTimespan.subString(0, length: 2) + "时" + tempSleepRange.DeepSleepTimespan.subString(3, length: 2) + "分"
        }
        else{
            self.DeepSleepCircleValue = 0.0
            self.DeepSleepTimespan = "0小时"
        }
        
       //睡眠图表值
        var tempSleepReportList:Array<SleepDateReport> = tempSleepRange.sleepRange
        var tempValueY:Array<String> = []
        var tempValueX: Array<String> = []
        var tempTitle = "睡眠时长"
        if tempSleepReportList.count>0{
        for(var i = 0; i<tempSleepReportList.count; i++){
//            var tempx:String = tempSleepReportList[i].WeekDay.subString(2, length: 1)
//            if i == 0{
//              tempx = "周" + tempx
//            }
//                    tempValueX.append(tempx)
//            tempValueX.append(tempSleepReportList[i].WeekDay.subString(2, length: 1))
            var tempday = tempSleepReportList[i].ReportDate.subString(8, length: 2)
            if tempday < "10"{
            tempday = tempday.subString(1, length: 1)
            }
            tempValueX.append(tempday)
                    tempValueY.append(tempSleepReportList[i].SleepTimespanHour)
        }
        self.SleepReport.flag = true
        }
        else{
        self.SleepReport.flag = false
        }
        self.SleepReport.ValueY = NSArray(objects:tempValueY)
        self.SleepReport.ValueX = tempValueX
        self.SleepReport.ValueTitles = NSArray(objects:tempTitle)
        self.SleepReport.Type = "3"
        
    }
    
    
    func ClearSleepData(){
         self.realtimeFlag = false
         self.BedUserName = ""
         self.BedUserCode = ""
        self.AwakeningTimespan = ""
        self.LightSleepTimespan = ""
        self.DeepSleepTimespan = ""
        self.BedTimespanMinute = ""
        self.BedTimespanHour = ""
        self.SleepReport = SleepReportList()
    }
    
    
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        if realtimeFlag{
            for realTimeReport in realtimeData.values{
                if self.BedUserCode == realTimeReport.BedUserCode{
                    self.OnBedStatus = realTimeReport.OnBedStatus
                    return
                }
            }
        }
    }
    //释放实时数据代理
    func CleanRealtimeDelegate(){
        RealTimeHelper.GetRealTimeInstance().SetDelegate("SleepTabViewModel", currentViewModelDelegate: nil)
    }
    



}

//type ＝ 3
class SleepReportList:NSObject{
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
