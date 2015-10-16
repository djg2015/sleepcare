//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainController: BaseViewController,UIScrollViewDelegate,UISearchBarDelegate {
    //界面控件
    @IBOutlet weak var curPager: Pager!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var lblMainName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblPart: UILabel!
    @IBOutlet weak var lblRoomCount: UILabel!
    @IBOutlet weak var lblBedCount: UILabel!
    @IBOutlet weak var lblBindBedCount: UILabel!
    @IBOutlet weak var txtSearchType: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    //类字段
    var mainScroll:UIScrollView!
    var sleepcareMainViewModel:SleepcareMainViewModel?
    var BedViews:Array<BedModel>?{
        didSet{
            let pageCount:Int = (self.BedViews!.count / 8) + ((self.BedViews!.count % 8) > 0 ? 1 : 0)
            self.sleepcareMainViewModel?.PageCount = pageCount
            self.mainScroll.contentSize = CGSize(width: self.view.bounds.size.width * CGFloat(pageCount), height: 500)
            
            for i in 1...pageCount{
                let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).last as! SleepCareCollectionView
                mainview1.frame = CGRectMake(CGFloat((i-1) * 1024), 0, 1024, self.mainScroll.frame.size.height)
                mainview1.didSelecteBedHandler = self.BedSelected
                var bedList = self.sleepcareMainViewModel?.GetBedsOfPage(i, count: 8)
                mainview1.reloadData(bedList!)
                self.mainScroll.addSubview(mainview1)
                self.mainScroll.bringSubviewToFront(mainview1)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScroll = UIScrollView()
        
        self.mainScroll.backgroundColor = UIColor.clearColor()
        self.mainScroll.frame = self.view.frame
        self.mainScroll.frame.origin.y = 170
        self.mainScroll.frame.size.height = 500
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = false
        self.mainScroll.delegate = self
        self.mainScroll.bounces = false
        self.view.addSubview(self.mainScroll)
        
        
        //去掉搜索按钮背景
        //self.search.backgroundColor = UIColor(patternImage: UIImage(named:"transbg.png")!)
        for(var i = 0 ; i < self.search.subviews[0].subviews.count; i++) {
            if(self.search.subviews[0].subviews[i].isKindOfClass(NSClassFromString("UISearchBarBackground"))){
                self.search.subviews[0].subviews[i].removeFromSuperview()
            }
        }
        self.search.delegate = self
        rac_setting()
    }
    
    //查询按钮事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
    }
    
    //床位点击事件
    func BedSelected(bedModel:BedModel){
        try {
            ({
                //正常业务处理
                self.presentViewController(DialogFrameController(nibName:"DialogFrame", bundle:nil), animated: true, completion: nil)
                //抛出异常
                //throw("0", "账户名不存在")
                },
                catch: { ex in
                    //异常处理
                    println(ex)
                },
                finally: {
                    
                }
            )}
        
    }
    
    //属性绑定
    func rac_setting(){
        sleepcareMainViewModel = SleepcareMainViewModel()
        RACObserve(self.sleepcareMainViewModel, "BedModelList") ~> RAC(self, "BedViews")
        RACObserve(self.sleepcareMainViewModel, "PageCount") ~> RAC(self.curPager, "pageCount")
        RACObserve(self.sleepcareMainViewModel, "MainName") ~> RAC(self.lblMainName, "text")
        RACObserve(self.sleepcareMainViewModel, "CurTime") ~> RAC(self.lblDateTime, "text")
        RACObserve(self.sleepcareMainViewModel, "FloorName") ~> RAC(self.lblPart, "text")
        RACObserve(self.sleepcareMainViewModel, "RoomCount") ~> RAC(self.lblRoomCount, "text")
        RACObserve(self.sleepcareMainViewModel, "BedCount") ~> RAC(self.lblBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "BindBedCount") ~> RAC(self.lblBindBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "SearchType") ~> RAC(self.txtSearchType, "text")
        self.btnLogout!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.presentViewController(LoginController(nibName:"LoginView", bundle:nil), animated: true, completion: nil)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func TestDate() -> Array<BedModel> {
        var data:Array<BedModel> = Array<BedModel>()
        var item1 = BedModel()
        item1.BedCode = "001"
        item1.BedNumber = "1"
        item1.UserName = "张三"
        item1.RoomNumber = "1"
        item1.HR = "79"
        
        data.append(item1)
        
        var item2 = BedModel()
        item2.BedCode = "002"
        item2.BedNumber = "2"
        item2.UserName = "李四"
        item2.RoomNumber = "1"
        item2.HR = "86"
        
        data.append(item2)
        
        var item3 = BedModel()
        item3.BedCode = "002"
        item3.BedNumber = "3"
        item3.UserName = "李四"
        item3.RoomNumber = "1"
        item3.HR = "86"
        data.append(item3)
        
        var item4 = BedModel()
        item4.BedCode = "002"
        item4.BedNumber = "4"
        item4.UserName = "李四"
        item4.RoomNumber = "1"
        item4.HR = "86"
        data.append(item4)
        
        var item5 = BedModel()
        item5.BedCode = "002"
        item5.BedNumber = "5"
        item5.UserName = "李四"
        item5.RoomNumber = "1"
        item5.HR = "86"
        data.append(item5)
        return data
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
