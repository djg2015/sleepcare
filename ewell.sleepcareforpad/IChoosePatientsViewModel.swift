//
//  IChoosePatientsViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class IChoosePatientsViewModel: BaseViewModel {
    //------------属性定义------------
    //我的关注老人主体对象
    var myPatientsViewModel:IMyPatientsViewModel!
    var _partBedUserDic:Dictionary<String,Array<BedPatientViewModel>>!
    //科室床位用户字典集合
    var PartBedUserDic:Dictionary<String,Array<BedPatientViewModel>>{
        get
        {
            return self._partBedUserDic
        }
        set(value)
        {
            self._partBedUserDic=value
        }
    }
    
    var _partArray:Array<PartTableViewModel>!
    //科室集合
    dynamic var PartArray:Array<PartTableViewModel>{
        get
        {
            return self._partArray
        }
        set(value)
        {
            self._partArray=value
        }
    }
    
    var _partBedUserArray:Array<BedPatientViewModel> = Array<BedPatientViewModel>()
    //科室下的床位用户集合
    dynamic var PartBedUserArray:Array<BedPatientViewModel>{
        get
        {
            return self._partBedUserArray
        }
        set(value)
        {
            self._partBedUserArray=value
        }
    }
    
    //界面处理命令
    var commitCommand: RACCommand?
    
    //构造函数
    override init(){
        super.init()
        
        commitCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.commit()
        }
        
        InitData()
    }
    
    //自定义处理----------------------
    //初始化数据加载
    func InitData(){
        try {
            ({
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var session = SessionForIphone.GetSession()
                var mainInfo:IMainInfo = sleepCareForIPhoneBussinessManager.GetPartInfoByMainCode(session.User!.MainCode)
                self.PartArray = Array<PartTableViewModel>()
                self.PartBedUserDic = Dictionary<String,Array<BedPatientViewModel>>()
                for(var i=0;i<mainInfo.PartInfoList.count;i++){
                    var partTableViewModel:PartTableViewModel = PartTableViewModel()
                    partTableViewModel.MainCode = session.User!.MainCode
                    partTableViewModel.PartCode = mainInfo.PartInfoList[i].PartCode
                    partTableViewModel.PartName = mainInfo.PartInfoList[i].PartName
                    partTableViewModel.selectedPartHandler = self.ChoosedPatient
                    if(i == 0){
                        partTableViewModel.IsChoosed = true
                    }
                    self.PartArray.append(partTableViewModel)
                    var curBedUsers:Array<BedPatientViewModel> = Array<BedPatientViewModel>()
                    for(var j=0;j<mainInfo.PartInfoList[i].BedInfoList.count;j++){
                        var bedPatientViewModel:BedPatientViewModel = BedPatientViewModel()
                        bedPatientViewModel.PartCode = mainInfo.PartInfoList[i].PartCode
                        bedPatientViewModel.PartName = mainInfo.PartInfoList[i].PartName
                        bedPatientViewModel.RoomNum = mainInfo.PartInfoList[i].BedInfoList[j].RoomName
                        bedPatientViewModel.BedNum = mainInfo.PartInfoList[i].BedInfoList[j].BedNumber
                        bedPatientViewModel.BedUserCode = mainInfo.PartInfoList[i].BedInfoList[j].BedUserCode
                        bedPatientViewModel.BedUserName = mainInfo.PartInfoList[i].BedInfoList[j].BedUserName
                        curBedUsers.append(bedPatientViewModel)
                    }
                    self.PartBedUserDic[mainInfo.PartInfoList[i].PartCode] = curBedUsers
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
    
    //确认关注
    func commit() -> RACSignal{
        try {
            ({
                var choosedPatients:Array<MyPatientsTableCellViewModel> = Array<MyPatientsTableCellViewModel>()
                for value in self.PartBedUserDic.values{
                    var choosedbedUsers = value.filter(
                        {$0.IsChoosed})
                    if(choosedbedUsers.count > 0){
                        for(var i=0;i<choosedbedUsers.count;i++){
                            var myPatientsTableCellViewModel:MyPatientsTableCellViewModel = MyPatientsTableCellViewModel()
                            myPatientsTableCellViewModel.BedUserCode = choosedbedUsers[i].BedUserCode
                            myPatientsTableCellViewModel.BedUserName = choosedbedUsers[i].BedUserName

                            myPatientsTableCellViewModel.PartCode = choosedbedUsers[i].PartCode

                            myPatientsTableCellViewModel.PartName = choosedbedUsers[i].PartName
                            myPatientsTableCellViewModel.BedNum = choosedbedUsers[i].BedNum
                            myPatientsTableCellViewModel.RoomNum = choosedbedUsers[i].RoomNum
                            choosedPatients.append(myPatientsTableCellViewModel)
                        }
                    }
                    
                }
                self.controllerForIphone?.dismissViewControllerAnimated(true, completion: nil)
                self.myPatientsViewModel.AddPatients(choosedPatients)
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        return RACSignal.empty()
        
    }
    
    //加载选择的科室对应的床位
    func ChoosedPatient(partTableViewModel:PartTableViewModel){
        self.PartBedUserArray = self.PartBedUserDic[partTableViewModel.PartCode!]!
    }
}