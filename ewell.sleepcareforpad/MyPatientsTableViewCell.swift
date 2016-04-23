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
    //  @IBOutlet weak var imgDetail: UIImageView!
    
    @IBOutlet weak var lblMainName: UILabel!
    
    
    @IBOutlet weak var imgStatus: UIImageView!
  //  @IBOutlet weak var layerView: BackgroundCommon!
    
    var source:MyPatientsTableCellViewModel!
    var bindFlag:Bool = false
    
    var statusImageName:String?
        {
        didSet{
            if statusImageName != nil{
                self.imgStatus.image = UIImage(named:statusImageName!)
            }
        }
    }
    
    
    //数据绑定床位界面
    func CellLoadData(data:MyPatientsTableCellViewModel){
        self.source = MyPatientsTableCellViewModel()

        self.source.BedUserCode = (data as MyPatientsTableCellViewModel).BedUserCode
        self.source.BedUserName = (data as MyPatientsTableCellViewModel).BedUserName
        self.source.RoomNum = (data as MyPatientsTableCellViewModel).RoomNum
        self.source.BedNum = (data as MyPatientsTableCellViewModel).BedNum
        self.source.PartCode = (data as MyPatientsTableCellViewModel).PartCode
        //新增“院名 ”
        self.source.MainName = (data as MyPatientsTableCellViewModel).MainName
        
        self.source.PartName = (data as MyPatientsTableCellViewModel).PartName
        self.source.selectedBedUserHandler = (data as MyPatientsTableCellViewModel).selectedBedUserHandler
        self.source.deleteBedUserHandler = (data as MyPatientsTableCellViewModel).deleteBedUserHandler
        self.source.EquipmentID = (data as MyPatientsTableCellViewModel).EquipmentID
        
        RACObserve(self.source, "StatusImageName") ~> RAC(self, "statusImageName")
        RACObserve(data, "HR") ~> RAC(self.source, "HR")
        RACObserve(data, "RR") ~> RAC(self.source, "RR")
        RACObserve(data, "BedStatus") ~> RAC(self.source, "BedStatus")
      
         RACObserve(data, "BedNum") ~> RAC(self.source, "BedNum")
         RACObserve(data, "BedCode") ~> RAC(self.source, "BedCode")
         RACObserve(data, "BedUserName") ~> RAC(self.source, "BedUserName")
     
        RACObserve(self.source, "MainName") ~> RAC(self.lblMainName, "text")
        
        RACObserve(self.source, "PartName") ~> RAC(self.lblPartName, "text")
        RACObserve(self.source, "BedStatus") ~> RAC(self.lblBedStatus, "text")
        RACObserve(self.source, "HR") ~> RAC(self.lblHR, "text")
        RACObserve(self.source, "RR") ~> RAC(self.lblRR, "text")
        RACObserve(self.source, "BedNum") ~> RAC(self.lblBedNum, "text")
        RACObserve(self.source, "RoomNum") ~> RAC(self.lblRoomNum, "text")
        RACObserve(self.source, "BedUserName") ~> RAC(self.lblBedUserName, "text")
        
        //        if(!self.bindFlag){
        
        //
        //            //设置箭头点击查看明细
        //           self.imgDetail.userInteractionEnabled = true
        //           var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        //            self.imgDetail .addGestureRecognizer(singleTap)
        //            self.bindFlag = true
        //        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func imageViewTouch(){
        if(self.source.selectedBedUserHandler != nil){
            self.source.selectedBedUserHandler!(myPatientsTableViewModel: self.source)
        }
    }
    
}

class MyPatientsTableCellViewModel:NSObject{
    //属性定义
    //床位用户姓名
    var _mainName:String?
    dynamic var MainName:String?{
        get
        {
            return self._mainName
        }
        set(value)
        {
            self._mainName = value
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
    
    //床位编号
    var _bedCode:String?
    dynamic var BedCode:String?{
        get
        {
            return self._bedCode
        }
        set(value)
        {
            self._bedCode=value
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
            if(self._roomNum != nil){
                if(self._roomNum!.hasSuffix("室") == false){
                    return self._roomNum! + "室"
                }
            }
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
            if(self._bedNum != nil){
                if(self._bedNum!.hasSuffix("床") == false){
                    return self._bedNum! + "床"
                }
            }
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
            if(self._hr == nil){
                return ""
            }
            if(self._hr!.hasSuffix("次/分") == false){
                return self._hr! + "次/分"
            }
            return self._hr!
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
            if(self._rr == nil){
                return ""
            }
            if(self._rr!.hasSuffix("次/分") == false){
                return self._rr! + "次/分"
            }
            return self._rr!
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
            if value == "在床"{
                StatusImageName = "greenpoint.png"
            }
            else if value == "离床"{
                StatusImageName = "greypoint.png"
            }
            else if value == "请假"{
                StatusImageName = "lightgreenpoint.png"
            }
            else if value == "异常"{
                StatusImageName = "yellowpoint.png"
            }
            else if value == "空床"{
                StatusImageName = "lightgreenpoint.png"
            }
            else {
                self._bedStatus = "确认中"
                 StatusImageName = "yellowpoint.png"
            }
        }
    }
    
    // 设备编号
    var _equipmentID:String?
    dynamic var EquipmentID:String?{
        get
        {
            return self._equipmentID
        }
        set(value)
        {
            self._equipmentID=value
        }
    }
    
    var _statusImageName:String?
    dynamic var StatusImageName:String?{
        get
        {
            return self._statusImageName
        }
        set(value)
        {
            self._statusImageName=value
        }
    }
    
    //操作定义
    var selectedBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    var deleteBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    
}
