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
    
    @IBOutlet weak var forbidChooseView: UIView!
    @IBOutlet weak var choosePatientView: UIView!
    
    var allPatientInfo:IMyPatientsViewModel!
    var viewModel:IChoosePatientsViewModel!
    var addList:Array<MyPatientsTableCellViewModel>!
   
    
    //科室下的床位用户集合
    var PartBedUserArray:Array<BedPatientViewModel>?{
        didSet{
            var session = SessionForIphone.GetSession()
            //使用者单选，右边页面显示tbPatients
            if(session!.User?.UserType == LoginUserType.UserSelf){
                self.tbPatients.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 100)
                self.tbPatientsDouble.hidden = true
                self.tbPatients.hidden = false
            }
            //监护人多选，右边页面显示tbPatientsDouble
            else{
                self.tbPatientsDouble.ShowTableView("BedPatientCell", cellID: "BedPatientCell",source: self.PartBedUserArray, cellHeight: 100)
                self.tbPatientsDouble.hidden = false
                self.tbPatients.hidden = true
            }
        }
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmAddPatient" {
            self.viewModel.myPatientsViewModel = allPatientInfo
           self.viewModel.commit()
            self.addList = self.viewModel.choosedPatients
        }
    }
   
    override func viewWillAppear(animated: Bool) {
       
        tag = 2
        currentController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let session = SessionForIphone.GetSession()
        //当前是使用者 且bedlist.count>0，则提示先删除后添加一个老人
        if (session != nil && session!.BedUserCodeList.count > 0 && session!.User!.UserType == "1"){
           self.forbidChooseView.hidden = false
        self.choosePatientView.hidden = true
        }
        else{
            self.forbidChooseView.hidden = true
            self.choosePatientView.hidden = false
        rac_Setting()
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    
    //初始化设置与属性等绑定
    func rac_Setting(){
        
        self.viewModel = IChoosePatientsViewModel()
        self.viewModel.myPatientsViewModel = self.allPatientInfo
      
        RACObserve(self.viewModel, "PartBedUserArray") ~> RAC(self, "PartBedUserArray")
    //    self.btnConfirm.rac_command = self.viewModel.commitCommand
        self.tbParts.ShowTableView("PartTableCell",cellID: "partCell", source: self.viewModel.PartArray, cellHeight: 100)

    }

   }