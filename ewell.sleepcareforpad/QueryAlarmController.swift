//
//  QueryAlarmController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class QueryAlarmController:BaseViewController,UITableViewDelegate,UITableViewDataSource,SelectDateEndDelegate
{
    // 查询按钮
    @IBOutlet weak var btnQuery: UIButton!
    // 报警类型下拉图片
    @IBOutlet weak var btnPopDown: UIImageView!
    // 用户姓名查询条件
    @IBOutlet weak var txtUserNameCondition: UITextField!
    // 床位号查询条件
    @IBOutlet weak var txtBedNumberCondition: UITextField!
    // 报警类型查询条件
    @IBOutlet weak var txtAlarmType: UITextField!
    // 报警日期起始日期
    @IBOutlet weak var lblAlarmDateBegin: UILabel!
    // 报警日期结束日期
    @IBOutlet weak var lblAlarmDateEnd: UILabel!
    // 报警信息View
    @IBOutlet weak var viewAlarm: UIView!
    // 报警类型
    var popDownListAlarmType:PopDownList?
    // 界面模板
    var _queryAlarmViewModel:QueryAlarmViewModel = QueryAlarmViewModel()
    // 屏幕宽高
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    let identifier = "CellIdentifier"
    var tabViewAlarm: UITableView!
    
    var alarmcountDelegate:ReloadAlarmCountDelegate!
    // 返回按钮
    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // 刷新主页面
        if self.alarmcountDelegate != nil{
        self.alarmcountDelegate.ReloadAlarmCount()
        }
    }
    
    override func viewDidLoad() {
        // 设置查询按钮的样式
        self.btnQuery.setImage(UIImage(named: "searchBtn"), forState: UIControlState.Normal)
        self.btnQuery.setImage(UIImage(named: "searchBtnChecked"), forState: UIControlState.Highlighted)
        
        // 设置下拉框图片事件
        self.btnPopDown.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "popDownTouch")
        self.btnPopDown .addGestureRecognizer(singleTap)
        
        self.popDownListAlarmType = PopDownList(datasource: self._queryAlarmViewModel.AlarmTypeList, dismissHandler: self.ChoosedAlarmTypeItem)
        
        // 设置报警日期起始/结束时间控件属性
        self.lblAlarmDateBegin.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "initDatePicker")
        self.lblAlarmDateBegin .addGestureRecognizer(singleTap1)
        
        self.lblAlarmDateEnd.userInteractionEnabled = true
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "initDatePicker1")
        self.lblAlarmDateEnd .addGestureRecognizer(singleTap2)
        
        self.lblAlarmDateBegin.layer.borderColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1).CGColor
        self.lblAlarmDateBegin.layer.borderWidth = 1
        self.lblAlarmDateBegin.layer.cornerRadius = 5
        self.lblAlarmDateEnd.layer.borderColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1).CGColor
        self.lblAlarmDateEnd.layer.borderWidth = 1
        self.lblAlarmDateEnd.layer.cornerRadius = 5
        
        
        // 加载数据的tableView
        self.screenWidth = self.viewAlarm.frame.width
        self.screenHeight = self.viewAlarm.frame.height
        
        // 实例当前的报警tableView
        self.tabViewAlarm = UITableView(frame: CGRectMake(20, 10, self.screenWidth - 40, self.screenHeight - 30), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewAlarm.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewAlarm.delegate = self
        self.tabViewAlarm.dataSource = self
        self.tabViewAlarm!.tag = 1
        self._queryAlarmViewModel.tableView = self.tabViewAlarm
        self.viewAlarm.addSubview(self.tabViewAlarm)
        
        self.rac_setting()
    }
    
    //属性绑定
    func rac_setting(){
        RACObserve(self._queryAlarmViewModel, "UserNameCondition") ~> RAC(self.txtUserNameCondition, "text")
        self.txtUserNameCondition.rac_textSignal() ~> RAC(self._queryAlarmViewModel, "UserNameCondition")
        RACObserve(self._queryAlarmViewModel, "BedNumberCondition") ~> RAC(self.txtBedNumberCondition, "text")
        self.txtBedNumberCondition.rac_textSignal() ~> RAC(self._queryAlarmViewModel, "BedNumberCondition")
        RACObserve(self._queryAlarmViewModel, "SelectedAlarmType") ~> RAC(self.txtAlarmType, "text")
        RACObserve(self._queryAlarmViewModel, "AlarmDateBeginCondition") ~> RAC(self.lblAlarmDateBegin, "text")
        RACObserve(self._queryAlarmViewModel, "AlarmDateEndCondition") ~> RAC(self.lblAlarmDateEnd, "text")
        
        //事件绑定
        self.btnQuery.rac_command = _queryAlarmViewModel.searchAlarm
    }
    
    // 弹出报警类型选择
    func popDownTouch()
    {
        self.popDownListAlarmType!.Show(150, height: 310, uiElement: self.btnPopDown)
    }
    
    //选中科室/楼层
    func ChoosedAlarmTypeItem(downListModel:DownListModel){
        self._queryAlarmViewModel.SelectedAlarmType = downListModel.value
        self._queryAlarmViewModel.SelectedAlarmTypeCode = downListModel.key
    }
    
    func initDatePicker()
    {
        self.initDatePicker(1)
    }
    
    func initDatePicker1()
    {
        self.initDatePicker(2)
    }

    func initDatePicker(timeTag:Int)
    {
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        
        //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:devicebounds)
        alertview.detegate = self
        alertview.tag = timeTag
        self.view.addSubview(alertview)
    }
    
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        if(sender.tag == 1)
        {
            self._queryAlarmViewModel.AlarmDateBeginCondition = dateString
        }
        else
        {
            self._queryAlarmViewModel.AlarmDateEndCondition = dateString
        }
    }
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _queryAlarmViewModel.AlarmInfoList.count
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 创建睡眠质量总览tableView的列头
        var headViewAlarmInfo:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  60, 44))
        lblNumber.text = "序号"
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblNumber.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblUserName = UILabel(frame: CGRectMake(60, 0, 80, 44))
        lblUserName.text = "用户姓名"
        lblUserName.font = UIFont.boldSystemFontOfSize(18)
        lblUserName.textAlignment = .Center
        lblUserName.layer.borderWidth = 1
        lblUserName.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblUserName.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblBedNumber = UILabel(frame: CGRectMake(60 + 80, 0, 80, 44))
        lblBedNumber.text = "床位号"
        lblBedNumber.font = UIFont.boldSystemFontOfSize(18)
        lblBedNumber.textAlignment = .Center
        lblBedNumber.layer.borderWidth = 1
        lblBedNumber.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblBedNumber.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblAlarmTime = UILabel(frame: CGRectMake(60 + 80 * 2, 0, 140, 44))
        lblAlarmTime.text = "报警时间"
        lblAlarmTime.font = UIFont.boldSystemFontOfSize(18)
        lblAlarmTime.textAlignment = .Center
        lblAlarmTime.layer.borderWidth = 1
        lblAlarmTime.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblAlarmTime.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblAlarmContent = UILabel(frame: CGRectMake(60 + 80 * 2 + 140, 0, self.screenWidth - 80*2 - 140 - 60 - 40 - 120, 44))
        lblAlarmContent.text = "报警内容"
        lblAlarmContent.font = UIFont.boldSystemFontOfSize(18)
        lblAlarmContent.textAlignment = .Center
        lblAlarmContent.layer.borderWidth = 1
        lblAlarmContent.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblAlarmContent.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblOperate = UILabel(frame: CGRectMake(self.screenWidth - 40 - 120, 0, 120, 44))
        lblOperate.text = "处理操作"
        lblOperate.font = UIFont.boldSystemFontOfSize(18)
        lblOperate.textAlignment = .Center
        lblOperate.layer.borderWidth = 1
        lblOperate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblOperate.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        headViewAlarmInfo.addSubview(lblNumber)
        headViewAlarmInfo.addSubview(lblUserName)
        headViewAlarmInfo.addSubview(lblBedNumber)
        headViewAlarmInfo.addSubview(lblAlarmTime)
        headViewAlarmInfo.addSubview(lblAlarmContent)
        headViewAlarmInfo.addSubview(lblOperate)
        return headViewAlarmInfo
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        
        cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  60, 44))
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblNumber.backgroundColor = UIColor.whiteColor()
        
        var lblUserName = UILabel(frame: CGRectMake(60, 0, 80, 44))
        lblUserName.font = UIFont.boldSystemFontOfSize(18)
        lblUserName.textAlignment = .Center
        lblUserName.layer.borderWidth = 1
        lblUserName.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblUserName.backgroundColor = UIColor.whiteColor()
        
        var lblBedNumber = UILabel(frame: CGRectMake(60 + 80, 0, 80, 44))
        lblBedNumber.font = UIFont.boldSystemFontOfSize(18)
        lblBedNumber.textAlignment = .Center
        lblBedNumber.layer.borderWidth = 1
        lblBedNumber.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblBedNumber.backgroundColor = UIColor.whiteColor()
        
        var lblAlarmTime = UILabel(frame: CGRectMake(60 + 80 * 2, 0, 140, 44))
        lblAlarmTime.font = UIFont.boldSystemFontOfSize(18)
        lblAlarmTime.textAlignment = .Center
        lblAlarmTime.layer.borderWidth = 1
        lblAlarmTime.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblAlarmTime.backgroundColor = UIColor.whiteColor()
        
        var lblAlarmContent = UILabel(frame: CGRectMake(60 + 80 * 2 + 140, 0, self.screenWidth - 80*2 - 140 - 60 - 40 - 120, 44))
        lblAlarmContent.font = UIFont.boldSystemFontOfSize(18)
        lblAlarmContent.textAlignment = .Left
        lblAlarmContent.layer.borderWidth = 1
        lblAlarmContent.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblAlarmContent.backgroundColor = UIColor.whiteColor()
        
        var lblOperate = UIView(frame: CGRectMake(self.screenWidth - 40 - 120, 0, 120, 44))
        lblOperate.layer.borderWidth = 1
        lblOperate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        lblOperate.backgroundColor = UIColor.whiteColor()

        if(self._queryAlarmViewModel.AlarmInfoList.count > indexPath.row)
        {
            lblNumber.text = String(self._queryAlarmViewModel.AlarmInfoList[indexPath.row].Number)
            lblUserName.text = self._queryAlarmViewModel.AlarmInfoList[indexPath.row].UserName
            lblBedNumber.text = self._queryAlarmViewModel.AlarmInfoList[indexPath.row].BedNumber
            lblAlarmTime.text = self._queryAlarmViewModel.AlarmInfoList[indexPath.row].AlarmTime
            lblAlarmContent.text = self._queryAlarmViewModel.AlarmInfoList[indexPath.row].AlarmContent
            
            var btnHandle = UIButton(frame: CGRectMake(5, 7, 50, 30))
            btnHandle.setTitle("处理", forState: UIControlState.Normal)
            btnHandle.setTitleColor(UIColor.blueColor(), forState: .Normal)
            btnHandle.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnHandle.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            btnHandle.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            btnHandle.userInteractionEnabled = true
            var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleAlarm:")
            btnHandle.addGestureRecognizer(singleTap)
            singleTap.view?.tag = indexPath.row
            
            var btnFalse = UIButton(frame: CGRectMake(60, 7, 55, 30))
            btnFalse.setTitle("误警报", forState: UIControlState.Normal)
            btnFalse.setTitleColor(UIColor.blueColor(), forState: .Normal)
            btnFalse.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnFalse.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            btnFalse.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            btnFalse.userInteractionEnabled = true
            var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleFalseAlarm:")
            btnFalse.addGestureRecognizer(singleTap1)
            singleTap1.view?.tag = self._queryAlarmViewModel.AlarmInfoList[indexPath.row].Number
            
            lblOperate.addSubview(btnHandle)
            lblOperate.addSubview(btnFalse)
        }
       
        
        cell?.addSubview(lblNumber)
        cell?.addSubview(lblUserName)
        cell?.addSubview(lblBedNumber)
        cell?.addSubview(lblAlarmTime)
        cell?.addSubview(lblAlarmContent)
        cell?.addSubview(lblOperate)
        
        return cell!
    }
    
    //报警“已处理”
    func handleAlarm(sender:UITapGestureRecognizer)
    {
        var selectedNumber:Int = sender.view!.tag
        var alarmCode:String = self._queryAlarmViewModel.AlarmInfoList[selectedNumber].AlarmCode
        self._queryAlarmViewModel.HandleAlarm(alarmCode, handType: "002")
    }
    //报警“误报警”
    func handleFalseAlarm(sender:UITapGestureRecognizer)
    {
        var selectedNumber:Int = sender.view!.tag 
        var alarmCode:String = self._queryAlarmViewModel.AlarmInfoList[selectedNumber].AlarmCode
        self._queryAlarmViewModel.HandleAlarm(alarmCode, handType: "003")
    }
}

protocol ReloadAlarmCountDelegate{
func ReloadAlarmCount()
}
