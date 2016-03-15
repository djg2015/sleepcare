//
//  IChoosePatients.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
class IChoosePatientsController: IBaseViewController {
    @IBOutlet weak var tbParts: CommonTableView!
    @IBOutlet weak var tbPatients: CommonTableView!
    @IBOutlet weak var tbPatientsDouble: CommonTableView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    
    var viewModel:IChoosePatientsViewModel!
    var myPatientsViewModel:IMyPatientsViewModel!
    //科室下的床位用户集合
    var PartBedUserArray:Array<BedPatientViewModel>?{
        didSet{
            var session = SessionForIphone.GetSession()
            if(session!.User?.UserType == LoginUserType.UserSelf){
                self.tbPatients.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 80)
                self.tbPatientsDouble.hidden = true
                self.tbPatients.hidden = false
            }
            else{
                self.tbPatientsDouble.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 80)
                self.tbPatientsDouble.hidden = false
                self.tbPatients.hidden = true
            }
        }
    }
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,myPatientsViewModel:IMyPatientsViewModel) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.myPatientsViewModel = myPatientsViewModel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rac_Setting()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func Clean() {
    //    self.viewModel = nil
     //   self.myPatientsViewModel = nil
//        self.tbParts = nil
//        self.tbPatients = nil
//        self.tbPatientsDouble = nil
//        self.PartBedUserArray = nil
    }

    
    //初始化设置与属性等绑定
    func rac_Setting(){
        self.view.backgroundColor = themeColor[themeName]
        
        self.btnConfirm.backgroundColor = themeColor[themeName]
        self.viewModel = IChoosePatientsViewModel()
        self.viewModel.myPatientsViewModel = self.myPatientsViewModel
        RACObserve(self.viewModel, "PartBedUserArray") ~> RAC(self, "PartBedUserArray")
        self.btnConfirm.rac_command = self.viewModel.commitCommand
        self.tbParts.ShowTableView("PartTableCell",cellID: "partCell", source: self.viewModel.PartArray, cellHeight: 80)
        
        //设置选择查找类型
        self.imgBack.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgBack .addGestureRecognizer(singleTap)
        
    }
    
    //返回
    func imageViewTouch(){
        IViewControllerManager.GetInstance()!.CloseViewController()
    }
    
   }