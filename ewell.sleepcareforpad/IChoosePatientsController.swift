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
    @IBOutlet weak var imgBack: UIImageView!
    
    var viewModel:IChoosePatientsViewModel!
    
    //科室下的床位用户集合
     var PartBedUserArray:Array<BedPatientViewModel>?{
        didSet{
            
            self.tbPatients.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 80)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rac_Setting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化设置与属性等绑定
    func rac_Setting(){
        self.viewModel = IChoosePatientsViewModel()
        self.viewModel.controllerForIphone = self
        RACObserve(self.viewModel, "PartBedUserArray") ~> RAC(self, "PartBedUserArray")

        self.tbParts.ShowTableView("PartTableCell",cellID: "partCell", source: self.viewModel.PartArray, cellHeight: 80)
        
        //设置选择查找类型
        self.imgBack.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgBack .addGestureRecognizer(singleTap)
    }
    
    //返回
    func imageViewTouch(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}