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
    
    var _width:Int = 0
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
        
        myPatientTable.frame = CGRectMake(0, 7, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-7)
        if self.myPatientTable.respondsToSelector(Selector("setSeparatorInset:")) {
            self.myPatientTable.separatorInset = UIEdgeInsetsMake(0,0,0,8)
        }
        if self.myPatientTable.respondsToSelector(Selector("setLayoutMargins:")) {
           // self.myPatientTable.layoutMargins = UIEdgeInsetsZero
            self.myPatientTable.layoutMargins = UIEdgeInsetsZero
        }

        self.myPatientTable.layer.masksToBounds = true
        self.myPatientTable.layer.cornerRadius = 8
       
        if self.MyPatientsArray != nil{
        self._width = Int(self.myPatientTable.frame.width)
        self.spinner  = JHSpinnerView.showOnView(self.myPatientTable, spinnerColor:UIColor.whiteColor(), overlay:.Custom(CGRect(x:0,y:0,width:self._width,height:195 * self.MyPatientsArray!.count), CGFloat(8.0)), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.95))
        self.setTimer()
        }
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
        
        //“我的老人”页面单击添加老人事件
        self.imgSmallAdd.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageaddPatientTouch")
        self.imgSmallAdd .addGestureRecognizer(singleTap)
        
        //添加老人事件
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
        if self.viewModel.LoadingFlag >= self.viewModel.bedUserCodeList.count{
            self.spinner!.dismiss()
            self.viewModel.LoadingFlag = 0
        }
        
    }
}
