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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化设置与属性等绑定
    func rac_Setting(){
        self.viewModel = IMyPatientsViewModel()
        self.viewModel.controllerForIphone = self
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
                self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        
    }
    
    //选中菜单
    func ChoosedItem(downListModel:DownListModel){
        if(downListModel.key == "1"){
            var controller = IChoosePatientsController(nibName: "IChoosePatients", bundle: nil, myPatientsViewModel: self.viewModel)
            self.presentViewController(controller, animated: true, completion: nil)
            
        }
        else{
            let controller = IMainFrameViewController(nibName:"IMainFrame", bundle:nil,bedUserCode:nil)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //弹出菜单界面
    func imageViewTouch(){
        self.popDownList!.Show(100, height: 85, uiElement: self.imgSmallAdd)
    }
    
    //添加老人
    func imageaddPatientTouch(){
        var controller = IChoosePatientsController(nibName: "IChoosePatients", bundle: nil, myPatientsViewModel: self.viewModel)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
