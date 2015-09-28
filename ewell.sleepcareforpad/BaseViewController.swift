//
//  BaseViewController.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/25.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        
        //横屏显示
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var width = UIScreen.mainScreen().bounds.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
