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
    // 当前心率
    var _currentHR:String="0"
    dynamic var CurrentHR:String{
        get
        {
            return self._currentHR
        }
        set(value)
        {
            let oldvalue = self._currentHR.toInt()
            self._currentHR = value
            if (value.toInt() <= 0 ){
                if oldvalue > 0{
                    //非在床：点变灰，报警图标变白
                    if OnBedStatus == "在床"{
                        //在床：点变红，报警图标变红
                        CurrentHRImage = "icon_red circle.png"
                        AlarmNoticeImage = "btn_有报警.png"
                    }
                    else{
                        CurrentHRImage = "icon_gray circle.png"
                        AlarmNoticeImage = "btn_无报警.png"
                    }
                    
                }
                
            }
                
            else if (value.toInt() < 20 ){
                if oldvalue >= 20{
                    //点变蓝，报警图标变红
                    CurrentHRImage = "icon_blue circle.png"
                    AlarmNoticeImage = "btn_有报警.png"
                }
            }
            else if (value.toInt()>80 ){
                //点变红，报警图标变红
                if oldvalue <= 80{
                    CurrentHRImage = "icon_red circle.png"
                    AlarmNoticeImage = "btn_有报警.png"
                }
            }
            else {
                //值处于20-80正常状态,圆紫色，报警图标变白色
                if (oldvalue > 80 || oldvalue < 20){
                    CurrentHRImage = "icon_purple circle.png"
                    AlarmNoticeImage = "btn_无报警.png"
                }
            }
            
            
        }
    }
    
    
    //实时心率值状态的图片，默认灰色点
    var _currentHRImage:String="icon_gray circle.png"
    dynamic var CurrentHRImage:String{
        get
        {
            return self._currentHRImage
        }
        set(value)
        {
            self._currentHRImage=value
        }
    }
    
    //报警状态的图片，默认无报警白色图
    var _alarmNoticeImage:String="btn_无报警.png"
    dynamic var AlarmNoticeImage:String{
        get
        {
            return self._alarmNoticeImage
        }
        set(value)
        {
            self._alarmNoticeImage=value
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
    
    var _patientList:Array<PopDownListItem> = Array<PopDownListItem>()
    //老人信息集合
    var  PatientList:Array<PopDownListItem>{
        get
        {
            return self._patientList
        }
        set(value)
        {
            self._patientList=value
        }
    }
    
    
    override init()
    {
        super.init()
        
//        self.CurrentHR = "70"
//        self.LastAvgHR = "0"
//        
//        //获取当前所有养老院的名字
//        let telephone = SessionForSingle.GetSession()?.User?.LoginName
//        if (telephone != nil && telephone != ""){
//            var tempPatientList:EquipmentList =  SleepCareForSingle().GetEquipmentsByLoginName(telephone!)
//            
//            for(var i=0;i<tempPatientList.equipmentList.count;i++){
//                var item:PopDownListItem = PopDownListItem()
//                item.key = tempPatientList.equipmentList[i].BedUserCode
//                item.value = tempPatientList.equipmentList[i].BedUserName
//                item.equipmentcode = tempPatientList.equipmentList[i].EquipmentID
//                self.PatientList.append(item)
//            }
//            
//        }
    }
    
    //返回值：1 正常 2没选择老人  3没添加设备
    func LoadPatientHR()->String {
        var flag = "3"
        try {({
            if SessionForSingle.GetSession() != nil{
            self.BedUserCode = SessionForSingle.GetSession()!.CurPatientCode
            self.BedUserName = SessionForSingle.GetSession()!.CurPatientName
            
            if self.BedUserCode != ""{
               self.GetHRReport()
                
                //开启实时数据
                self.realtimeFlag = true
                RealTimeHelper.GetRealTimeInstance().SetDelegate("HRTabViewModel",currentViewModelDelegate: self)
                RealTimeHelper.GetRealTimeInstance().setRealTimer()
                flag = "1"
            }
                //当前有老人设备但没有选择：隐藏除topview之外的subviews，提示先选择一个老人
            else if (SessionForSingle.GetSession()?.EquipmentList.count > 0){
                self.ClearHRData()
                flag = "2"
            }
                //当前没有设备：隐藏页面内所有的subviews,提示添加noticeview提示先添加设备
            else{
                self.ClearHRData()
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
    func GetHRReport(){
        //获取某床位用户日心率报告
        var tempDayRange:HRRange = SleepCareForSingle().GetSingleHRTimeReport(self.BedUserCode,searchType:"1")
        var tempDayReportList:Array<HRTimeReport> = tempDayRange.hrTimeReportList
        //过滤原始日数据，赋值给HRDayReport
        var tempDay:HRReportList=HRReportList()
        var tempValueY:Array<String> = []
        var tempValueX = NSArray()
        var tempTitle = "心率"
        for tempDayReport in tempDayReportList{
            tempValueY.append(tempDayReport.ReportHour)
            tempValueX.arrayByAddingObject(tempDayReport.AvgHR)
        }
        tempDay.valueY = NSArray(objects:tempValueX)
        tempDay.valueX = tempValueX
        tempDay.valueTitles = NSArray(objects:tempTitle)
        tempDay.Type = "1"
        self.HRDayReport = tempDay
        
        //获取某床位用户周心率报告
        var tempWeekRange:HRRange = SleepCareForSingle().GetSingleHRTimeReport(self.BedUserCode,searchType:"2")
        var tempWeekReportList:Array<HRTimeReport> = tempWeekRange.hrTimeReportList
        //过滤原始周数据，赋值给HRWeekReport
        var tempWeek:HRReportList=HRReportList()
        tempValueY = []
        tempValueX = NSArray()
        tempTitle = "心率"
        for tempWeekReport in tempWeekReportList{
            tempValueY.append(tempWeekReport.ReportHour)
            tempValueX.arrayByAddingObject(tempWeekReport.AvgHR)
        }
        tempWeek.valueY = NSArray(objects:tempValueX)
        tempWeek.valueX = tempValueX
        tempWeek.valueTitles = NSArray(objects:tempTitle)
        tempWeek.Type = "1"
        self.HRWeekReport = tempWeek
        
        
        //获取某床位用户月心率报告
        var tempMonthRange:HRRange = SleepCareForSingle().GetSingleHRTimeReport(self.BedUserCode,searchType:"3")
        var tempMonthReportList:Array<HRTimeReport> = tempWeekRange.hrTimeReportList
        //过滤原始月数据，赋值给HRMonthReport
        var tempMonth:HRReportList=HRReportList()
        tempValueY = []
        tempValueX = NSArray()
        tempTitle = "心率"
        for tempMonthReport in tempMonthReportList{
            tempValueY.append(tempMonthReport.ReportHour)
            tempValueX.arrayByAddingObject(tempMonthReport.AvgHR)
        }
        tempMonth.valueY = NSArray(objects:tempValueX)
        tempMonth.valueX = tempValueX
        tempMonth.valueTitles = NSArray(objects:tempTitle)
        tempMonth.Type = "1"
        self.HRMonthReport = tempMonth

    }
    
    //清空页面内数据
    func ClearHRData(){
        self.CleanRealtimeDelegate()
        self.realtimeFlag = false
        self.BedUserCode = ""
        self.BedUserName = ""
        self.OnBedStatus = ""
        self.CurrentHR = ""
        self.LastAvgHR = ""
        self.AlarmNoticeImage = ""
        self.HRDayReport = HRReportList()
        self.HRWeekReport = HRReportList()
        self.HRMonthReport = HRReportList()
    }
    
    //切换老人: 若新选择的老人不同于上一个老人：更新session内当前关注的老人信息
    //                                   更新viewmodel相关信息，调用接口获取hr数据
    func ChangePatient(bedusercode:String,bedusername:String,equipmentid:String){
        self.realtimeFlag = false
        if bedusercode != self.BedUserCode{
            
            SessionForSingle.GetSession()?.CurPatientCode = bedusercode
            SessionForSingle.GetSession()?.CurPatientName = bedusername
            SessionForSingle.GetSession()?.CurEquipmentID = equipmentid
            self.BedUserCode = bedusercode
            self.BedUserName = bedusername
            
            self.GetHRReport()
            
        }
        self.realtimeFlag = true
        
    }
    
    //获取实时数据
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        if realtimeFlag{
            for realTimeReport in realtimeData.values{
                if self.BedUserCode == realTimeReport.BedUserCode{
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


class HRReportList:NSObject{
    var valueX:NSArray = NSArray()
    var valueY:NSArray = NSArray()
    var valueTitles:NSArray = NSArray()
    var Type:String = ""
    
}
