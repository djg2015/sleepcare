//
//  BaseViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    var controller:IBaseViewController?
  //  var controllerForIphone:IBaseViewController?

    //跳转界面
    func JumpPage(jumpedViewController:IBaseViewController){
        if(controller != nil){
            self.controller!.presentViewController(jumpedViewController, animated: false, completion: nil)
        }
    }

}
