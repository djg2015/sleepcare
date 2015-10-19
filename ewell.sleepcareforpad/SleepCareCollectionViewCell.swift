//
//  SleepCareCollectionViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/28.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//床位控件
class SleepCareCollectionViewCell: UICollectionViewCell {
    var bedNumber:UILabel!
    
    //界面控件
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgBedStatus: UIImageView!
    @IBOutlet weak var lblRoomNumber: UILabel!
    @IBOutlet weak var lblHR: UILabel!
    @IBOutlet weak var lblRR: UILabel!
    @IBOutlet weak var lblBedNumber: UILabel!
    @IBOutlet weak var imgBed: UIImageView!
    @IBOutlet weak var imgHeadView: UIImageView!
    
    //类字段
    var _bindModel:BedModel?
    
    //汇至床位界面
    func rebuilderUserInterface(bedModel:BedModel){
        self._bindModel = bedModel
        RACObserve(self._bindModel, "RoomNumber") ~> RAC(self.lblRoomNumber, "text")
        RACObserve(self._bindModel, "UserName") ~> RAC(self.lblUserName, "text")
        RACObserve(self._bindModel, "BedNumber") ~> RAC(self.lblBedNumber, "text")
        RACObserve(self._bindModel, "HR") ~> RAC(self.lblHR, "text")
        RACObserve(self._bindModel, "RR") ~> RAC(self.lblRR, "text")
        RACObserve(self._bindModel, "BedImageStatus") ~> RAC(self.imgBedStatus, "image")
        RACObserve(self._bindModel, "BedImage") ~> RAC(self.imgBed, "image")
        RACObserve(self._bindModel, "HeadImageView") ~> RAC(self.imgHeadView, "image")
        self.backgroundColor = UIColor.clearColor()
    }
    
}

class BedModel:NSObject{
    //属性定义
    //床位用户名
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
    
    //房间号
    var _roomNumber:String?
    dynamic var RoomNumber:String?{
        get
        {
            return self._roomNumber
        }
        set(value)
        {
            self._roomNumber=value
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
    
    //床位号
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
    
    //心率
    var _hr:String = "0"
    dynamic var HR:String{
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
    var _rr:String = "0"
    dynamic var RR:String{
        get
        {
            return self._rr
        }
        set(value)
        {
            self._rr=value
        }
    }
    
    //在离床显示
    var _bedImage:UIImage?
    dynamic var BedImage:UIImage?{
        get
        {
            return self._bedImage
        }
        set(value)
        {
            self._bedImage=value
        }
    }
    
    //在离床状态显示
    var _bedImageStatus:UIImage?
    dynamic var BedImageStatus:UIImage?{
        get
        {
            return self._bedImageStatus
        }
        set(value)
        {
            self._bedImageStatus=value
        }
    }
    
    //在离床状态头部显示
    var _headImageView:UIImage?
    dynamic var HeadImageView:UIImage?{
        get
        {
            return self._headImageView
        }
        set(value)
        {
            self._headImageView=value
        }
    }
    
    //在离床状态
    var _bedStatus:BedStatusType = BedStatusType.unline
    var BedStatus:BedStatusType{
        get
        {
            return self._bedStatus
        }
        set(value)
        {
            //在床
            if(value == BedStatusType.onbed){
                self.HeadImageView = UIImage(named: "infoHeadblue.png")
                self.BedImageStatus = UIImage(named: "onBedView.png")
                self.BedImage = UIImage(named: "onBed.png")
            }
                //离床
            else if(value == BedStatusType.leavebed){
                self.HeadImageView = UIImage(named: "infoHeadred.png")
                self.BedImageStatus = UIImage(named: "leaveView.png")
                self.BedImage = UIImage(named: "leaveBed.png")
            }
            else{
                self.HeadImageView = UIImage(named: "infoHead.png")
                self.BedImageStatus = UIImage(named: "unlineView.png")
                self.BedImage = UIImage(named: "emptyBed.png")
            }
            
            self._bedStatus=value
        }
    }
}

enum BedStatusType{
    case onbed
    case leavebed
    case unline
}