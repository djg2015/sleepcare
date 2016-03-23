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
    //纪录上一次选的partcode
     var lasedPartCode = ""
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
    //初始化viewmodel，获取当前养老院下的所有未选择关注的老人
    func InitData(){
        try {
            ({
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isconnect = xmppMsgManager!.Connect()
                if(!isconnect){
                    showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
                }
                else{
                var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
                var session = SessionForIphone.GetSession()
                var mainInfo:IMainInfo = sleepCareForIPhoneBussinessManager.GetPartInfoWithoutFollowBedUser(session!.User!.LoginName,mainCode:session!.User!.MainCode)
             
                self.PartArray = Array<PartTableViewModel>()
                self.PartBedUserDic = Dictionary<String,Array<BedPatientViewModel>>()
                for(var i=0;i<mainInfo.PartInfoList.count;i++){
                    var partTableViewModel:PartTableViewModel = PartTableViewModel()
                    partTableViewModel.MainCode = session!.User!.MainCode
                    partTableViewModel.PartCode = mainInfo.PartInfoList[i].PartCode
                    partTableViewModel.PartName = mainInfo.PartInfoList[i].PartName
                    partTableViewModel.selectedPartHandler = self.ChoosedPart
                    if(i == 0){
                        partTableViewModel.IsChoosed = true
                    }
                    self.PartArray.append(partTableViewModel)
                    var curBedUsers:Array<BedPatientViewModel> = Array<BedPatientViewModel>()
                    for(var j=0;j<mainInfo.PartInfoList[i].BedInfoList.count;j++){
                        var bedPatientViewModel:BedPatientViewModel = BedPatientViewModel()
                       
                        bedPatientViewModel.MainName = mainInfo.PartInfoList[i].MainName
                        bedPatientViewModel.PartCode = mainInfo.PartInfoList[i].PartCode
                        bedPatientViewModel.PartName = mainInfo.PartInfoList[i].PartName
                        bedPatientViewModel.RoomNum = mainInfo.PartInfoList[i].BedInfoList[j].RoomName
                        bedPatientViewModel.BedNum = mainInfo.PartInfoList[i].BedInfoList[j].BedNumber
                        bedPatientViewModel.BedCode = mainInfo.PartInfoList[i].BedInfoList[j].BedCode
                        bedPatientViewModel.BedUserCode = mainInfo.PartInfoList[i].BedInfoList[j].BedUserCode
                        bedPatientViewModel.BedUserName = mainInfo.PartInfoList[i].BedInfoList[j].BedUserName
                        bedPatientViewModel.selectedPatientHandler = self.ChoosedPatient
                        curBedUsers.append(bedPatientViewModel)
                    }
                    self.PartBedUserDic[mainInfo.PartInfoList[i].PartCode] = curBedUsers
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
    
    //确认关注,把要关注的老人加入到我的老人列表中
    func commit() -> RACSignal{
        try {
            ({
               
                var choosedPatients:Array<MyPatientsTableCellViewModel> = Array<MyPatientsTableCellViewModel>()
                var flag = false
                for value in self.PartBedUserDic.values{
                    var choosedbedUsers = value.filter(
                        {$0.IsChoosed})
                    if(choosedbedUsers.count > 0){
                         //有选择关注老人
                        flag = true
                        for(var i=0;i<choosedbedUsers.count;i++){
                            var myPatientsTableCellViewModel:MyPatientsTableCellViewModel = MyPatientsTableCellViewModel()
                            myPatientsTableCellViewModel.BedUserCode = choosedbedUsers[i].BedUserCode
                            myPatientsTableCellViewModel.BedUserName = choosedbedUsers[i].BedUserName
                            myPatientsTableCellViewModel.PartCode = choosedbedUsers[i].PartCode
                            myPatientsTableCellViewModel.PartName = choosedbedUsers[i].PartName
                            myPatientsTableCellViewModel.BedCode = choosedbedUsers[i].BedCode
                            myPatientsTableCellViewModel.MainName = choosedbedUsers[i].MainName
                            myPatientsTableCellViewModel.BedNum = choosedbedUsers[i].BedNum
                            myPatientsTableCellViewModel.RoomNum = choosedbedUsers[i].RoomNum
                            choosedPatients.append(myPatientsTableCellViewModel)
                        }
                    }
                    
                }
                
                if flag{
                    self.myPatientsViewModel.AddPatients(choosedPatients)
                }
                IViewControllerManager.GetInstance()!.CloseViewController()
                
                
                
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
    func ChoosedPart(partTableViewModel:PartTableViewModel){
        if(self.lasedPartCode == partTableViewModel.PartCode){
            return
        }
        self.lasedPartCode = partTableViewModel.PartCode!
        self.PartBedUserArray = self.PartBedUserDic[partTableViewModel.PartCode!]!
    }
    
    //当时使用者自己时不允许多选病人
    func ChoosedPatient(bedPatientViewModel:BedPatientViewModel){
        var session = SessionForIphone.GetSession()
        if(session?.User?.UserType == LoginUserType.UserSelf){
            for value in self.PartBedUserDic.values{
                var choosedbedUsers = value.filter(
                    {$0.IsChoosed && $0.BedUserCode != bedPatientViewModel.BedUserCode})
                if(choosedbedUsers.count > 0){
                    for(var i=0;i<choosedbedUsers.count;i++){
                        choosedbedUsers[i].IsChoosed = false
                    }
                }
                
            }
        }
        
    }
}