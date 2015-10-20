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
    // 上一页按钮
    @IBOutlet weak var btnPreview: UIButton!
    // 下一页按钮
    @IBOutlet weak var btnNext: UIButton!
    // 当前页码
    @IBOutlet weak var lblCurrentPageIndex: UILabel!
    // 总页数
    @IBOutlet weak var lblTotalPageCount: UILabel!
    // 睡眠质量总览View
    @IBOutlet weak var viewSleepQuality: UIView!
    // 属性
    var qualityViewModel:SleepcareQualityPandectViewModel = SleepcareQualityPandectViewModel()
    
    let identifier = "CellIdentifier"
    var tabViewSleepQuality: UITableView!
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    
    var _previewBtnEnable:Bool = false
    // 分析结束时间
    var PreviewBtnEnable:Bool{
        get
        {
            return self._previewBtnEnable
        }
        set(value)
        {
            self._previewBtnEnable=value
            self.btnPreview.enabled = value
        }
    }
    
    var _nextBtnEnable:Bool = false
    // 分析结束时间
    var NextBtnEnable:Bool{
        get
        {
            return self._nextBtnEnable
        }
        set(value)
        {
            self._nextBtnEnable=value
            self.btnNext.enabled = value
        }
    }
    
    // 界面初始化
    func viewInit(userCode:String)
    {
        self.qualityViewModel.UserCode = userCode
        // 按钮定义
        self.btnSearch.rac_command = qualityViewModel.searchCommand
        self.btnPreview.rac_command = qualityViewModel.previewCommand
        self.btnNext.rac_command = qualityViewModel.nextCommand
        
        self.btnSearch.setImage(UIImage(named: "searchBtn"), forState: UIControlState.Normal)
        self.btnSearch.setImage(UIImage(named: "searchBtnChecked"), forState: UIControlState.Highlighted)
        self.btnPreview.setImage(UIImage(named:"previewBtnNormal"), forState: UIControlState.Normal)
        self.btnPreview.setImage(UIImage(named:"previewBtnDisable"), forState: UIControlState.Disabled)
        self.btnPreview.setImage(UIImage(named:"previewBtnChecked"), forState: UIControlState.Highlighted)
        self.btnNext.setImage(UIImage(named:"nextBtnNormal"), forState: UIControlState.Normal)
        self.btnNext.setImage(UIImage(named:"nextBtnDisable"), forState: UIControlState.Disabled)
        self.btnNext.setImage(UIImage(named:"nextBtnChecked"), forState: UIControlState.Highlighted)
        
        //属性绑定
        self.txtAnalysTimeBegin.rac_textSignal() ~> RAC(self.qualityViewModel, "AnalysisTimeBegin")
        self.txtAnalysTimeEnd.rac_textSignal() ~> RAC(self.qualityViewModel, "AnalysisTimeEnd")
        RACObserve(self.qualityViewModel, "CurrentPageIndex") ~> RAC(self.lblCurrentPageIndex, "text")
        RACObserve(self.qualityViewModel, "TotalPageCount") ~> RAC(self.lblTotalPageCount, "text")
        RACObserve(self.qualityViewModel, "PreviewBtnEnable") ~> RAC(self, "PreviewBtnEnable")
        RACObserve(self.qualityViewModel, "NextBtnEnable") ~> RAC(self, "NextBtnEnable")
        
        // 初始化TableView
        self.screenWidth = self.frame.width - 60
        self.screenHeight = self.frame.height
        
        // 实例当前的睡眠质量总览tableView
        self.tabViewSleepQuality = UITableView(frame: CGRectMake(10, 10, self.screenWidth, self.screenHeight - 30), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewSleepQuality!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewSleepQuality!.delegate = self
        self.tabViewSleepQuality!.dataSource = self
        self.tabViewSleepQuality!.tag = 1
        self.tabViewSleepQuality!.backgroundColor = UIColor.clearColor()
        // 注册自定义的TableCell
        //        self.tabViewSleepQuality!.registerNib(UINib(nibName: "AlarmTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        
        // 创建睡眠质量总览tableView的列头
        var headViewSleepQuality:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  100, 44))
        lblNumber.text = "序号"
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor.blackColor().CGColor
        lblNumber.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblAnalysTime = UILabel(frame: CGRectMake(100, 0, self.screenWidth - 100 - 120 * 3, 44))
        lblAnalysTime.text = "分析时段"
        lblAnalysTime.font = UIFont.boldSystemFontOfSize(18)
        lblAnalysTime.textAlignment = .Center
        lblAnalysTime.layer.borderWidth = 1
        lblAnalysTime.layer.borderColor = UIColor.blackColor().CGColor
        lblAnalysTime.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblAvgHR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 3, 0, 120, 44))
        lblAvgHR.text = "平均心率"
        lblAvgHR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgHR.textAlignment = .Center
        lblAvgHR.layer.borderWidth = 1
        lblAvgHR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgHR.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblAvgRR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 2, 0, 120, 44))
        lblAvgRR.text = "平均呼吸"
        lblAvgRR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgRR.textAlignment = .Center
        lblAvgRR.layer.borderWidth = 1
        lblAvgRR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgRR.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblTurnOverTimes = UILabel(frame: CGRectMake(self.screenWidth - 120, 0, 120, 44))
        lblTurnOverTimes.text = "翻身次数"
        lblTurnOverTimes.font = UIFont.boldSystemFontOfSize(18)
        lblTurnOverTimes.textAlignment = .Center
        lblTurnOverTimes.layer.borderWidth = 1
        lblTurnOverTimes.layer.borderColor = UIColor.blackColor().CGColor
        lblTurnOverTimes.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        headViewSleepQuality.addSubview(lblNumber)
        headViewSleepQuality.addSubview(lblAnalysTime)
        headViewSleepQuality.addSubview(lblAvgHR)
        headViewSleepQuality.addSubview(lblAvgRR)
        headViewSleepQuality.addSubview(lblTurnOverTimes)
        self.tabViewSleepQuality!.tableHeaderView = headViewSleepQuality
        
        self.viewSleepQuality.addSubview(self.tabViewSleepQuality)
        self.qualityViewModel.tableView = self.tabViewSleepQuality
    }
    
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section != 0)
        {
            return qualityViewModel.SleepQualityList.count
        }
        else
        {
            return 12
        }
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        
        cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  100, 44))
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor.blackColor().CGColor
        lblNumber.backgroundColor = UIColor.whiteColor()
        
        var lblAnalysTime = UILabel(frame: CGRectMake(100, 0, self.screenWidth - 100 - 120 * 3, 44))
        lblAnalysTime.font = UIFont.boldSystemFontOfSize(18)
        lblAnalysTime.textAlignment = .Center
        lblAnalysTime.layer.borderWidth = 1
        lblAnalysTime.layer.borderColor = UIColor.blackColor().CGColor
        lblAnalysTime.backgroundColor = UIColor.whiteColor()
        
        var lblAvgHR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 3, 0, 120, 44))
        lblAvgHR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgHR.textAlignment = .Center
        lblAvgHR.layer.borderWidth = 1
        lblAvgHR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgHR.backgroundColor = UIColor.whiteColor()
        
        var lblAvgRR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 2, 0, 120, 44))
        lblAvgRR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgRR.textAlignment = .Center
        lblAvgRR.layer.borderWidth = 1
        lblAvgRR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgRR.backgroundColor = UIColor.whiteColor()
        
        var lblTurnOverTimes = UILabel(frame: CGRectMake(self.screenWidth - 120, 0, 120, 44))
        lblTurnOverTimes.font = UIFont.boldSystemFontOfSize(18)
        lblTurnOverTimes.textAlignment = .Center
        lblTurnOverTimes.layer.borderWidth = 1
        lblTurnOverTimes.layer.borderColor = UIColor.blackColor().CGColor
        lblTurnOverTimes.backgroundColor = UIColor.whiteColor()
        
        if(self.qualityViewModel.SleepQualityList.count > indexPath.row)
        {
            lblNumber.text = String(self.qualityViewModel.SleepQualityList[indexPath.row].Number)
            lblAnalysTime.text = self.qualityViewModel.SleepQualityList[indexPath.row].AnalysisTimeSpan
            lblAvgHR.text = self.qualityViewModel.SleepQualityList[indexPath.row].AvgHR
            lblAvgRR.text = self.qualityViewModel.SleepQualityList[indexPath.row].AvgRR
            lblTurnOverTimes.text = self.qualityViewModel.SleepQualityList[indexPath.row].TurnTimes
        }
        
        
        cell?.addSubview(lblNumber)
        cell?.addSubview(lblAnalysTime)
        cell?.addSubview(lblAvgHR)
        cell?.addSubview(lblAvgRR)
        cell?.addSubview(lblTurnOverTimes)
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
