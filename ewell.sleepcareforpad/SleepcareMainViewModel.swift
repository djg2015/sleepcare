//
//  SleepcareMainViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainViewModel:NSObject {
    //初始化
    override init() {
        super.init()
        var beds = Array<BedModel>()
        try {
            ({
                
                let testBLL = SleepCareBussiness()
                //获取医院下的床位信息
                var partInfo:PartInfo = testBLL.GetPartInfoByPartCode("00001", searchType: "", searchContent: "", from: 1, max: 30)
                var beds = Array<BedModel>()
                for(var i = 0;i < partInfo.BedList.count; i++) {
                    var bed = BedModel()
                    bed.UserName = partInfo.BedList[i].UserName
                    bed.RoomNumber = partInfo.BedList[i].RoomNumber
                    bed.BedCode = partInfo.BedList[i].BedCode
                    bed.BedNumber = partInfo.BedList[i].BedNumber
                    beds.append(bed)
                }
                self.BedModelList = beds
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
    }
    
    //属性定义
    //医院/养老院名称
    var _mainName:String?
    dynamic var MainName:String?{
        get
        {
            return self._mainName
        }
        set(value)
        {
            self._mainName=value
        }
    }
    
    //当前时间
    var _curTime:String?
    dynamic var CurTime:String?{
        get
        {
            return self._curTime
        }
        set(value)
        {
            self._curTime=value
        }
    }
    
    //楼层号
    var _floorName:String?
    dynamic var FloorName:String?{
        get
        {
            return self._floorName
        }
        set(value)
        {
            self._floorName=value
        }
    }
    
    //房间总数
    var _roomCount:String?
    dynamic var RoomCount:String?{
        get
        {
            return self._roomCount
        }
        set(value)
        {
            self._roomCount=value
        }
    }
    
    //床位总数
    var _bedCount:String?
    dynamic var BedCount:String?{
        get
        {
            return self._bedCount
        }
        set(value)
        {
            self._bedCount=value
        }
    }
    
    //绑定的床位总数
    var _bindBedCount:String?
    dynamic var BindBedCount:String?{
        get
        {
            return self._bindBedCount
        }
        set(value)
        {
            self._bindBedCount=value
        }
    }
    
    //查询类型
    var _searchType:String?
    dynamic var SearchType:String?{
        get
        {
            return self._searchType
        }
        set(value)
        {
            self._searchType=value
        }
    }
    
    //查询内容
    var _searchTypeContent:String?
    dynamic var SearchTypeContent:String?{
        get
        {
            return self._searchTypeContent
        }
        set(value)
        {
            self._searchTypeContent=value
        }
    }
    
    //床位集合
    var _bedModelList:Array<BedModel> = []
    dynamic var BedModelList:Array<BedModel>{
        get
        {
            return self._bedModelList
        }
        set(value)
        {
            self._bedModelList=value
        }
    }
    
    //分页数
    var _pageCount:Int = 0
    dynamic var PageCount:Int{
        get
        {
            return self._pageCount
        }
        set(value)
        {
            self._pageCount=value
        }
    }
    
    //界面命令
    
    
    
    
    //自定义事件
}
