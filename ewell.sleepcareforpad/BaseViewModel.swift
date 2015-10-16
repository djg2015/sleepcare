//
//  BaseViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    var controller:BaseViewController?
    //跳转界面
    func JumpPage(jumpedViewController:BaseViewController){
        if(controller != nil){
            self.controller!.presentViewController(jumpedViewController, animated: true, completion: nil)
        }
    }
}
