//
//  MyDeviceViewModel.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import Foundation

class MyDeviceViewModel: BaseViewModel {
   var loginname=""
    
    var _deviceArray:Array<EquipmentTableCell>= Array<EquipmentTableCell>()
    dynamic var DeviceArray:Array<EquipmentTableCell>{
        get
        {
            return self._deviceArray
        }
        set(value)
        {
            self._deviceArray=value
        }
    }
    
    //构造函数
    override init(){
        super.init()
        
        LoadData()
    }

    
    func LoadData(){
        try {
            ({
              //从服务器获取设备列表
                self.loginname = SessionForSingle.GetSession()!.User!.LoginName
                let equipmentList:EquipmentList = SleepCareForSingle().GetEquipmentsByLoginName(self.loginname)
                let equipmentArray:Array<EquipmentInfo> = equipmentList.equipmentList
                
                //更新session的设备列表
                SessionForSingle.GetSession()!.EquipmentList = equipmentArray
                
                
                //赋值给设备的cellmodel
                var tempDeviceArray = Array<EquipmentTableCell>()
            
                for (var i = 0 ; i < equipmentArray.count; i++){
                    var tempDevice = EquipmentTableCell()
                    var info = equipmentArray[i]
                   
                    tempDevice.EquipmentCode = info.EquipmentID
                    tempDevice.EquipmentAddress = info.Address
                    tempDevice.UserGender = info.Sex
                    tempDevice.UserName = info.BedUserName
                    tempDevice.UserCode = info.BedUserCode
                    tempDevice.deleteDeviceHandler = self.DeleteDevice
                    tempDeviceArray.append(tempDevice)
                   
                }//for i
                
                self.DeviceArray = tempDeviceArray
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }

    //devicecell单个删除操作（滑动删除）
    func DeleteDevice(devicecell:EquipmentTableCell){
    //服务器端更新
        SleepCareForSingle().RemoveEquipment(self.loginname, equipmentIDs: devicecell.EquipmentCode)
       //如果删除的设备 为当前查看的设备，则更新session中cur值＝“”
        if devicecell.UserCode == SessionForSingle.GetSession()!.CurPatientCode{
          SessionForSingle.GetSession()?.CurPatientCode = ""
          SessionForSingle.GetSession()?.CurPatientName = ""
            
            PLISTHELPER.CurPatientCode = ""
            PLISTHELPER.CurPatientName = ""

        }
        
////        //source更新
//      for(var i = 0 ; i < self.DeviceArray.count; i++){
//        if self.DeviceArray[i].EquipmentCode == devicecell.EquipmentCode{
//        self.DeviceArray.removeAtIndex(i)
//            break
//        }
//        }
        //session里的equipmentlist，bedusercode更新
        var sessionEquipmentList:Array<EquipmentInfo> = SessionForSingle.GetSession()!.EquipmentList
        for(var i = 0 ; i < sessionEquipmentList.count; i++){
            if sessionEquipmentList[i].EquipmentID == devicecell.EquipmentCode{
                sessionEquipmentList.removeAtIndex(i)
                SessionForSingle.GetSession()!.EquipmentList = sessionEquipmentList
                break
            }
         }
        
        var sessionUsercodeList = SessionForSingle.GetSession()!.BedUserCodeList
        for(var i = 0 ; i < sessionUsercodeList.count; i++){
            if devicecell.UserCode == sessionUsercodeList[i]{
            sessionUsercodeList.removeAtIndex(i)
                SessionForSingle.GetSession()!.BedUserCodeList = sessionUsercodeList
            break
            }
        }
        
    }
    
}
