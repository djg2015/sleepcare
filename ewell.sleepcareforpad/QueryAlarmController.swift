//
//  QueryAlarmController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class QueryAlarmController:BaseViewController,SelectDateEndDelegate
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
    // 报警类型
    var popDownListAlarmType:PopDownList?
    // 界面模板
    var _queryAlarmViewModel:QueryAlarmViewModel = QueryAlarmViewModel()
    
    
    // 返回按钮
    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
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

        
        self.rac_setting()
    }
    
    //属性绑定
    func rac_setting(){
        RACObserve(self._queryAlarmViewModel, "UserNameCondition") ~> RAC(self.txtUserNameCondition, "text")
        RACObserve(self._queryAlarmViewModel, "BedNumberCondition") ~> RAC(self.txtBedNumberCondition, "text")
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

}
