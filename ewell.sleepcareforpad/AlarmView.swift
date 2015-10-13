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
    var tabAlarmAndMove: UITableView!
    
    func viewLoaded()
    {
        self.tabAlarmAndMove = UITableView(frame: CGRectMake(0, 0, 400, 300), style: UITableViewStyle.Plain)
        self.tabAlarmAndMove!.delegate = self
        self.tabAlarmAndMove!.dataSource = self
        // 注册自定义的TableCell
        self.tabAlarmAndMove!.registerNib(UINib(nibName: "AlarmTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        //        self.myTable!.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "SwiftCell")
        self.viewAlarm.addSubview(self.tabAlarmAndMove)
        
        // 加载数据
        self.rac_settings();
    }

    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//        var myCell:AlarmTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? AlarmTableViewCell
//
//        myCell!.lblCellLeaveTime.text = "离床时长"
//        myCell!.lblCellLeaveTimespan.text = "离床时间"
//        return myCell!

        
        if(self.alarmViewModel.FuncSelectedIndex == 0)
        {
            var alarmTableCell:AlarmTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? AlarmTableViewCell
            // 表示选择的是报警信息
            alarmTableCell!.lblCellLeaveTimespan.text = "离床时长"
            alarmTableCell!.lblCellLeaveTime.text = "离床时间"
            return alarmTableCell!
        }
        else
        {
            var alarmTableCell:AlarmTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? AlarmTableViewCell
            alarmTableCell!.lblCellLeaveTimespan.text = "离床时长"
            alarmTableCell!.lblCellLeaveTime.text = "离床时间"
            return alarmTableCell!
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
            var message:BaseMessage = self.alarmViewModel.SelectChange(self.tabAlarm.selectedSegmentIndex)
            if(message is AlarmList)
            {
                // 表示返回的是报警信息
                
            }
            else if(message is TurnOverAnalysList)
            {
                // 表示返回的是体动/翻身信息
            }
            self.tabAlarmAndMove.reloadData();
        }
    }
}