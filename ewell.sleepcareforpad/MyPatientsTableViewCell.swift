//
//  SleepCareTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class MyPatientsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblBedStatus: UILabel!
    @IBOutlet weak var lblHR: UILabel!
    @IBOutlet weak var lblRR: UILabel!
    @IBOutlet weak var lblBedNum: UILabel!
    @IBOutlet weak var lblRoomNum: UILabel!
    @IBOutlet weak var lblBedUserName: UILabel!
 @IBOutlet weak var imgSex: UIImageView!
    @IBOutlet weak var imgStatus: UIImageView!

    
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
       self.source.Sex = (data as MyPatientsTableCellViewModel).Sex
          self.source.EquipmentID = (data as MyPatientsTableCellViewModel).EquipmentID
        
        
        self.source.selectedBedUserHandler = (data as MyPatientsTableCellViewModel).selectedBedUserHandler
        self.source.deleteBedUserHandler = (data as MyPatientsTableCellViewModel).deleteBedUserHandler
      
        
      
        RACObserve(data, "HR") ~> RAC(self.source, "HR")
        RACObserve(data, "RR") ~> RAC(self.source, "RR")
        RACObserve(data, "BedStatus") ~> RAC(self.source, "BedStatus")
         RACObserve(data, "BedNum") ~> RAC(self.source, "BedNum")
         RACObserve(data, "BedCode") ~> RAC(self.source, "BedCode")
         RACObserve(data, "BedUserName") ~> RAC(self.source, "BedUserName")
         RACObserve(data, "Sex") ~> RAC(self.source, "Sex")
       
     
       
        RACObserve(self.source, "BedStatus") ~> RAC(self.lblBedStatus, "text")
        RACObserve(self.source, "HR") ~> RAC(self.lblHR, "text")
        RACObserve(self.source, "RR") ~> RAC(self.lblRR, "text")
        RACObserve(self.source, "BedNum") ~> RAC(self.lblBedNum, "text")
        RACObserve(self.source, "RoomNum") ~> RAC(self.lblRoomNum, "text")
        RACObserve(self.source, "BedUserName") ~> RAC(self.lblBedUserName, "text")
         RACObserve(self.source, "SexImg") ~> RAC(self.imgSex, "image")
        
       
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    
}

class MyPatientsTableCellViewModel:NSObject{
    //属性定义
    
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

    
    //房间号
    var _roomNum:String?
    dynamic var RoomNum:String?{
        get
        {
            if(self._roomNum != nil){
                if(self._roomNum!.hasSuffix("房") == false){
                    return self._roomNum! + "房"
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
                
                    return self._bedNum!
                
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
        }
    }
    
  
    //报警图片显示,默认隐藏（true），有报警时显示图片（false）
    var _ishiddenAlarm:Bool=true
    dynamic var IshiddenAlarm:Bool{
        get
        {
            return self._ishiddenAlarm
        }
        set(value)
        {
            self._ishiddenAlarm=value
        }
    }
    
    // 性别
    var _sex:String?
    dynamic var Sex:String?{
        get
        {
            return self._sex
        }
        set(value)
        {
            self._sex=value
            if (self._sex == "0"){
            self._sexImg?.image = UIImage(named: "icon_male_")
            }
            else if(self._sex == "1"){
                self._sexImg?.image = UIImage(named: "icon_female_")
            }
            else{
             self._sexImg?.image = nil
            }
        }
    }
    var _sexImg:UIImageView?
    dynamic var SexImg:UIImageView?{
        get
        {
            return self._sexImg
        }
        set(value)
        {
            self._sexImg=value
           
        }
    }

    
        
    //-----------------------------------------------------
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
    
    
    //操作定义
    var selectedBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    var deleteBedUserHandler: ((myPatientsTableViewModel:MyPatientsTableCellViewModel) -> ())?
    
}
