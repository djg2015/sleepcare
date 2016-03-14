//
//  IMyPatientsController.swift
//
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class IMyPatientsController: IBaseViewController {
    @IBOutlet weak var imgSmallAdd: UIImageView!
    @IBOutlet weak var imgBigAdd: UIImageView!
    @IBOutlet weak var uiNewAdd: BackgroundCommon!
    @IBOutlet weak var uiPatientList: UIView!
    @IBOutlet weak var myPatientTable: MyPatientsTableView!
 
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var imgAlarmView: UIImageView!
    @IBOutlet weak var lblAlarmCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblBack2: UILabel!
    @IBOutlet weak var btnBack2: UIButton!
    var _width:Int = 0
    var _height:Int = 0
    //  var spinner:JHSpinnerView?
    var viewModel:IMyPatientsViewModel!
    var popDownList:PopDownList?
    var isGoLogin:Bool = true
    
    var thread:NSThread?
    let session = SessionForIphone.GetSession()
    var realtimer:NSTimer?
    
    //   var cellDelegate:EnableCellInteractionDelegate!
    //我关注的老人集合
    var MyPatientsArray:Array<MyPatientsTableCellViewModel>?{
        didSet{
            if(self.MyPatientsArray?.count == 0){
                self.uiNewAdd.hidden = false
                self.uiPatientList.hidden = true
            }
            else{
                self.uiNewAdd.hidden = true
                self.uiPatientList.hidden = false
                self.myPatientTable.ShowTableView(self.MyPatientsArray)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiNewAdd.backgroundColor = themeColor[themeName]
        self.myPatientTable.frame = CGRectMake(0, 7, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-7)
        self.topView.backgroundColor = themeColor[themeName]
        
        rac_Setting()
        
        //        if self.MyPatientsArray?.count > 0{
        //         self._height = Int(self.myPatientTable.frame.height) - 62
        //         self._width = Int(self.myPatientTable.frame.width)
        //   self.spinner  = JHSpinnerView.showOnView(self.myPatientTable, spinnerColor:UIColor.whiteColor(), overlay:.Custom(CGRect(x:0,y:0,width:self._width,height:self._height), CGFloat(0.0)), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.9))
        
        //            if self.MyPatientsArray?.count > 0{
        //            self.myPatientTable.userInteractionEnabled = false
        //            }
        //   self.cellDelegate = self.myPatientTable
        //  self.setTimer()
        
        //创建支线程
     //   self.thread = NSThread(target: self, selector: "RunThread", object: nil)
        //启动
       // self.thread!.start()
        self.RunTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func Clean(){
        if self.viewModel != nil{
            self.viewModel.Clean()
        }
    }
    
    //初始化设置与属性等绑定
    func rac_Setting(){
        self.viewModel = IMyPatientsViewModel()
        RACObserve(self.viewModel, "MyPatientsArray") ~> RAC(self, "MyPatientsArray")
        
        self.imgAlarmView.hidden = true
        self.lblTitle.userInteractionEnabled = false
        var titleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ClickTitle")
        self.lblTitle.addGestureRecognizer(titleTap)
        
        
        //“我的老人”页面单击添加老人事件
        self.imgSmallAdd.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageaddPatientTouch")
        self.imgSmallAdd.addGestureRecognizer(singleTap)
        
        //添加老人事件
        self.imgBigAdd.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageaddPatientTouch")
        self.imgBigAdd.addGestureRecognizer(singleTap1)
        
        //返回上一页
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                IViewControllerManager.GetInstance()!.CloseViewController()
                
        }
        
        //跳至“我”主页面
        self.btnBack2!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                let nextcontroller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:nil,equipmentID:nil,bedUserName:nil)
                IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IMainFrame", reload: true)
                
        }
        
        //跳至“我”主页面
        self.lblBack2.userInteractionEnabled = true
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "BackToMyselfView")
        self.lblBack2.addGestureRecognizer(singleTap2)
    }
    
    
    func BackToMyselfView(){
        let nextcontroller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:nil,equipmentID:nil,bedUserName:nil)
        IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IMainFrame", reload: true)
    }
    
    //添加老人
    func imageaddPatientTouch(){
        //当前是使用者 且bedlist。count》0，则提示先删除后添加一个老人
        if (session != nil && session!.BedUserCodeList.count > 0 && session!.User!.UserType == "1"){
            showDialogMsg(ShowMessage(MessageEnum.DeletePatientReminder))
        }
        else{
           
            var nextcontroller = IChoosePatientsController(nibName:"IChoosePatients", bundle:nil, myPatientsViewModel: self.viewModel)
            IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IChoosePatients",reload: true)
        }
    }
    //    //定时器查看是否已经载入数据
    //    func setTimer(){
    //        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
    //        timer.fire()
    //    }
    //    func timerFireMethod(timer: NSTimer) {
    //        if self.viewModel.LoadingFlag >= self.viewModel.bedUserCodeList.count{
    //         //   self.spinner!.dismiss()
    //            self.viewModel.LoadingFlag = 0
    //
    //            if self.cellDelegate != nil{
    //            self.cellDelegate.EnableCellInteraction()
    //            }
    //        }
    //    }
    
    
    //支线程判断当前是否有报警，有则跳转页面
    func RunTimer(){
        if self.realtimer == nil{
        self.realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "AlarmFireMethod:", userInfo: nil, repeats:true);
        self.realtimer!.fire()
        }
    }
    //监护人才有报警信息
    func AlarmFireMethod(timer: NSTimer) {
        
        if (session != nil && session!.User!.UserType == LoginUserType.Monitor){
            let count = IAlarmHelper.GetAlarmInstance().GetAlarmCount()
            if  count > 0{
                self.imgAlarmView.hidden = false
                self.lblAlarmCount.text = String(count)
                self.lblTitle.userInteractionEnabled = true
            }
            else{
            self.imgAlarmView.hidden = true
            self.lblAlarmCount.text = ""
            self.lblTitle.userInteractionEnabled = false
            }
        }
    }
    
    func CloseTimer(){
        if self.realtimer != nil{
        self.realtimer = nil
        }
    
    }
    
    //点击我的老人标题，跳转报警页面
    func ClickTitle(){
        let controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
        IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IAlarmView", reload: true)

    }
}
//protocol EnableCellInteractionDelegate{
//func EnableCellInteraction()
//}
