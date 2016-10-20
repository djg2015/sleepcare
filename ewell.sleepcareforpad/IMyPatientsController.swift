//
//  IMyPatientsController.swift
//
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class IMyPatientsController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var patientsTableview: UITableView!
    
    
   
    let session = SessionForIphone.GetSession()
    var realtimer:NSTimer?
    let cellID = "patientCell"
    //我的病人列表
    var mypatientsArray:Array<MyPatientsTableCellViewModel> = Array<MyPatientsTableCellViewModel>()

     var mypatientsViewmodel:IMyPatientsViewModel?
    
    
    
    override func viewWillAppear(animated: Bool) {
        if self.mypatientsViewmodel == nil{
            self.mypatientsViewmodel = IMyPatientsViewModel()
            
        }
        self.mypatientsViewmodel!.InitData()


      
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mypatientsViewmodel = IMyPatientsViewModel()
        self.patientsTableview.delegate = self
        self.patientsTableview.dataSource = self
        
        
        //去除末尾多余的行
        self.patientsTableview.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
        RACObserve(self.mypatientsViewmodel, "MyPatientsArray") ~> RAC(self, "mypatientsArray")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.mypatientsArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    //分隔高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    
    //自定义单元格
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:MyPatientsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MyPatientsTableViewCell
        
        if(cell == nil){
            cell = MyPatientsTableViewCell()
        }

         cell.CellLoadData(self.mypatientsArray[indexPath.section])
        return cell
        
    }
    
    //选中某行操作
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell:MyPatientsTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MyPatientsTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        let session = SessionForIphone.GetSession()
        session!.CurPatientCode = cell.source.BedUserCode!
        session!.CurPatientName = cell.source.BedUserName!
       PLISTHELPER.CurPatientCode = cell.source.BedUserCode!
        PLISTHELPER.CurPatientCode = cell.source.BedUserName!
    
    
     tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView:UITableView ,canEditRowAtIndexPath indexPath:NSIndexPath)->Bool {
        return true
    }
    
    //显示删除样式
   func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
           
           //删除model中的这个老人，更新session list，删除和这个老人有关的报警信息
            self.mypatientsArray[indexPath.section].deleteBedUserHandler!(myPatientsTableViewModel: self.mypatientsArray[indexPath.section])
            self.mypatientsArray.removeAtIndex(indexPath.section)
           
          self.patientsTableview.reloadData()
          
        }
    }
    
    
  
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame:CGRectMake(0, 0, SCREENWIDTH,15))
        footerView.backgroundColor = seperatorColor
        return footerView
    }


}
