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
    
    var _user:User?
    var LoginUser:User?{
        get
        {
            return self._user
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
    
    class func GetSession() -> Session {
        return self.instance!
    }
}