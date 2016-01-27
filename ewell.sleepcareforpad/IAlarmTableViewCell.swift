//
//  IAlarmTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import UIKit

class IAlarmTableViewCell:MSCMoreOptionTableViewCell,MSCMoreOptionTableViewCellDelegate {
    
    @IBOutlet weak var lblPartName: UILabel!
    @IBOutlet weak var lblBedNumber: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtAlarmContent: UITextView!
    
    var source:IAlarmTableCellViewModel!
    var moreoptionDelegate:MoreOptionDelegate!
    
    func CellLoadData(data:IAlarmTableCellViewModel){
        self.delegate = self
        //self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 125)
        source = IAlarmTableCellViewModel()
        source.AlarmCode = data.AlarmCode
        source.AlarmDate = data.AlarmDate
        source.PartName = data.PartName
        source.BedNumber = data.BedNumber
        source.UserName = data.UserName
        source.AlarmContent = data.AlarmContent
        source.deleteAlarmHandler = data.deleteAlarmHandler
        source.moreAlarmHandler = data.moreAlarmHandler
        RACObserve(self.source, "AlarmDate") ~> RAC(self.lblDate,"text")
        RACObserve(self.source, "PartName") ~> RAC(self.lblPartName,"text")
        RACObserve(self.source, "UserName") ~> RAC(self.lblUserName,"text")
        RACObserve(self.source, "BedNumber") ~> RAC(self.lblBedNumber,"text")
        RACObserve(self.source, "AlarmContent") ~> RAC(self.txtAlarmContent,"text")
        
    }
    
    func tableView(tableView:UITableView,titleForMoreOptionButtonForRowAtIndexPath indexPath:NSIndexPath)->String{
        return "处理"
    }
    //点击“处理”
    func tableView(tableView:UITableView, moreOptionButtonPressedInRowAtIndexPath indexPath:NSIndexPath){
      
        self.source.moreAlarmHandler!(alarmViewModel: self.source)
        IAlarmHelper.GetAlarmInstance().Warningcouts = IAlarmHelper.GetAlarmInstance().Warningcouts - 1
        if self.moreoptionDelegate != nil{
        self.moreoptionDelegate.MoreOption(indexPath)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


class IAlarmTableCellViewModel:NSObject{
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
    var _partName:String?
    dynamic var PartName:String?{
        get
        {
            return self._partName
        }
        set(value)
        {
            self._partName=value
        }
    }
    var _userName:String?
    dynamic var UserName:String?{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName=value
        }
    }
    
    var _bedNumber:String?
    dynamic var BedNumber:String?{
        get
        {
            return self._bedNumber
        }
        set(value)
        {
            self._bedNumber=value
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
    var moreAlarmHandler:((alarmViewModel:IAlarmTableCellViewModel) -> ())?
}


protocol MoreOptionDelegate{
func MoreOption(indexPath:NSIndexPath)
}
