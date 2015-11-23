//
//  IEquipmentViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/20.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IEquipmentViewModel: BaseViewModel {
    
    // 设备ID
    var _equipmentID:String?
    dynamic var EquipmentID:String?{
        get
        {
            return self._equipmentID
        }
        set(value)
        {
            self._equipmentID = value
            var sleepCareForIPhoneBLL = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
            var equipmentInfo:IEquipmentInfo = sleepCareForIPhoneBLL.GetEquipmentInfo(self._equipmentID!)
            self.Status = equipmentInfo.Status
        }
    }
    
    var _status:String?
    dynamic var Status:String?{
        get
        {
            return self._status
        }
        set(value)
        {
            self._status = value
        }
    }
}