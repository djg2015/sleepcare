//
//  DialogFrameController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//内页弹窗框架界面
class DialogFrameController: BaseViewController,UIScrollViewDelegate,JumpPageDelegate {
    //界面控件
    @IBOutlet weak var curPage: Pager!
    
    //类字段
    var mainScroll:UIScrollView!
    
    //界面初始设置
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainScroll = UIScrollView()
        
        self.mainScroll.backgroundColor = UIColor.clearColor()
        self.mainScroll.frame = self.view.frame
        self.mainScroll.frame.origin.y = 58
        self.mainScroll.frame.size.height = 660
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = false
        self.mainScroll.delegate = self
        self.mainScroll.bounces = false
        self.view.addSubview(self.mainScroll)
        
        self.mainScroll.contentSize = CGSize(width: self.view.bounds.size.width * 3, height: 660)
        
        //加载弹窗的界面
        //睡眠质量列表
        let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepcareList", owner: self, options: nil).last as! SleepCareListView
        mainview1.frame = CGRectMake(0, 0, 1024, self.mainScroll.frame.size.height)
        self.mainScroll.addSubview(mainview1)
        self.mainScroll.bringSubviewToFront(mainview1)

        //监测日志
        let mainview2 = NSBundle.mainBundle().loadNibNamed("SleepcareList", owner: self, options: nil).last as! SleepCareListView
        mainview2.frame = CGRectMake(1024, 0, 1024, self.mainScroll.frame.size.height)
        mainview2.backgroundColor = UIColor.greenColor()
        self.mainScroll.addSubview(mainview2)
        self.mainScroll.bringSubviewToFront(mainview2)
        
        //报警日志
        let mainview3 = NSBundle.mainBundle().loadNibNamed("AlarmView", owner: self, options: nil).last as! AlarmView
        println(self.mainScroll.frame.size.height)
        mainview3.frame = CGRectMake(1024*2, 0, 1024, self.mainScroll.frame.size.height)
        mainview3.backgroundColor = UIColor.whiteColor()
        mainview3.viewLoaded();
        self.mainScroll.addSubview(mainview3)
        self.mainScroll.bringSubviewToFront(mainview3)
        
        //设置分页控件
        self.curPage.pageCount = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func JumpPage(pageIndex:NSInteger){
        
    }
}
