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
    @IBOutlet weak var tbPatientsDouble: CommonTableView!
    
    @IBOutlet weak var btnConfirm: UIButton!
   
    
    @IBAction func BtnBack(sender:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var allPatientInfo:IMyPatientsViewModel!
    var viewModel:IChoosePatientsViewModel!
    var addList:Array<MyPatientsTableCellViewModel>!
   
    
    //科室下的床位用户集合
    var PartBedUserArray:Array<BedPatientViewModel>?{
        didSet{
            var session = SessionForIphone.GetSession()
            self.tbPatientsDouble.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 107)
            
            
           
        }
    }
    
//   
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ConfirmAddPatient" {
//            self.viewModel.myPatientsViewModel = allPatientInfo
//           self.viewModel.commit()
//          //   self.addList = self.viewModel.choosedPatients
//        }
//    }
   
   
    
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

      self.viewModel.myPatientsViewModel = self.allPatientInfo
      self.viewModel.parentcontroller = self
       
        self.viewModel.InitData()
         RACObserve(self.viewModel, "PartBedUserArray") ~> RAC(self, "PartBedUserArray")
       
       
        
       
        self.btnConfirm.rac_command = self.viewModel.commitCommand
        
        self.tbParts.ShowTableView("PartTableCell",cellID: "partCell", source: self.viewModel.PartArray, cellHeight: 107)

    }

   }