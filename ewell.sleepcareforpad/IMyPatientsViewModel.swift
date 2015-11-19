//
//  IMyPatientsViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/19.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class IMyPatientsViewModel: BaseViewModel {
    //------------属性定义------------
    
    var _myPatientsArray:Array<MyPatientsTableCellViewModel>!
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
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var session = SessionForIphone.GetSession()
                var bedUserList:IBedUserList = sleepCareForIPhoneBussinessManager.GetBedUsersByLoginName(session.User!.LoginName, mainCode: session.User!.MainCode)
                self.MyPatientsArray = Array<MyPatientsTableCellViewModel>()
                var curArray = Array<MyPatientsTableCellViewModel>()
                for(var i=0;i<bedUserList.bedUserInfoList.count;i++){
                    var myPatientsTableCellViewModel = MyPatientsTableCellViewModel()
                    myPatientsTableCellViewModel.BedUserCode = bedUserList.bedUserInfoList[i].BedUserCode
                    myPatientsTableCellViewModel.BedUserName = bedUserList.bedUserInfoList[i].BedUserName
                    myPatientsTableCellViewModel.RoomNum = bedUserList.bedUserInfoList[i].RoomName
                    myPatientsTableCellViewModel.BedNum = bedUserList.bedUserInfoList[i].BedNumber
                    myPatientsTableCellViewModel.PartCode = bedUserList.bedUserInfoList[i].PartCode
                    myPatientsTableCellViewModel.PartName = bedUserList.bedUserInfoList[i].PartName
                    myPatientsTableCellViewModel.selectedBedUserHandler = self.ShowPatientDetail
                    curArray.append(myPatientsTableCellViewModel)
                }
                 self.MyPatientsArray = curArray
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
    }
    
    //显示某个床位用户体征明细
    func ShowPatientDetail(myPatientsTableViewModel:MyPatientsTableCellViewModel){
        
    }
    
    //移除指定床位用户
    func RemovePatient(myPatientsTableViewModel:MyPatientsTableCellViewModel){
    
    }
    
    //添加指定床位用户
    func AddPatients(myPatientsTableViewModels:Array<MyPatientsTableCellViewModel>){
        try {
            ({
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var session = SessionForIphone.GetSession()
                for(var i=0;i<myPatientsTableViewModels.count;i++){
                    sleepCareForIPhoneBussinessManager.FollowBedUser(session.User!.LoginName, bedUserCode: myPatientsTableViewModels[i].BedUserCode!, mainCode: session.User!.MainCode)
                    var exist = self.MyPatientsArray.filter({$0.BedUserCode == myPatientsTableViewModels[i].BedUserCode})
                    if(exist.count == 0){
                        self.MyPatientsArray.append(myPatientsTableViewModels[i])
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
   
}