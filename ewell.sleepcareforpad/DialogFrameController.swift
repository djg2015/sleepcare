//
//  DialogFrameController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//内页弹窗框架界面
class DialogFrameController: BaseViewController,UIScrollViewDelegate,JumpPageDelegate,SelectDateEndDelegate {
    //界面控件
    @IBOutlet weak var curPage: Pager!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //类字段
    var mainScroll:UIScrollView!
    var _userCode:String = ""
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(nibName nibNameOrNil: String?, userCode:String) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self._userCode = userCode
    }
    
    var sleepCareDetail:SleepCareDetail?
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
        self.curPage.detegate = self
        //加载弹窗的界面
        //睡眠质量列表
        let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepcareDetail", owner: self, options: nil).first as! SleepCareDetail
        mainview1.frame = CGRectMake(0, 0, 1024, self.mainScroll.frame.size.height)
        mainview1.viewInit(self._userCode)
        self.mainScroll.addSubview(mainview1)
        self.mainScroll.bringSubviewToFront(mainview1)
        sleepCareDetail = mainview1
        //睡眠质量总览
        let mainview2 = NSBundle.mainBundle().loadNibNamed("SleepQualityPandect", owner: self, options: nil).first as! SleepQualityPandectView
        mainview2.frame = CGRectMake(1024, 0, 1024, self.mainScroll.frame.size.height)
        mainview2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 0.5)
        mainview2.viewInit(self._userCode)
        self.mainScroll.addSubview(mainview2)
        self.mainScroll.bringSubviewToFront(mainview2)
        
        //监测日志
        let mainview3 = NSBundle.mainBundle().loadNibNamed("AlarmView", owner: self, options: nil).first as! AlarmView
        mainview3.frame = CGRectMake(1024*2, 0, 1024, self.mainScroll.frame.size.height)
        mainview3.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 0.5)
        mainview3.viewLoaded(self._userCode);
        self.mainScroll.addSubview(mainview3)
        self.mainScroll.bringSubviewToFront(mainview3)
        
        //设置分页控件
        self.curPage.pageCount = 3
        var d = Date(string: getCurrentTime("yyyy-MM-dd"))
        d = d.addDays(-1)
        self.lblDate.text = d.description(format: "yyyy-MM-dd")
        
        self.imgDate.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgDate .addGestureRecognizer(singleTap)
        
    }
    
    //点击日历查询类型
    func imageViewTouch(){
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        
        //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:devicebounds)
        alertview.detegate = self
        self.view.addSubview(alertview)
    }
    
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        self.lblDate.text = dateString
        self.sleepCareDetail!.ReloadView(dateString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.contentOffset.x == 0)
        {
            self.JumpPage(1)
        }
        else if(scrollView.contentOffset.x == scrollView.frame.width)
        {
            self.JumpPage(2)
        }
        else if(scrollView.contentOffset.x == scrollView.frame.width*2)
        {
            self.JumpPage(3)
        }
    }
    
    func JumpPage(pageIndex:NSInteger){
        if(pageIndex == 1)
        {
            self.lblTitle.text = "睡眠质量明细"
            self.mainScroll.contentOffset.x = 0
            self.imgDate.hidden = false
            self.lblDate.hidden = false
        }
        else if(pageIndex == 2)
        {
            self.lblTitle.text = "睡眠质量总览"
            self.mainScroll.contentOffset.x = self.mainScroll.frame.width
            self.imgDate.hidden = true
            self.lblDate.hidden = true
        }
        else
        {
            self.lblTitle.text = "监测日志"
            self.mainScroll.contentOffset.x = self.mainScroll.frame.width * 2
            self.imgDate.hidden = true
            self.lblDate.hidden = true
        }
        
        for page in self.curPage.subviews
        {
            if(page.tag == pageIndex)
            {
                page.setBackgroundImage(UIImage(named: "pagerselected"), forState:.Normal)
            }
            else
            {
                page.setBackgroundImage(UIImage(named: "pagerunselected"), forState:.Normal)
            }
        }
        
    }
}
