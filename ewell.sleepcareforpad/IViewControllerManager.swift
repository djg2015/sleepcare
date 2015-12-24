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

  //  var pointerList:Array<UnsafeMutablePointer> = []
    //控制器列表，在array中的顺序 ＝ 页面打开的先后顺序
    var ControllerList:Array<IBaseViewController> = []
    
    //跳转页面，显示
    class func ShowViewController(nextcontroller:IBaseViewController,reload:Bool){
        var index = self.instance!.IsExist(nextcontroller.nibName!)
        //当前已存在打开的viewcontroller
        if index >= 0{
            //需要reload，则从控制器列表中取出并清除，打开nextcontroller并放到控制器队尾
            if reload{
                //若当前页面是IAlarmView，则先手动关闭当前页
                if self.instance!.CurrentController!.nibName == "IAlarmView"{
                    self.instance!.CurrentController!.dismissViewControllerAnimated(true, completion: nil)
                }
              //释放内存空间
            self.instance!.ControllerList.removeAtIndex(index)
            //????????
            
            //跳转新页面,加入到控制器列表
            self.instance!.CurrentController!.presentViewController(nextcontroller, animated: true, completion: nil)
            self.instance!.ControllerList.append(nextcontroller)
            }
        }
            
            //当前不存在此名字的viewController，则将nextcontroller放入list
        else{
            self.instance!.CurrentController!.presentViewController(nextcontroller, animated: true, completion: nil)
             //申请内存
        //    var pointer:UnsafeMutablePointer = UnsafeMutablePointer.alloc(1)
            //初始化
         //   pointer.initialize(nextcontroller)
            //加入pointerlist
            
            self.instance!.ControllerList.append(nextcontroller)
         }
        
    }
    
    //关闭当前页面，从控制器列表中移除并清除内存空间
    class func CloseViewController(){
        self.instance!.CurrentController!.dismissViewControllerAnimated(true, completion: nil)
        //??????
        var index = self.instance!.ControllerList.count - 1
        self.instance!.ControllerList.removeAtIndex(index)
    }
    
    //首次登录程序时设置
    class func SetInstance(firstController:IBaseViewController){
        if self.instance == nil{
            self.instance = IViewControllerManager()
        }
        self.instance!.CurrentController = firstController
        self.instance!.ControllerList.append(firstController)
        
    }
    
    //获取当前对象
    class func GetInstance()->IViewControllerManager?{
        if self.instance == nil{
            return nil
        }
        return self.instance!
    }
    
    //判断控制器列表中是否存在名为nibname的控制器.若存在，返回index值； 不存在，返回 －1
    func IsExist(nibName:String)->Int{
        for(var i = 0; i<self.ControllerList.count; i++){
            if self.ControllerList[i].nibName == nibName{
                return i
            }
        }
        return -1
    }
}
