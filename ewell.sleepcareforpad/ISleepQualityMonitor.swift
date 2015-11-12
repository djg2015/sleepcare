//
//  ISleepQualityMonitor.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class ISleepQualityMonitor: UIView {
    
    @IBOutlet weak var process: CircularLoaderView!
    
    func viewInit()
    {
        process.maxProcess = 10.0
        process.currentProcess = 4.0
        process.bottomTitle = "睡眠状态"
    }
    
}
