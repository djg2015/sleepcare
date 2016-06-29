//
//  SessionForSingle.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 6/23/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation
//手机用户登录信息
class SessionForSingle {
    private init(){
        
    }
    
    private var _user:LoginUser?
    var User:LoginUser?{
        get{
            return self._user
        }
        set(value){
            self._user = value
        }
    }
    
    private var _oldPwd:String?
    var OldPwd:String?{
        get{
            return self._oldPwd
        }
        set(value){
            self._oldPwd = value
        }
    }
    
    private var _curPatientCode:String=""
    var CurPatientCode:String{
        get{
            return self._curPatientCode
        }
        set(value){
            self._curPatientCode = value
        }
    }
    
    private var _curPatientName:String=""
    var CurPatientName:String{
        get{
            return self._curPatientName
        }
        set(value){
            self._curPatientName = value
        }
    }

    
    //当前帐号下所有设备信息
    private var _equipmentList:Array<EquipmentInfo> = Array<EquipmentInfo>()
    var EquipmentList:Array<EquipmentInfo>{
        get{
            return self._equipmentList
        }
        set(value){
            self._equipmentList = value
        }
    }
    
    //当前老人的code集合
    private var _bedUserCodeList:Array<String> = Array<String>()
    var BedUserCodeList:Array<String>{
        get{
            return self._bedUserCodeList
        }
        set(value){
            self._bedUserCodeList = value
        }
    }
    
    private static var instance:SessionForSingle? = nil
    
    //设置登录用户信息
    class func SetSession(user:LoginUser){
        if(self.instance == nil){
            self.instance = SessionForSingle()
        }
        self.instance!.User = user
    }
    
    class func ClearSession(){
        self.instance = nil
    }
    
    class func GetSession() -> SessionForSingle? {
        if(self.instance == nil){
            print("session is nil")
            //return nil
            self.instance = SessionForSingle()
           
        }
        return self.instance!
    }
}