//
//  Session.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//用户登录信息
class Session {
    private init(){
    
    }
    
    private var _loginUser:ILoginUser?
    var LoginUser:ILoginUser?{
        get
        {
            return self._loginUser
        }
    }

    //当前选中的场景code
    private var _curPartCode:String = ""
    var CurPartCode:String{
        get{
            return self._curPartCode
        }
        set(value){
            self._curPartCode=value
        }
    }
    

    
    private static var instance:Session? = nil
    
    //设置登录用户信息
    class func SetSession(user:ILoginUser){
        if(self.instance == nil){
        self.instance = Session()
        }
        self.instance!._loginUser = user
    }
    
    class func ClearSession(){
        self.instance = nil
    }
    
    class func GetSession() -> Session {
        return self.instance!
    }
}