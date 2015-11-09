//
//  THDate.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/9.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class THDate:NSObject,THDatePickerDelegate{
    var control:UIViewController!
    var curDate:NSDate?
     var datapicker:THDatePickerViewController?
    var returnformat:NSDateFormatter?
    var delegate:THDateChoosedDelegate?
    init(parentControl:UIViewController) {
        self.control = parentControl
         self.curDate = NSDate()
    }
    
    //显示日期
    func ShowDate(date:NSDate? = nil,returnformat:NSDateFormatter? = nil){
        if(self.datapicker == nil){
            self.datapicker = THDatePickerViewController()
        }
        if(date == nil){
            self.datapicker?.date = self.curDate
        }
        else{
            self.datapicker?.date = date
        }
        self.returnformat = returnformat
        self.datapicker?.delegate = self
        self.datapicker?.setAllowClearDate(false)
        self.datapicker?.setAutoCloseOnSelectDate(true)
        self.datapicker?.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        //[self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        self.datapicker?.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        self.datapicker?.setDateHasItemsCallback(DateHasItemsCallback)
        var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack:"NO",
            KNSemiModalOptionKeys.animationDuration:"1.0",KNSemiModalOptionKeys.shadowOpacity:"0.3"]
        self.control.presentSemiViewController(self.datapicker, withOptions: kNSemiModalOptionKeys)
    }
    
    func datePickerDonePressed(datePicker:THDatePickerViewController){
        self.control.dismissSemiModalView()
        self.curDate = datePicker.date;
        if(self.delegate != nil){
            if(self.returnformat == nil){
                self.returnformat = NSDateFormatter()
                self.returnformat?.dateFormat = "yyyy年MM月dd日"
            }
            self.delegate?.ChoosedDate(self.returnformat?.stringFromDate(self.curDate!))
        }
    }
    
    func datePickerCancelPressed(datePicker:THDatePickerViewController){
        self.control.dismissSemiModalView()
    }

    func DateHasItemsCallback(date:NSDate!) -> Bool{
        var tmp:Int = (Int)(arc4random() % 30) + 1
        if(tmp % 5 == 0){
            return true
        }
        return false
    }
}

protocol THDateChoosedDelegate{
    func ChoosedDate(choosedDate:String?)
}