//
//  BedPatientCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class BedPatientCell: CommonTableCell {
    
    @IBOutlet weak var lblRoomNum: UILabel!
    @IBOutlet weak var lblBedNum: UILabel!
    @IBOutlet weak var lblBedUserName: UILabel!
    @IBOutlet weak var imgChecked: UIImageView!
    var source:BedPatientViewModel!
    var bindFlag:Bool = false
    override func CellLoadData(data:AnyObject){
        self.source = data as! BedPatientViewModel
        if(self.source!.IsChoosed){
            self.imgChecked.image = UIImage(named: "checked.png")
        }
        else{
            self.imgChecked.image = UIImage(named: "unchecked.png")
            
        }
        self.selectionStyle = UITableViewCellSelectionStyle.None
        if(!self.bindFlag){
            RACObserve(self.source, "RoomNum") ~> RAC(self.lblRoomNum, "text")
            RACObserve(self.source, "BedNum") ~> RAC(self.lblBedNum, "text")
            RACObserve(self.source, "BedUserName") ~> RAC(self.lblBedUserName, "text")
            self.bindFlag = true
        }
        
    }
    
    override func Checked(){
        self.imgChecked.image = UIImage(named: "checked.png")
        self.source!.IsChoosed = true
        if(self.source!.selectedPatientHandler != nil){
            self.source!.selectedPatientHandler!(bedPatientViewModel: self.source!)
        }
    }
    
    override func UnChechked(){
        self.imgChecked.image = UIImage(named: "unchecked.png")
        self.source!.IsChoosed = false
    }
}

class BedPatientViewModel:NSObject{
    //属性定义
    //场景编号名
    var _partCode:String?
    dynamic var PartCode:String?{
        get
        {
            return self._partCode
        }
        set(value)
        {
            self._partCode=value
        }
    }
    
    //场景名称
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
    //房间名
    var _roomNum:String?
    dynamic var RoomNum:String?{
        get
        {
            return self._roomNum
        }
        set(value)
        {
            self._roomNum=value
        }
    }
    
    //床位号
    var _bedNum:String?
    dynamic var BedNum:String?{
        get
        {
            return self._bedNum
        }
        set(value)
        {
            self._bedNum=value
        }
    }
    
    //床位用户编号
    var _bedUserCode:String?
    dynamic var BedUserCode:String?{
        get
        {
            return self._bedUserCode
        }
        set(value)
        {
            self._bedUserCode=value
        }
    }
    
    //床位用户姓名
    var _bedUserName:String?
    dynamic var BedUserName:String?{
        get
        {
            return self._bedUserName
        }
        set(value)
        {
            self._bedUserName=value
        }
    }
    
    
    //是否选中
    var _isChoosed:Bool = false
    dynamic var IsChoosed:Bool{
        get
        {
            return self._isChoosed
        }
        set(value)
        {
            self._isChoosed=value
        }
    }
    
    //操作定义
    var selectedPatientHandler: ((bedPatientViewModel:BedPatientViewModel) -> ())?
}

