//
//  AlarmController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/8.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class AlarmView:UIView,UITableViewDelegate,UITableViewDataSource
{
    // 控件定义
    @IBOutlet weak var tabAlarm: UISegmentedControl!
    // 内容显示的View
    @IBOutlet weak var viewAlarm: UIView!
    
    
    // 属性定义
    var alarmViewModel = AlarmViewModel()
    
    let identifier = "CellIdentifier"
    var tabViewAlarm: UITableView!
    var tabViewTurnOver: UITableView!
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    
    func viewLoaded(userCode:String)
    {
        
        self.screenWidth = self.frame.width
        self.screenHeight = self.frame.height
        
        // 实例当前的报警tableView
        self.tabViewAlarm = UITableView(frame: CGRectMake(20, 10, self.screenWidth - 40, self.screenHeight - 30), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewAlarm!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewAlarm!.delegate = self
        self.tabViewAlarm!.dataSource = self
        self.tabViewAlarm!.tag = 1
        // 注册自定义的TableCell
        self.tabViewAlarm!.registerNib(UINib(nibName: "AlarmTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        
        // 创建报警tableView的列头
        var headViewAlarm:UIView = UIView(frame: CGRectMake(20, 0, UIScreen.mainScreen().bounds.size.width, 40))
        var lblLeaveTimespan = UILabel(frame: CGRectMake(0, 0,  (self.screenWidth - 40)/2 + 1, 40))
        lblLeaveTimespan.text = "离床时长"
        lblLeaveTimespan.font = UIFont.boldSystemFontOfSize(18)
        lblLeaveTimespan.textAlignment = .Center
        lblLeaveTimespan.layer.borderWidth = 1
        lblLeaveTimespan.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
        lblLeaveTimespan.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblLeaveTime = UILabel(frame: CGRectMake((self.screenWidth - 40)/2, 0, (self.screenWidth - 40)/2, 40))
        lblLeaveTime.text = "离床时间"
        lblLeaveTime.font = UIFont.boldSystemFontOfSize(18)
        lblLeaveTime.textAlignment = .Center
        lblLeaveTime.layer.borderWidth = 1
        lblLeaveTime.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
        lblLeaveTime.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        headViewAlarm.addSubview(lblLeaveTimespan)
        headViewAlarm.addSubview(lblLeaveTime)
        self.tabViewAlarm!.tableHeaderView = headViewAlarm
        
        
        self.tabViewTurnOver = UITableView(frame: CGRectMake(20, 10, self.screenWidth - 40, self.screenHeight - 30), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewTurnOver!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewTurnOver!.delegate = self
        self.tabViewTurnOver!.dataSource = self
        self.tabViewTurnOver!.tag = 2
        self.tabViewTurnOver!.registerNib(UINib(nibName: "TurnOverTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        
        var headViewTurnOver:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40))
        var lblDate = UILabel(frame: CGRectMake(0, 0,  (self.screenWidth - 40) / 3, 40))
        lblDate.text = "日期"
        lblDate.font = UIFont.boldSystemFontOfSize(18)
        lblDate.textAlignment = .Center
        lblDate.layer.borderWidth = 1
        lblDate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
        lblDate.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblCount = UILabel(frame: CGRectMake((self.screenWidth - 40)/3, 0, (self.screenWidth - 40)/3, 40))
        lblCount.text = "翻身次数"
        lblCount.font = UIFont.boldSystemFontOfSize(18)
        lblCount.textAlignment = .Center
        lblCount.layer.borderWidth = 1
        lblCount.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
        lblCount.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        var lblRate = UILabel(frame: CGRectMake(((self.screenWidth - 40)/3) * 2 - 1, 0, (self.screenWidth - 40)/3 + 1, 40))
        lblRate.text = "翻身频率"
        lblRate.font = UIFont.boldSystemFontOfSize(18)
        lblRate.textAlignment = .Center
        lblRate.layer.borderWidth = 1
        lblRate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
        lblRate.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 0.5)
        
        headViewTurnOver.addSubview(lblDate)
        headViewTurnOver.addSubview(lblCount)
        headViewTurnOver.addSubview(lblRate)
        self.tabViewTurnOver!.tableHeaderView = headViewTurnOver
        
        self.viewAlarm.addSubview(self.tabViewAlarm)
        self.viewAlarm.addSubview(self.tabViewTurnOver)
        
        // 加载数据
        self.alarmViewModel.UserCode = userCode
        self.rac_settings();
        
        self.tabViewAlarm.hidden = false
        self.tabViewTurnOver.hidden = true
    }
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1)
        {
            return self.alarmViewModel.AlarmInfoList.count
        }
        else
        {
            return self.alarmViewModel.TurnOverList.count
        }
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 显示离床报警
        if(tableView.tag == 1)
        {
            var alarmTableCell:AlarmTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? AlarmTableViewCell
            // 表示选择的是报警信息
            alarmTableCell!.lblCellLeaveTimespan.layer.borderWidth = 1
            alarmTableCell!.lblCellLeaveTimespan.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
            
            alarmTableCell!.lblCellLeaveTime.layer.borderWidth = 1
            alarmTableCell!.lblCellLeaveTime.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
            
            if(indexPath.row % 2 == 0)
            {
                alarmTableCell!.lblCellLeaveTimespan.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5).CGColor
                alarmTableCell!.lblCellLeaveTime.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5).CGColor
            }
            else
            {
                alarmTableCell!.lblCellLeaveTimespan.layer.backgroundColor = UIColor.whiteColor().CGColor
                alarmTableCell!.lblCellLeaveTime.layer.backgroundColor = UIColor.whiteColor().CGColor
            }
            
            var tempView:UIView = UIView()
            tempView.backgroundColor = UIColor.grayColor()
            alarmTableCell!.selectedBackgroundView = tempView
            alarmTableCell!.lblCellLeaveTimespan.text = self.alarmViewModel.AlarmInfoList[indexPath.row].LeaveBedTimeSpan
            alarmTableCell!.lblCellLeaveTimespan.font = UIFont.systemFontOfSize(14)
            alarmTableCell!.lblCellLeaveTime.text = self.alarmViewModel.AlarmInfoList[indexPath.row].LeaveBedTime
            alarmTableCell!.lblCellLeaveTime.font = UIFont.systemFontOfSize(14)
            return alarmTableCell!
        }
        else
        {
            var turnOverTableCell:TurnOverTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? TurnOverTableViewCell
            
            turnOverTableCell!.lblDate.layer.borderWidth = 1
            turnOverTableCell!.lblDate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
            
            turnOverTableCell!.lblTurnOverTimes.layer.borderWidth = 1
            turnOverTableCell!.lblTurnOverTimes.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
            
            turnOverTableCell!.lblTurnOverRate.layer.borderWidth = 1
            turnOverTableCell!.lblTurnOverRate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
            
            if(indexPath.row % 2 == 0)
            {
                turnOverTableCell!.lblDate.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5).CGColor
                turnOverTableCell!.lblTurnOverTimes.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5).CGColor
                turnOverTableCell!.lblTurnOverRate.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5).CGColor
            }
            else
            {
                turnOverTableCell!.lblDate.layer.backgroundColor = UIColor.whiteColor().CGColor
                turnOverTableCell!.lblTurnOverTimes.layer.backgroundColor = UIColor.whiteColor().CGColor
                turnOverTableCell!.lblTurnOverRate.layer.backgroundColor = UIColor.whiteColor().CGColor
            }
            
            var tempView:UIView = UIView()
            tempView.backgroundColor = UIColor.grayColor()
            turnOverTableCell!.selectedBackgroundView = tempView
            
            turnOverTableCell!.lblDate.text = self.alarmViewModel.TurnOverList[indexPath.row].Date
            turnOverTableCell!.lblDate.font = UIFont.systemFontOfSize(14)
            turnOverTableCell!.lblTurnOverTimes.text = self.alarmViewModel.TurnOverList[indexPath.row].TurnOverTimes
            turnOverTableCell!.lblTurnOverTimes.font = UIFont.systemFontOfSize(14)
            turnOverTableCell!.lblTurnOverRate.text = self.alarmViewModel.TurnOverList[indexPath.row].TurnOverRate
            turnOverTableCell!.lblTurnOverRate.font = UIFont.systemFontOfSize(14)
            return turnOverTableCell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        if(indexPath.row != 0)
        //        {
        //
        //
        //            var alert = UIAlertController(title: "Alert", message: "You have selected \(indexPath.row) Row ", preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        //        }
        
        
    }
    
    //-------------自定义方法处理---------------
    func rac_settings(){
        //属性绑定
        RACObserve(self.alarmViewModel, "FuncSelectedIndex") ~> RAC(self.tabAlarm, "selectedSegmentIndex")
        self.tabAlarm!.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext{
            _ in
            self.alarmViewModel.SelectChange(self.tabAlarm.selectedSegmentIndex)
            if(self.alarmViewModel.FuncSelectedIndex == 0)
            {
                self.tabViewAlarm.hidden = false
                self.tabViewTurnOver.hidden = true
            }
            else
            {
                self.tabViewAlarm.hidden = true
                self.tabViewTurnOver.hidden = false
            }
        }
    }
}