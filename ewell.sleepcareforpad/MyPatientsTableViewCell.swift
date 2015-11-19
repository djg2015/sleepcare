//
//  SleepCareTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class MyPatientsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPartName: UILabel!
    @IBOutlet weak var lblBedStatus: UILabel!
    @IBOutlet weak var lblHR: UILabel!
    @IBOutlet weak var lblRR: UILabel!
    @IBOutlet weak var lblBedNum: UILabel!
    @IBOutlet weak var lblRoomNum: UILabel!
    @IBOutlet weak var lblBedUserName: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    var source:MyPatientsTableCellViewModel!
    var bindFlag:Bool = false
    
    
    //数据绑定床位界面
    func CellLoadData(data:MyPatientsTableCellViewModel){
        self.source = MyPatientsTableCellViewModel()
        
        self.source.BedUserCode = (data as MyPatientsTableCellViewModel).BedUserCode
        self.source.BedUserName = (data as MyPatientsTableCellViewModel).BedUserName
        self.source.RoomNum = (data as MyPatientsTableCellViewModel).RoomNum
        self.source.BedNum = (data as MyPatientsTableCellViewModel).BedNum
        self.source.PartCode = (data as MyPatientsTableCellViewModel).PartCode
        self.source.PartName = (data as MyPatientsTableCellViewModel).PartName
        
        RACObserve(data, "HR") ~> RAC(self.source, "HR")
        RACObserve(data, "RR") ~> RAC(self.source, "RR")
        RACObserve(data, "BedStatus") ~> RAC(self.source, "BedStatus")
        
        RACObserve(self.source, "PartName") ~> RAC(self.lblPartName, "text")
        RACObserve(self.source, "BedStatus") ~> RAC(self.lblBedStatus, "text")
        RACObserve(self.source, "HR") ~> RAC(self.lblHR, "text")
        RACObserve(self.source, "RR") ~> RAC(self.lblRR, "text")
        RACObserve(self.source, "BedNum") ~> RAC(self.lblBedNum, "text")
        RACObserve(self.source, "RoomNum") ~> RAC(self.lblRoomNum, "text")
        RACObserve(self.source, "BedUserName") ~> RAC(self.lblBedUserName, "text")
        
        if(!self.bindFlag){
            
            
            //设置箭头点击查看明细
            self.imgDetail.userInteractionEnabled = true
            var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
            self.imgDetail .addGestureRecognizer(singleTap)
            
            self.bindFlag = true
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func imageViewTouch(){
        if(self.source.selectedBedUserHandler != nil){
            self.source.selectedBedUserHandler!(myPatientsTableViewModel: self.source)
        }
    }
}

class MyPatientsTableCellViewModel:NSObject{
    //属性定义
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
    
    //场景编号
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
    
    //房间号
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
    
    //心率
    var _hr:String?
    dynamic var HR:String?{
        get
        {
            return self._hr
        }
        set(value)
        {
            self._hr=value
        }
    }
    
    //呼吸
    var _rr:String?
    dynamic var RR:String?{
        get
        {
            return self._rr
        }
        set(value)
        {
            self._rr=value
        }
    }
    
    //在离床状态
    var _bedStatus:String?
    dynamic var BedStatus:String?{
        get
        {
            return self._bedStatus
        }
        set(value)
        {
            self._bedStatus=value
        }
    }
    
    //操作定义
    var selectedBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    var deleteBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    
}
