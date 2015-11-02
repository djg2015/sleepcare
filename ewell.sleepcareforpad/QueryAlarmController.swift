//
//  QueryAlarmController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class QueryAlarmController:BaseViewController
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
        
        self.rac_setting()
    }
    
    //属性绑定
    func rac_setting(){
        RACObserve(self._queryAlarmViewModel, "UserNameCondition") ~> RAC(self.txtUserNameCondition, "text")
        RACObserve(self._queryAlarmViewModel, "BedNumberCondition") ~> RAC(self.txtBedNumberCondition, "text")
        RACObserve(self._queryAlarmViewModel, "SelectedAlarmType") ~> RAC(self.txtAlarmType, "text")
        
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
    
}
