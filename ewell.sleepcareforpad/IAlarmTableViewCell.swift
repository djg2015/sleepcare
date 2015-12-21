//
//  IAlarmTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import UIKit

class IAlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblAlarmCode: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtAlarmContent: UITextView!
   var source = IAlarmTableCellViewModel()

    func CellLoadData(data:IAlarmTableCellViewModel){
       
        source.AlarmDate = data.AlarmDate
        source.AlarmCode = data.AlarmCode
        source.AlarmContent = data.AlarmContent
        source.deleteAlarmHandler = data.deleteAlarmHandler
      //  RACObserve(self.source, "PartName") ~> RAC(self.lblDate,"text")

        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


class IAlarmTableCellViewModel{
    //属性定义
    var _alarmDate:String?
    dynamic var AlarmDate:String?{
        get
        {
            return self._alarmDate
        }
        set(value)
        {
            self._alarmDate=value
        }
    }
    
    var _alarmCode:String?
    dynamic var AlarmCode:String?{
        get
        {
            return self._alarmCode
        }
        set(value)
        {
            self._alarmCode=value
        }
    }
    var _alarmContent:String?
    dynamic var AlarmContent:String?{
        get
        {
            return self._alarmContent
        }
        set(value)
        {
            self._alarmContent=value
        }
    }
    
    //操作定义
    var deleteAlarmHandler: ((alarmViewModel:IAlarmTableCellViewModel) -> ())?
    
}



