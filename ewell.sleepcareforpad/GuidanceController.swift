//
//  GuidanceController.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/11/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import UIKit

class GuidanceController: IBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //提示“服务器信息有误，无法正常连接！”
        showDialogMsg("服务器信息有误，无法正常连接！请稍后再试")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func TrytoConnect(sender:AnyObject){
    
        
    }

}
