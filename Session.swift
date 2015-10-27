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
    
    private var _user:User?
    var LoginUser:User?{
        get
        {
            return self._user
        }
    }

    //当前选中的场景code
    private var _curPartCode:String = "00001"
    var CurPartCode:String{
        get{
            return self._curPartCode
        }
        set(value){
            self._curPartCode=value
        }
    }
    
    //当前选中的场景code
    private var _PartCodes:Array<Role> = Array<Role>()
    var PartCodes:Array<Role>{
        get{
            return self._PartCodes
        }
        set(value){
            self._PartCodes=value
        }
    }

    
    private static var instance:Session? = nil
    
    //设置登录用户信息
    class func SetSession(user:User){
        if(self.instance == nil){
        self.instance = Session()
        }
        self.instance!._user = user
    }
    
    class func ClearSession(){
        self.instance = nil
    }
    
    class func GetSession() -> Session {
        return self.instance!
    }
}