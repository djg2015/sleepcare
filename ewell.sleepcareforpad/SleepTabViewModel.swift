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
    
    //圆圈内:睡眠得分
    var _sleepQuality:String=""
    dynamic var SleepQuality:String{
        get
        {
            return self._sleepQuality
        }
        set(value)
        {
            self._sleepQuality = value
        }
    }

    
    
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
    
    //睡眠时长（
    var _bedTimespan:String="0时0分"
    dynamic var BedTimespan:String{
        get
        {
            return self._bedTimespan
        }
        set(value)
        {
            self._bedTimespan = value
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
    
    
    var _circleValueList:Array<CGFloat>=Array<CGFloat>()
    dynamic var CircleValueList:Array<CGFloat>{
        get
        {
            return self._circleValueList
        }
        set(value)
        {
            self._circleValueList = value
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

    func LoadPatientSleep(){
       
        try {({
            if SessionForIphone.GetSession() != nil{
                self.BedUserCode = SessionForIphone.GetSession()!.CurPatientCode!
                self.BedUserName = SessionForIphone.GetSession()!.CurPatientName!
                
                if self.BedUserCode != ""{
                    //需要捕获异常
                    self.GetSleepReport()
                    //开启实时数据
                    self.realtimeFlag = true
                    RealTimeHelper.GetRealTimeInstance().SetDelegate("SleepTabViewModel",currentViewModelDelegate: self)
                    RealTimeHelper.GetRealTimeInstance().setRealTimer()
                  
                }
                    
                else{
                    self.ClearSleepData()
                   
                }
                
            }
            },
            catch: { ex in
                //异常处理
                //handleException(ex,showDialog: true)
                 showDialogMsg("暂时无法获取睡眠信息！")
            },
            finally: {
            }
            )}
        
     
    }

    
    func GetSleepReport(){
        //获取某床位用户睡眠报告
        var tempSleepRange:SleepQualityReport = SleepCareForIPhoneBussiness().GetSleepQualityofBedUser(self.BedUserCode,reportDate:self.SelectDate)
        
       //
        self.SleepQuality = tempSleepRange.SleepQuality
        
        
        //睡眠时长label（？时？分）
        if tempSleepRange.SleepTimespan != ""{
            self.BedTimespan = tempSleepRange.SleepTimespan.subString(0, length: 2)+"时"+tempSleepRange.SleepTimespan.subString(3, length: 2) + "分"
        }
        else {
        self.BedTimespan = "0时0分"
        }
        
        
        //三个圆点值
        if tempSleepRange.AwakeningTimespan != ""{
        self.AwakeCircleValue = CGFloat((tempSleepRange.AwakeningTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.AwakeningTimespan.subString(3, length: 2) as NSString).floatValue/60.0)/12.0
        self.AwakeningTimespan = tempSleepRange.AwakeningTimespan.subString(0, length: 2) + "时" + tempSleepRange.AwakeningTimespan.subString(3, length: 2) + "分"
        }
        else{
            self.AwakeCircleValue = 0.0
         self.AwakeningTimespan = "0"
        }
        
        if tempSleepRange.LightSleepTimespan != ""{
             self.LightSleepCircleValue = CGFloat((tempSleepRange.LightSleepTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.LightSleepTimespan.subString(3, length: 2) as NSString).floatValue/60.0 )/12.0
            self.LightSleepTimespan = tempSleepRange.LightSleepTimespan.subString(0, length: 2) + "时" + tempSleepRange.LightSleepTimespan.subString(3, length: 2) + "分"
        }
        else{
             self.LightSleepCircleValue = 0.0
            self.LightSleepTimespan = "0"
        }
        
        if tempSleepRange.DeepSleepTimespan != ""{
             self.DeepSleepCircleValue = CGFloat((tempSleepRange.DeepSleepTimespan.subString(0, length: 2) as NSString).floatValue + (tempSleepRange.DeepSleepTimespan.subString(3, length: 2) as NSString).floatValue/60.0)/12.0
            self.DeepSleepTimespan = tempSleepRange.DeepSleepTimespan.subString(0, length: 2) + "时" + tempSleepRange.DeepSleepTimespan.subString(3, length: 2) + "分"
        }
        else{
            self.DeepSleepCircleValue = 0.0
            self.DeepSleepTimespan = "0"
        }
        
       var tempcirclevalur = Array<CGFloat>()
        tempcirclevalur.append(self.DeepSleepCircleValue)
        tempcirclevalur.append(self.LightSleepCircleValue)
        tempcirclevalur.append(self.AwakeCircleValue)
        self.CircleValueList = tempcirclevalur
        
        
       //睡眠图表值
        var tempSleepReportList:Array<SleepDateReport> = tempSleepRange.sleepRange
        var tempValueY:Array<String> = []
        var tempValueX: Array<String> = []
        var tempTitle = "睡眠时长"
        if tempSleepReportList.count>0{
        for(var i = 0; i<tempSleepReportList.count; i++){
            
            //星期几
            tempValueX.append(tempSleepReportList[i].WeekDay.subString(2, length: 1))
            

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
        self.BedTimespan = ""
       
        self.SleepReport = SleepReportList()
        self._circleValueList = Array<CGFloat>()
    }
    
    
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        if realtimeFlag{
            for realTimeReport in realtimeData.values{
                if self.BedUserCode == realTimeReport.UserCode{
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
