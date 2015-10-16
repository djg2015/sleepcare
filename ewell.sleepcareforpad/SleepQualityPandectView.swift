//
//  SleepQualityPandectView.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class SleepQualityPandectView: UIView,UITableViewDelegate,UITableViewDataSource
 {
    
    // 属性
    var qualityViewMode:SleepcareQualityPandectViewModel = SleepcareQualityPandectViewModel()
    
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qualityViewMode.SleepQualityList.count
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            return UITableViewCell()
        }
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
    }
 }
