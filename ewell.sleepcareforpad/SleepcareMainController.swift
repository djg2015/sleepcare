//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class SleepcareMainController: BaseViewController,UIScrollViewDelegate,UISearchBarDelegate,JumpPageDelegate,ChoosePartDelegate {
    //界面控件
    @IBOutlet weak var curPager: Pager!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var lblMainName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblPart: UILabel!
    @IBOutlet weak var lblRoomCount: UILabel!
    @IBOutlet weak var lblBedCount: UILabel!
    @IBOutlet weak var lblBindBedCount: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtSearchChoosed: UITextField!
    @IBOutlet weak var uiWariningShow: UIView!
    @IBOutlet weak var lblWarining: UILabel!
    
    @IBOutlet weak var btnRefresh: UIButton!
    //类字段
    var popDownList:PopDownList?
    var partDownList:PopDownList?
    var mainScroll:UIScrollView!
    var sleepcareMainViewModel:SleepcareMainViewModel?
    var choosepart:ChooseMainhouseController?
    
  
    //当前科室下所有床位信息
    var BedViews:Array<BedModel>?{
        didSet{
            for(var i = 0 ; i < self.mainScroll.subviews.count; i++) {
                self.mainScroll.subviews[i].removeFromSuperview()
            }
            let pageCount:Int = (self.BedViews!.count / 8) + ((self.BedViews!.count % 8) > 0 ? 1 : 0)
            self.sleepcareMainViewModel?.PageCount = pageCount
            self.mainScroll.contentSize = CGSize(width: self.view.bounds.size.width * CGFloat(pageCount), height: 500)
            self.mainScroll.contentOffset.x = 0
            if(pageCount > 0){
                for i in 1...pageCount{
                    let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).first as! SleepCareCollectionView
                    mainview1.frame = CGRectMake(CGFloat((i-1) * 1024) + 10, 0, 1024, self.mainScroll.frame.size.height)
                    mainview1.didSelecteBedHandler = self.BedSelected
                    var bedList = self.sleepcareMainViewModel?.GetBedsOfPage(i, count: 8)
                    mainview1.reloadData(bedList!)
                    self.mainScroll.addSubview(mainview1)
                    self.mainScroll.bringSubviewToFront(mainview1)
                }
            }
         
            
        }
    }
    
    var WarningSet:Int = 0{
        didSet{
            if(self.WarningSet > 0){
                self.uiWariningShow.hidden = false
                self.lblWarining.text = "当前有" + self.WarningSet.description + "条报警未处理,请点击查看"
            }
            else{
                self.uiWariningShow.hidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScroll = UIScrollView()
        self.mainScroll.backgroundColor = UIColor.clearColor()
        self.mainScroll.frame = self.view.frame
        self.mainScroll.frame.origin.y = 170
        self.mainScroll.frame.size.height = 600
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
        self.curPager.detegate = self

        rac_setting()
    }
    
    //查询按钮事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.sleepcareMainViewModel?.SearchByBedOrRoom(searchText)
    }
    
    //床位点击事件
    func BedSelected(bedModel:BedModel){
        try {
            ({
                //正常业务处理
                self.presentViewController(DialogFrameController(nibName: "DialogFrame", userCode: bedModel.UserCode!), animated: true, completion: nil)
                },
                catch: { ex in
                    //异常处理
                   
                },
                finally: {
                    
                }
            )}
        
    }
    
    //属性绑定
    func rac_setting(){
        sleepcareMainViewModel = SleepcareMainViewModel()
        sleepcareMainViewModel?.controller = self
        RACObserve(self.sleepcareMainViewModel, "BedModelList") ~> RAC(self, "BedViews")
        RACObserve(self.sleepcareMainViewModel, "PageCount") ~> RAC(self.curPager, "pageCount")
        RACObserve(self.sleepcareMainViewModel, "MainName") ~> RAC(self.lblMainName, "text")
        RACObserve(self.sleepcareMainViewModel, "CurTime") ~> RAC(self.lblDateTime, "text")
        RACObserve(self.sleepcareMainViewModel, "FloorName") ~> RAC(self.lblPart, "text")
        RACObserve(self.sleepcareMainViewModel, "RoomCount") ~> RAC(self.lblRoomCount, "text")
        RACObserve(self.sleepcareMainViewModel, "BedCount") ~> RAC(self.lblBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "BindBedCount") ~> RAC(self.lblBindBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "ChoosedSearchType") ~> RAC(self.txtSearchChoosed, "text")
        RACObserve(self.sleepcareMainViewModel, "WariningCount") ~> RAC(self, "WarningSet")
        
        //退出登录
        self.btnLogout!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.sleepcareMainViewModel?.CloseWaringAttention()
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                xmppMsgManager?.Close()
                Session.ClearSession()
                //关闭页面，退回到login页面
                self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        //刷新
        self.btnRefresh!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                let isLogin = xmppMsgManager!.RegistConnect()
                if(!isLogin){
                    showDialogMsg("远程通讯服务器连接不上，请关闭重新登录！")
                }
                self.sleepcareMainViewModel?.SearchByBedOrRoom("")
        }
        
        //设置选择查找类型
        self.imgSearch.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgSearch .addGestureRecognizer(singleTap)
        
        var dataSource = Array<DownListModel>()
        var item = DownListModel()
        item.key = SearchType.byBedNum
        item.value = SearchType.byBedNum
        dataSource.append(item)
        item = DownListModel()
        item.key = SearchType.byRoomNum
        item.value = SearchType.byRoomNum
        dataSource.append(item)
        self.popDownList = PopDownList(datasource: dataSource, dismissHandler: self.ChoosedItem)
        
        //设置选择科室rolename
        var session = Session.GetSession()
//        var partdataSource = Array<DownListModel>()
//        for(var i = 0;i < session.PartCodes.count;i++){
//            item = DownListModel()
//            item.key = session.PartCodes[i].PartCode
//            item.value = session.PartCodes[i].RoleName
//            partdataSource.append(item)
//        }
     //   self.partDownList = PopDownList(datasource: partdataSource, dismissHandler: self.ChoosedPartItem)
        
        self.lblMainName.userInteractionEnabled = true
        var choosePart:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mainNameTouch")
        self.lblMainName .addGestureRecognizer(choosePart)
        
        //查看报警明细
        self.lblWarining.userInteractionEnabled = true
        var showWarining:UITapGestureRecognizer = UITapGestureRecognizer(target: self.sleepcareMainViewModel!, action: "showWarining")
        self.lblWarining .addGestureRecognizer(showWarining)
        
        
        self.choosepart = ChooseMainhouseController(nibName: "ChoosePartName", bundle: nil)
        self.choosepart!.parentController = self
        self.choosepart!.choosepartDelegate = self
        
        
        //首次登陆，则跳转页面去选择科室
        if session.CurPartCode == ""{
        self.mainNameTouch()
        }
        
        
    }
    
    //点击查询类型
    func imageViewTouch(){
        self.popDownList!.Show(150, height: 80, uiElement: self.imgSearch)
    }
    
    //选择科室，选择完后刷新科室下的病人bedviews
    func mainNameTouch(){
      //  self.partDownList!.Show(200, uiElement: self.lblMainName)
        var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack:"NO",
            KNSemiModalOptionKeys.animationDuration:"0.2",KNSemiModalOptionKeys.shadowOpacity:"0.3"]
        self.presentSemiViewController(self.choosepart, withOptions: kNSemiModalOptionKeys)
 
    }
    
    //选择某科室代理
    func ChoosePart(partcode:String,partname:String,mainname:String) {
        self.lblMainName.text = mainname + "—" + partname
        self.sleepcareMainViewModel?.SearchByBedOrRoom("")

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page = Int(scrollView.contentOffset.x / self.mainScroll.frame.width) + 1
        self.curPager.jump(page)
    }
    
    func JumpPage(pageIndex:NSInteger){
        self.mainScroll.contentOffset.x = CGFloat(pageIndex - 1) * self.mainScroll.frame.width
        
    }
    
    //选中查询类型
    func ChoosedItem(downListModel:DownListModel){
        self.sleepcareMainViewModel?.ChoosedSearchType = downListModel.value
    }
    
    
  
//    
//    //选中科室/楼层
//    func ChoosedPartItem(downListModel:DownListModel){
//        var session = Session.GetSession()
//        session.CurPartCode = downListModel.key
//        self.sleepcareMainViewModel?.SearchByBedOrRoom("")
//    }
}
