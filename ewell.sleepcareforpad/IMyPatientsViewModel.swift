//
//  IMyPatientsViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/19.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//class IMyPatientsViewModel: BaseViewModel,RealTimeDelegate {
class IMyPatientsViewModel: BaseViewModel,GetRealtimeDataDelegate{
    //------------属性定义------------
    var _myPatientsArray:Array<MyPatientsTableCellViewModel> = []
    //我关注的床位用户集合
    dynamic var MyPatientsArray:Array<MyPatientsTableCellViewModel>{
        get
        {
            return self._myPatientsArray
        }
        set(value)
        {
            self._myPatientsArray=value
        }
    }
    
    //实时数据是否已经载入
    var _loadingFlag:Int = 0
    dynamic var LoadingFlag:Int{
        get
        {
            return self._loadingFlag
        }
        set(value)
        {
            self._loadingFlag = value
        }
    }
    
    //存放当前关注病人的usercode
    var bedUserCodeList:Array<String> = []
    //构造函数
    override init(){
        super.init()
        
        InitData()
    }
    
    //自定义处理----------------------
    //初始化数据加载
    func InitData(){
        try {
            ({
                
                var session = SessionForIphone.GetSession()
                session!.BedUserCodeList = Array<String>()
                
                var bedUserList:IBedUserList = SleepCareForIPhoneBussiness().GetBedUsersByLoginName(session!.User!.LoginName, mainCode: session!.User!.MainCode)
                
                
                self.MyPatientsArray = Array<MyPatientsTableCellViewModel>()
                
                var curArray = Array<MyPatientsTableCellViewModel>()
                
                var tempList = Array<UserAndEquipmentItem>()
                
                for(var i=0;i<bedUserList.bedUserInfoList.count;i++){
                     var tempListItem = UserAndEquipmentItem()
                    tempListItem.usercode = bedUserList.bedUserInfoList[i].BedUserCode
                    tempListItem.equipmentid = bedUserList.bedUserInfoList[i].EquipmentID
                    tempList.append(tempListItem)
                    
                    var myPatientsTableCellViewModel = MyPatientsTableCellViewModel()

                    myPatientsTableCellViewModel.BedUserCode = bedUserList.bedUserInfoList[i].BedUserCode
                    myPatientsTableCellViewModel.BedUserName = bedUserList.bedUserInfoList[i].BedUserName
                    myPatientsTableCellViewModel.RoomNum = bedUserList.bedUserInfoList[i].RoomName
                    myPatientsTableCellViewModel.BedNum = bedUserList.bedUserInfoList[i].BedNumber
                    myPatientsTableCellViewModel.BedCode = bedUserList.bedUserInfoList[i].BedCode
                    myPatientsTableCellViewModel.PartCode = bedUserList.bedUserInfoList[i].PartCode
                   
                    myPatientsTableCellViewModel.EquipmentID = bedUserList.bedUserInfoList[i].EquipmentID
                    myPatientsTableCellViewModel.SexImgName = bedUserList.bedUserInfoList[i].Sex
                    
                    
                    myPatientsTableCellViewModel.selectedBedUserHandler = self.ShowPatientDetail
                    myPatientsTableCellViewModel.deleteBedUserHandler = self.RemovePatient
                    
                    curArray.append(myPatientsTableCellViewModel)
                    session!.BedUserCodeList.append(bedUserList.bedUserInfoList[i].BedUserCode)
                }
                self.MyPatientsArray = curArray
                self.bedUserCodeList = session!.BedUserCodeList
                
                session!.UserandequipmentList = tempList
               
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        
        RealTimeHelper.GetRealTimeInstance().SetDelegate("IMyPatientsViewModel",currentViewModelDelegate: self)
        RealTimeHelper.GetRealTimeInstance().setRealTimer()
    }
    
    /**
    获取实时信息：心率，呼吸，在离床状态, 根据bedusercode删选
    :param: realtimeData	推送过来的实时数据字典
    */
    func GetRealtimeData(realtimeData:Dictionary<String,RealTimeReport>){
        for realTimeReport in realtimeData.values{
            if(!self.bedUserCodeList.isEmpty){
                var patient = self.MyPatientsArray.filter(
                    {$0.BedUserCode == realTimeReport.UserCode})
                if(patient.count > 0){
                    for(var i = 0; i < patient.count; i++){
                        patient[i].HR = realtimeData[patient[i].BedUserCode]!.HR
                        patient[i].RR = realtimeData[patient[i].BedUserCode]!.RR
                        patient[i].BedStatus = realtimeData[patient[i].BedUserCode]!.OnBedStatus
                    }
                }
            }
        }
        
        self.LoadingFlag += 1
    }
    
    func Clean(){
        self.bedUserCodeList = []
        self.MyPatientsArray = []
        RealTimeHelper.GetRealTimeInstance().SetDelegate("IMyPatientsViewModel", currentViewModelDelegate: nil)
    }

    
   
    
    //移除指定床位用户，更新服务器端，更新当前session的关注老人床位号列表
    func RemovePatient(myPatientsTableViewModel:MyPatientsTableCellViewModel){
        for(var i=0;i < self.MyPatientsArray.count; i++){
            if(self.MyPatientsArray[i].BedUserCode == myPatientsTableViewModel.BedUserCode){
    
            try {
                ({
                     var session = SessionForIphone.GetSession()
                     SleepCareForIPhoneBussiness().RemoveFollowBedUser(session!.User!.LoginName, bedUserCode: myPatientsTableViewModel.BedUserCode)
                    
                    //更新bedusercodelist
                    var tempList = session!.BedUserCodeList
                    for(var i = 0 ; i < tempList.count ; i++){
                        if tempList[i] == myPatientsTableViewModel.BedUserCode {
                            tempList.removeAtIndex(i)
                            break
                        }
                    }
                    session!.BedUserCodeList = tempList
                    self.bedUserCodeList = tempList
                    
                   //更新userandequipmentlist
                    var tempList2 = session!.UserandequipmentList
                    for(var i = 0 ; i < tempList2.count ; i++){
                        if tempList2[i].usercode == myPatientsTableViewModel.BedUserCode {
                            tempList2.removeAtIndex(i)
                            break
                        }
                    }
                    session!.UserandequipmentList = tempList2
                    
                    
                     //删除和这个老人有关的报警信息
                    IAlarmHelper.GetAlarmInstance().DeletePatientAlarm(myPatientsTableViewModel.BedUserName!)

                    },
                    catch: { ex in
                        //异常处理
                        handleException(ex,showDialog: true)
                    },
                    finally: {
                        
                    }
                )}
                
                //从本地病人列表中删除，会同步给controller里的列表，等待刷新
                self.MyPatientsArray.removeAtIndex(i);
                break;
        }//end if
        }//end for
        
    }
    
    
    
    func ShowPatientDetail(myPatientsTableViewModel:MyPatientsTableCellViewModel){
        var session = SessionForIphone.GetSession()
        session!.CurPatientCode = myPatientsTableViewModel.BedUserCode
        
    }
    /**
    添加关注的老人：更新到服务器端，更新当前session的关注老人床位号列表
    :param: myPatientsTableViewModels	当前所有关注的老人信息
    */
    func AddPatients(myPatientsTableViewModels:Array<MyPatientsTableCellViewModel>){
        try {
            ({
               
                var session = SessionForIphone.GetSession()
                var tempList = session!.BedUserCodeList
                var tempList2 = session!.UserandequipmentList
                
                var loginname = session!.User!.LoginName
                var maincode = session!.User!.MainCode
                
                for(var i=0;i<myPatientsTableViewModels.count;i++){
                    SleepCareForIPhoneBussiness().FollowBedUser(loginname, bedUserCode: myPatientsTableViewModels[i].BedUserCode, mainCode: maincode)
                 
                        myPatientsTableViewModels[i].selectedBedUserHandler = self.ShowPatientDetail
                        myPatientsTableViewModels[i].deleteBedUserHandler = self.RemovePatient
                        self.MyPatientsArray.append(myPatientsTableViewModels[i])
                        
                        tempList.append(myPatientsTableViewModels[i].BedUserCode)
                    let newItem = UserAndEquipmentItem()
                    newItem.usercode = myPatientsTableViewModels[i].BedUserCode
                    newItem.equipmentid = myPatientsTableViewModels[i].EquipmentID!
                    tempList2.append(newItem)
                  
                }
                session!.BedUserCodeList = tempList
                self.bedUserCodeList = tempList
                session!.UserandequipmentList = tempList2
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
}