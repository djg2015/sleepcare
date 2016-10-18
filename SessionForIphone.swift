//
//  SessionForIphone.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//手机用户登录信息
class SessionForIphone {
    private init(){
        
    }
    
    private var _user:ILoginUser?
    var User:ILoginUser?{
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
    
    private var _curPatientCode:String?
    var CurPatientCode:String?{
        get{
            return self._curPatientCode
        }
        set(value){
            self._curPatientCode = value
        }
    }
    
    private var _curPatientName:String?
    var CurPatientName:String?{
        get{
            return self._curPatientName
        }
        set(value){
            self._curPatientName = value
        }
    }
    
    //当前关注的病人的code集合
    private var _bedUserCodeList:Array<String> = Array<String>()
    var BedUserCodeList:Array<String>{
        get{
            return self._bedUserCodeList
        }
        set(value){
            self._bedUserCodeList = value
        }
    }
    
   
    
    private static var instance:SessionForIphone? = nil
    
    //设置登录用户信息
    class func SetSession(user:ILoginUser){
        if(self.instance == nil){
            self.instance = SessionForIphone()
        }
        self.instance!.User = user
    }
    
    class func ClearSession(){
        self.instance = nil
    }
    
    class func GetSession() -> SessionForIphone? {
        if(self.instance == nil){
            print("session is nil")
            return nil
        }
        return self.instance!
    }
}