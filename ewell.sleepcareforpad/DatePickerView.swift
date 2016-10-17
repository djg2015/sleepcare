//
//  DatePickerView.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DatePickerView: UIView {

    var detegate:SelectDateEndDelegate!
    var datedelegate:SelectDateDelegate!
    
    var datePicker:UIDatePicker = UIDatePicker()
    var dateButton : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        var deviceWidth:CGFloat = devicebounds.width
        var deviceHeight:CGFloat = devicebounds.height
        var viewColor:UIColor = UIColor(white:0, alpha: 0.6)
        
        //设置日期弹出窗口
        self.backgroundColor = viewColor
        self.userInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .Date
        datePicker.locale = NSLocale(localeIdentifier: "Chinese")
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.frame = CGRect(x:(deviceWidth - 300)/2,y:100,width:300,height:220)
        
        //设置 确定 和 取消 按钮
        var li_common:Li_common = Li_common()
        var selectedButton:UIButton = li_common.Li_createButton("确定",x:(deviceWidth - 300)/2,y:312,width:150,height:35,target:self, action: Selector("selectedAction"))
        var cancelButton:UIButton = li_common.Li_createButton("取消",x:(deviceWidth - 300)/2 + 150,y:312,width:150,height:35,target:self, action: Selector("cancelAction"))
        
        self.addSubview(datePicker)
        self.addSubview(selectedButton)
        self.addSubview(cancelButton)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //选择日期
    func selectedAction(){
        var dateString:String = self.dateString(datePicker.date)
        dateButton.setTitle(dateString, forState: UIControlState.Normal)
        removeAlertview()
        if(self.detegate != nil){
            self.detegate.SelectDateEnd(self,dateString: dateString)
        }
        if(self.datedelegate != nil){
        self.datedelegate.SelectDate(self, dateString: dateString)
        
        }
    }
    
    func cancelAction(){
        removeAlertview()
       
    }
    
    func removeAlertview(){
        self.hidden = true
    }

    //返回2014-06-19格式的日期
    func dateString(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = dateFormatter.stringFromDate(date)
        return dateString
    }
}

protocol SelectDateEndDelegate{
    func SelectDateEnd(sender:UIView,dateString:String)
}

protocol SelectDateDelegate{
    func SelectDate(sender:UIView,dateString:String)
}
