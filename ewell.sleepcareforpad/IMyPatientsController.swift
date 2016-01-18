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
    @IBOutlet weak var uiNewAdd: UIView!
    @IBOutlet weak var uiPatientList: UIView!
    @IBOutlet weak var myPatientTable: MyPatientsTableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var spinner:JHSpinnerView?
    var viewModel:IMyPatientsViewModel!
    var popDownList:PopDownList?
    var isGoLogin:Bool = false
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
        
        rac_Setting()
        
        myPatientTable.frame = CGRectMake(0, 57, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-57)
        self.spinner  = JHSpinnerView.showOnView(self.myPatientTable, spinnerColor:UIColor.whiteColor(), overlay:.FullScreen, overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.6), fullCycleTime:4.0, text:"")
        self.setTimer()
        
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
       // self.viewModel.controllerForIphone = self
        RACObserve(self.viewModel, "MyPatientsArray") ~> RAC(self, "MyPatientsArray")
        
        var dataSource = Array<DownListModel>()
        var item = DownListModel()
        item.key = "1"
        item.value = "添加老人"
        dataSource.append(item)
        item = DownListModel()
        item.key = "2"
        item.value = "设置"
        dataSource.append(item)
        self.popDownList = PopDownList(datasource: dataSource, dismissHandler: self.ChoosedItem)
        
        //设置菜单老人事件
        self.imgSmallAdd.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgSmallAdd .addGestureRecognizer(singleTap)
        
        //设置添加老人事件
        self.imgBigAdd.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageaddPatientTouch")
        self.imgBigAdd .addGestureRecognizer(singleTap1)
        
        if(self.isGoLogin){
            self.btnBack.hidden = true
        }
        
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                IViewControllerManager.GetInstance()!.CloseViewController()
            
        }
        
    }
    
    //选中菜单
    func ChoosedItem(downListModel:DownListModel){
        var session = SessionForIphone.GetSession()
        if(downListModel.key == "1"){
            if(session?.User?.UserType != LoginUserType.Monitor){
                if(self.MyPatientsArray?.count > 0){
                    showDialogMsg(ShowMessage(MessageEnum.DeletePatientReminder.rawValue), title: "提示")
                    return
                }
            }
            var nextcontroller = IChoosePatientsController(nibName:"IChoosePatients", bundle:nil, myPatientsViewModel: self.viewModel)
            IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IChoosePatients",reload: true)
        }
        else{
            session?.CurPatientCode = ""
            let controller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:nil,equipmentID:nil,bedUserName:nil)
            IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: "IMainFrame", reload: true)
        }
    }
    
    //弹出菜单界面
    func imageViewTouch(){
        self.popDownList!.Show(100, height: 85, uiElement: self.imgSmallAdd)
    }
    
    //添加老人
    func imageaddPatientTouch(){
        var nextcontroller = IChoosePatientsController(nibName:"IChoosePatients", bundle:nil, myPatientsViewModel: self.viewModel)
        IViewControllerManager.GetInstance()!.ShowViewController(nextcontroller, nibName: "IChoosePatients",reload: true)
    }
    //定时器查看是否已经载入数据
    func setTimer(){
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer.fire()
    }
    
    func timerFireMethod(timer: NSTimer) {
        if self.viewModel.LoadingFlag{
            self.spinner!.dismiss()
            self.viewModel.LoadingFlag = false
        }
        
    }
}
