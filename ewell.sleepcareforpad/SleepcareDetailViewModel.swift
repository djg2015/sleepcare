//
//  SleepcareDetailViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/19.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareDetailViewModel: BaseViewModel {
    //初始化
    override init() {
        super.init()
    }
    
    //属性定义
    //深睡时长
    var _deepSleepSpan:String?
    dynamic var DeepSleepSpan:String?{
        get
        {
            return self._deepSleepSpan
        }
        set(value)
        {
            self._deepSleepSpan=value
        }
    }

    //浅睡时长
    var _lightSleepSpan:String?
    dynamic var LightSleepSpan:String?{
        get
        {
            return self._lightSleepSpan
        }
        set(value)
        {
            self._lightSleepSpan=value
        }
    }
}
