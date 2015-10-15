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
    
    func viewLoaded()
    {
        self.tabViewAlarm = UITableView(frame: CGRectMake(0, 0, self.viewAlarm.frame.width, self.viewAlarm.frame.height), style: UITableViewStyle.Plain)
        self.tabViewAlarm!.delegate = self
        self.tabViewAlarm!.dataSource = self
        self.tabViewAlarm!.tag = 1
        // 注册自定义的TableCell
        self.tabViewAlarm!.registerNib(UINib(nibName: "AlarmTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        
        var headViewAlarm:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40))
        var lblLeaveTimespan = UILabel(frame: CGRectMake(0, 0,  screenWidth / 2 + 1, 40))
        lblLeaveTimespan.text = "离床时长"
        lblLeaveTimespan.textAlignment = .Center
        lblLeaveTimespan.layer.borderWidth = 1
        lblLeaveTimespan.layer.borderColor = UIColor.blackColor().CGColor
        lblLeaveTimespan.backgroundColor = UIColor.lightGrayColor()
        
        var lblLeaveTime = UILabel(frame: CGRectMake(screenWidth/2, 0, screenWidth/2, 40))
        lblLeaveTime.text = "离床时间"
        lblLeaveTime.textAlignment = .Center
        lblLeaveTime.layer.borderWidth = 1
        lblLeaveTime.layer.borderColor = UIColor.blackColor().CGColor
        lblLeaveTime.backgroundColor = UIColor.lightGrayColor()
        
        headViewAlarm.addSubview(lblLeaveTimespan)
        headViewAlarm.addSubview(lblLeaveTime)
        self.tabViewAlarm!.tableHeaderView = headViewAlarm
        
        
        self.tabViewTurnOver = UITableView(frame: CGRectMake(0, 0, self.viewAlarm.frame.width, self.viewAlarm.frame.height), style: UITableViewStyle.Plain)
        self.tabViewTurnOver!.delegate = self
        self.tabViewTurnOver!.dataSource = self
        self.tabViewTurnOver!.tag = 2
        self.tabViewTurnOver!.registerNib(UINib(nibName: "TurnOverTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)

        //        self.myTable!.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "SwiftCell")
        self.viewAlarm.addSubview(self.tabViewAlarm)
        self.viewAlarm.addSubview(self.tabViewTurnOver)
        
        // 加载数据
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
            alarmTableCell!.lblCellLeaveTimespan.text = self.alarmViewModel.AlarmInfoList[indexPath.row].LeaveBedTime
            alarmTableCell!.lblCellLeaveTime.text = self.alarmViewModel.AlarmInfoList[indexPath.row].LeaveBedTimeSpan
            return alarmTableCell!
        }
        else
        {
            var turnOverTableCell:TurnOverTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? TurnOverTableViewCell
            turnOverTableCell!.lblDate.text = self.alarmViewModel.TurnOverList[indexPath.row].Date
            turnOverTableCell!.lblTurnOverTimes.text = self.alarmViewModel.TurnOverList[indexPath.row].TurnOverTimes
            turnOverTableCell!.lblTurnOverRate.text = self.alarmViewModel.TurnOverList[indexPath.row].TurnOverRate
            return turnOverTableCell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row != 0)
        {
            var alert = UIAlertController(title: "Alert", message: "You have selected \(indexPath.row) Row ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        }
    }

    //-------------自定义方法处理---------------
    func rac_settings(){
        //属性绑定
        RACObserve(self.alarmViewModel, "FuncSelectedIndex") ~> RAC(self.tabAlarm, "selectedSegmentIndex")
          self.tabAlarm!.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext{
            _ in
            var v = 0
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