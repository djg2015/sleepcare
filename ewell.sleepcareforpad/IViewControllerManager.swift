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
    var CurrentController:IBaseViewController?
    
    
    //控制器列表，在array中的顺序 ＝ 页面打开的先后顺序
    var ControllerList:Array<IBaseViewController>!{
        didSet{
            var index = self.ControllerList.count - 1
            if index >= 0{
                self.CurrentController = self.ControllerList[index]
            }
        }
    }

    //-------------------方法----------------
    
    //获取当前对象
    class func GetInstance()->IViewControllerManager?{
        if self.instance == nil{
            self.instance = IViewControllerManager()
            self.instance!.ControllerList = []
        }
        return self.instance!
    }
    
    func IsExist(nibName:String)->Bool{
        for(var i = 0; i<self.ControllerList.count; i++){
            if self.ControllerList[i].nibName == nibName{
                return true
            }
        }
        return false
    }
    
    //设置根控制器
    func SetRootController(rootcontroller:IBaseViewController){
        self.ControllerList.removeAll()
        self.ControllerList.append(rootcontroller)
    }
    
    //按home键后执行该程序，判断当前页面是否为IAlarmView。是，则关闭
    func IsCurrentAlarmView(){
        if self.ControllerList.last.nibName == "IAlarmView"{
            var index = self.ControllerList.count - 1
            self.ControllerList[index].dismissViewControllerAnimated(false, completion: nil)
            var removecontroller = self.ControllerList.removeAtIndex(index)
            removecontroller.Clean()
        }
    }
    
    //跳转页面，显示
    func ShowViewController(nextcontroller:IBaseViewController?,nibName:String,reload:Bool){
        var index = self.GetIndex(nibName)
        //当前已存在打开的viewcontroller,找到原有的控制器，打开并放至队尾
        if nextcontroller == nil{  
            var controller = self.ControllerList.removeAtIndex(index)
            self.CurrentController!.presentViewController(controller, animated: true, completion: nil)
            self.ControllerList.append(controller)
        }
            //传入新控制器nextcontroller,打开nextcontroller并放到控制器队尾
        else{
             //需要reload，则从控制器列表中取出并清除
            if reload && index>=0{
                var removecontroller = self.ControllerList.removeAtIndex(index)
                removecontroller.Clean()
            }
            self.CurrentController!.presentViewController(nextcontroller!, animated: true, completion: nil)
            self.ControllerList.append(nextcontroller!)
        }
    }
    
    //关闭当前页面，从控制器列表中移除并清除内存空间
    func CloseViewController(){
        self.CurrentController!.dismissViewControllerAnimated(false, completion: nil)
        var index = self.ControllerList.count - 1
        var removecontroller = self.ControllerList.removeAtIndex(index)
        removecontroller.Clean()
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
