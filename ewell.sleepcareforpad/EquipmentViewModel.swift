//
//  EquipmentViewModel.swift
//
//
//  Created by System Administrator on 6/20/16.
//
//
import Foundation

class EquipmentViewModel: BaseViewModel {
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
    var parentController:EquipmentViewController!
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
        
        
        self.GetEquipmentInfo()
        
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
                
                
                
                if(self.Gender == "男"){
                    self.IsMale = true
                }
                else if(self.Gender == "女"){
                    self.IsFemale = true
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
            SleepCareForSingle().ModifyBedUserInfo(self.BeduserCode,bedUserName:self.Name,sex:self.Gender,mobilePhone:self.Telephone,address:self.Address)
                    
        if self.parentController != nil{
            self.parentController.navigationController?.popToRootViewControllerAnimated(false)
            
        }
        //代理:提交成功，则自动登录；不成功，手动登录
        if AutologinDelegate != nil{
            AutologinDelegate.AutoLoginAfterRegist()
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
    
    func ClickMale()-> RACSignal{
        if !self.IsMale
        {
            self.IsMale = true
            self.IsFemale = false
        }
        return RACSignal.empty()
    }
    
    func ClickFemale()-> RACSignal{
        
        if !self.IsFemale
        {
            self.IsFemale = true
            self.IsMale = false
        }
        
        return RACSignal.empty()
    }
}

protocol AutoLoginAfterRegistDelegate{
    func AutoLoginAfterRegist()
}
