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
    var spinner:JHSpinnerView?
    var thread:NSThread?
    //支线程完成true
    var threadFlag:Bool = false
    //当前科室下所有床位信息
    var BedViews:Array<BedModel>?{
        didSet{

            while (self.mainScroll.subviews.count > 0 ){
                self.mainScroll.subviews[0].removeFromSuperview()
            }
            
            if !self.threadFlag{
            self.ReloadMainScrollView()
            }
            
            if self.spinner != nil{
                self.threadFlag = true
                
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
    
    var clearlogininfoDelegate:ClearLoginInfoDelegate?
    
    //-------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScroll = UIScrollView()
       // self.mainScroll.backgroundColor = UIColor.clearColor()
        self.mainScroll.frame = self.view.frame
        self.mainScroll.frame.origin.y = 170
        self.mainScroll.frame.size.height = 600
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = false
        self.mainScroll.delegate = self
        self.mainScroll.bounces = false
        self.view.addSubview(self.mainScroll)
        
        //去掉搜索按钮背景
       
        //let count = self.search.subviews[0].subviews.count
        for(var i = 0 ; i < self.search.subviews[0].subviews.count; i++) {
            if(self.search.subviews[0].subviews[i].isKindOfClass(NSClassFromString("UISearchBarBackground"))){
                self.search.subviews[0].subviews[i].removeFromSuperview()
            }
        }
        self.search.delegate = self
        self.curPager.detegate = self
        
        //若没有选择记住密码，则清空登录页面里的输入信息
        if self.clearlogininfoDelegate != nil{
        self.clearlogininfoDelegate!.ClearLoginInfo()
        }
        
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
                self.clearlogininfoDelegate = nil
                //关闭报警和通知
                
                 self.sleepcareMainViewModel?.CloseWaringAttention()
                //关闭openfire，置空session
                LOGINFLAG = false
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                xmppMsgManager?.Close()
                Session.ClearSession()
                //关闭页面，退回到login页面
                self.dismissViewControllerAnimated(true, completion: nil)
                
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
        self.lblMainName.userInteractionEnabled = true
        var choosePart:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mainNameTouch")
        self.lblMainName .addGestureRecognizer(choosePart)
        
        //查看报警明细
        self.lblWarining.userInteractionEnabled = true
        var showWarining:UITapGestureRecognizer = UITapGestureRecognizer(target: self.sleepcareMainViewModel!, action: "showWarining")
        self.lblWarining .addGestureRecognizer(showWarining)

        //选择科室
        self.choosepart = ChooseMainhouseController(nibName: "ChoosePartName", bundle: nil)
        self.choosepart!.parentController = self
        self.choosepart!.choosepartDelegate = self
        
        
        //首次登陆，则跳转页面去选择科室
        if session.CurPartCode == ""{
             showDialogMsg("请先点击养老院标题，选择一个科室后才能查看")
           // self.mainNameTouch()
        }
    }
    
    
    //刷新
    @IBAction func Refresh(){
        if Session.GetSession().CurPartCode != ""{
            if self.spinner == nil{
                self.spinner  = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.whiteColor(), overlay:.Custom(CGRect(x:0,y:0,width:Int(UIScreen.mainScreen().bounds.width),height:Int(UIScreen.mainScreen().bounds.height)), CGFloat(0.0)), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.9))
              
                self.mainScroll.userInteractionEnabled = false
            }
       
        
        /*定时器，检查支线程是否完成
        */
        self.setTimer()
        
        //创建支线程
        self.thread = NSThread(target: self, selector: "RunThread", object: nil)
        //启动
        self.thread!.start()
        }
        else{
         showDialogMsg("请先点击养老院标题，选择一个科室后才能查看")
        }
    }
    
    //支线程，完成刷新操作
    func RunThread(){
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.RegistConnect()
        if(!isLogin){
                    if self.spinner != nil{
                    self.spinner!.dismiss()
                    self.spinner = nil
                    }
            showDialogMsg("远程通讯服务器连接不上，请检查网络状态，稍后再试！")
        }
        else{
        self.sleepcareMainViewModel!.SearchByBedOrRoom("")
        }
      }
    
    //定时器，检查支线程是否完成，完成后关闭spinner
    var realtimer:NSTimer!
    func setTimer(){
         realtimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "SpnnerTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    func SpnnerTimerFireMethod(timer: NSTimer) {
        if (self.threadFlag && self.spinner != nil){
            self.mainScroll.userInteractionEnabled = true
           self.spinner!.dismiss()
            self.spinner = nil
            self.threadFlag = false
            realtimer.invalidate()

           self.ReloadMainScrollView()
        }
    }
    
    
    func ReloadMainScrollView(){
        let pageCount:Int = (self.BedViews!.count / 8) + ((self.BedViews!.count % 8) > 0 ? 1 : 0)
        self.sleepcareMainViewModel?.PageCount = pageCount
        self.mainScroll.frame = CGRectMake(0, 170, self.view.bounds.size.width, self.view.bounds.size.height - 220)
       
        self.mainScroll.contentSize = CGSize(width: self.mainScroll.bounds.size.width * CGFloat(pageCount), height: self.mainScroll.bounds.size.height)
        self.mainScroll.contentOffset.x = 0
        
        if(pageCount > 0 ){
            for i in 1...pageCount{
                let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).first as! SleepCareCollectionView
                mainview1.frame = CGRectMake(CGFloat((i-1) * 1024) + 10, 0, 1024, self.mainScroll.frame.size.height)
                mainview1.tag = 111111
                mainview1.didSelecteBedHandler = self.BedSelected
                var bedList = self.sleepcareMainViewModel?.GetBedsOfPage(i, count: 8)
                mainview1.reloadData(bedList!)
                self.mainScroll.addSubview(mainview1)
                self.mainScroll.bringSubviewToFront(mainview1)
            }
        }
            //没找到对应床号／房间号，则放置空view
//        else{
//        let mainview2 = UIView()
//          self.mainScroll.addSubview(mainview2)
//            self.mainScroll.bringSubviewToFront(mainview2)
//        }

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
    
    //左右滑动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page = Int(scrollView.contentOffset.x / self.mainScroll.frame.width) + 1
        self.curPager.jump(page)
    }
    
    //代理
    func JumpPage(pageIndex:NSInteger){
        self.mainScroll.contentOffset.x = CGFloat(pageIndex - 1) * self.mainScroll.frame.width
        
    }
    
    //选中查询类型
    func ChoosedItem(downListModel:DownListModel){
        self.sleepcareMainViewModel?.ChoosedSearchType = downListModel.value
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol ClearLoginInfoDelegate{
    func ClearLoginInfo()
}
