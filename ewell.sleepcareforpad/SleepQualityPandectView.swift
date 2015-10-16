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
    // 控件定义
    // 分析起始时间
    @IBOutlet weak var txtAnalysTimeBegin: UITextField!
    // 分析结束时间
    @IBOutlet weak var txtAnalysTimeEnd: UITextField!
    // 查询按钮
    @IBOutlet weak var btnSearch: UIButton!
    // 右侧分页
    @IBOutlet weak var viewPageInfo: UIView!
    
    var btnPreview:UIButton = UIButton()
    var lblCurrentPageIndex:UILabel = UILabel()
    var btnNext:UIButton = UIButton()
    var lblTotalPageCount:UILabel = UILabel()
    // 属性
    var qualityViewMode:SleepcareQualityPandectViewModel = SleepcareQualityPandectViewModel()
    
    // 界面初始化
    func viewInit()
    {
        // 绘制右上角分页
        btnPreview = UIButton(frame: CGRectMake(0,0,60,50))
        btnPreview.setTitle("上一页", forState: UIControlState.Normal)
        lblCurrentPageIndex = UILabel(frame: CGRectMake(60,0,20,50))
        // 绑定元素
        
        btnNext = UIButton(frame: CGRectMake(80,0,60,50))
        btnNext.setTitle("下一页", forState: UIControlState.Normal)
        lblTotalPageCount = UILabel(frame: CGRectMake(140,0,60,50))
        
        
        viewPageInfo.addSubview(btnPreview)
        viewPageInfo.addSubview(lblCurrentPageIndex)
        viewPageInfo.addSubview(btnNext)
        viewPageInfo.addSubview(lblTotalPageCount)

    }
    
    
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
