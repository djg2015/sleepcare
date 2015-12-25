//
//  IViewControllerManager.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/23/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import Foundation

class IViewControllerManager {
    private static var instance:IViewControllerManager? = nil
    //当前控制器
    private var _currentController:IBaseViewController?
    var CurrentController:IBaseViewController?{
        get{
            var index = self.ControllerList.count - 1
            return self.ControllerList[index]
        }
        set(value){
            self._currentController = value
        }
    }
    //控制器列表，在array中的顺序 ＝ 页面打开的先后顺序
    var ControllerList:Array<IBaseViewController> = []
    
    //-------------------方法----------------
    
    //获取当前对象
    class func GetInstance()->IViewControllerManager?{
        if self.instance == nil{
            self.instance = IViewControllerManager()
        }
        return self.instance!
    }
    
    class func IsExist(nibName:String)->Bool{
        for(var i = 0; i<self.instance!.ControllerList.count; i++){
            if self.instance!.ControllerList[i].nibName == nibName{
                return true
            }
        }
        return false
    }

    
    //设置根控制器
    func SetRootController(firstcontroller:IBaseViewController){
    self.ControllerList.append(firstcontroller)
        //内存
    }

    //跳转页面，显示
    func ShowViewController(nextcontroller:IBaseViewController?,nibName:String,reload:Bool){
        var index = self.GetIndex(nibName)
        //当前已存在打开的viewcontroller,找到原有的控制器，打开，放至队尾
        if nextcontroller == nil{
         var controller = self.ControllerList.removeAtIndex(index)
        self.CurrentController!.presentViewController(controller, animated: true, completion: nil)
        self.ControllerList.append(controller)
     
        }
        //传入新控制器nextcontroller
        else{
            //需要reload，则从控制器列表中取出并清除，打开nextcontroller并放到控制器队尾
            if reload{
                //则先手动关闭当前页
                self.CurrentController!.dismissViewControllerAnimated(true, completion: nil)
                self.ControllerList.removeAtIndex(index)
                //释放内存空间
                
                
            }
            else{
            
            }
        }

    }
    
    //关闭当前页面，从控制器列表中移除并清除内存空间
     func CloseViewController(){
        self.CurrentController!.dismissViewControllerAnimated(true, completion: nil)
        var index = self.ControllerList.count - 1
        self.ControllerList.removeAtIndex(index)
        //销毁指针，释放内存
        
        
    }
    
    //判断控制器列表中找名为nibname的控制器,返回index值； 不存在，返回 －1
    func GetIndex(nibName:String)->Int{
        for(var i = 0; i<self.ControllerList.count; i++){
        if self.ControllerList[i].nibName == nibName{
            return i
        }
        }
        return -1
    }
}
