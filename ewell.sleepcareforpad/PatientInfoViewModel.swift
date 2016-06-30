//
//  PatientInfoViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import Foundation

class PatientInfoViewModel: BaseViewModel {
    var _name:String = ""
    //名字
    dynamic var Name:String{
        get
        {
            return self._name
        }
        set(value)
        {
            self._name=value
        }
    }
    
    var _beduserCode:String = ""
    dynamic var BeduserCode:String{
        get
        {
            return self._beduserCode
        }
        set(value)
        {
            self._beduserCode=value
        }
    }
    
    var _telephone:String = ""
    //联系手机号
    dynamic var Telephone:String{
        get
        {
            return self._telephone
        }
        set(value)
        {
            self._telephone=value
        }
    }
    
    var _address:String = ""
    //联系地址
    dynamic var Address:String{
        get
        {
            return self._address
        }
        set(value)
        {
            self._address=value
        }
    }
    
    var _gender:String = ""
    //性别
    dynamic var Gender:String{
        get
        {
            return self._gender
        }
        set(value)
        {
            self._gender=value
        }
    }
    
    var _isMale:Bool=false
    //是否为“男”
    dynamic var IsMale:Bool{
        get
        {
            return self._isMale
        }
        set(value)
        {
            self._isMale=value
        }
    }
    
    var _isFemale:Bool=false
    //是否为“女”
    dynamic var IsFemale:Bool{
        get
        {
            return self._isFemale
        }
        set(value)
        {
            self._isFemale=value
        }
    }
    
    
    var confirmCommand: RACCommand?
    var clickMaleCommand:RACCommand?
    var clickFemaleCommand:RACCommand?
    var parentController:ConfirmPatientInfoController!
    var qrCode:String = ""
    
    
    
    //构造函数
    override init(){
        super.init()
        
        confirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Confirm()
        }
        
        clickMaleCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.ClickMale()
        }
        
        
        clickFemaleCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.ClickFemale()
        }

    }
    
    
    //获取设备绑定信息,可编辑修改
    func GetEquipmentInfo(){
        try {
            ({
                
                var beduserinfo:BedUserInfo = SleepCareForSingle().GetBedUserInfoByEquipmentID(self.qrCode)
                self.BeduserCode = beduserinfo.BedUserCode
                self.Name = beduserinfo.BedUserName
                self.Gender = beduserinfo.Sex
                self.Telephone = beduserinfo.MobilePhone
                self.Address = beduserinfo.Address
                
                
                
                if(self.Gender == "1"){
                    self.IsMale = true
                    self.IsFemale = false
                }
                else if(self.Gender == "2"){
                    self.IsFemale = true
                    self.IsMale = false
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
    
    //确认提交
    func Confirm()-> RACSignal{
        try {
            ({
                //检查姓名不能为空
                if self.Name == ""{
                    showDialogMsg(ShowMessage(MessageEnum.NameNil))
                    return
                }
                else{
                    //提交老人信息到服务器端，然后退回到登录页面
                  let result =  SleepCareForSingle().ModifyBedUserInfo(self.BeduserCode,bedUserName:self.Name,sex:self.Gender,mobilePhone:self.Telephone,address:self.Address)
                   
                    if result.Result{
                       self.AfterConfirmSuccess()
                    }
                        
                    else{
                        showDialogMsg(ShowMessage(MessageEnum.ConfirmPatientFail),"提示" ,buttonTitle: "确定", action:nil)
                        
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
        
        return RACSignal.empty()
    }
    
    //确认成功:add到mydevice的source列表，返回到mydevice页面
    func AfterConfirmSuccess(){
        if self.parentController != nil{
            let mydeviceVC = self.parentController.parentController.parentController
            if mydeviceVC != nil{
                //方法一：手动添加此equipment到session的设备列表
               //方法二：从服务器重新获取，刷新设备列表
                SessionForSingle.GetSession()!.BedUserCodeList.append(self.BeduserCode)
                mydeviceVC.mydeviceViewModel.LoadData()
    
            self.parentController.navigationController?.popToViewController(mydeviceVC, animated: true)
            }
        }
       
    }
    
    
    func ClickMale()-> RACSignal{
        if !self.IsMale
        {
            self.IsMale = true
            self.IsFemale = false
            self.Gender = "1"
            
        }
        return RACSignal.empty()
    }
    
    func ClickFemale()-> RACSignal{
        
        if !self.IsFemale
        {
            self.IsFemale = true
            self.IsMale = false
            self.Gender = "2"
        }
        
        return RACSignal.empty()
    }
}


