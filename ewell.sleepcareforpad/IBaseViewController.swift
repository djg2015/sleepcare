//
//  IBaseViewController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class IBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if (self.isViewLoaded() && (self.view.window == nil))// 是否已加载，且不可视
        {
            print("clean!!!!!!!!!!!!")
            // self.view = nil
        }

    }
    
   
}
