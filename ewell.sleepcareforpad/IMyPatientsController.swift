//
//  IMyPatientsController.swift
//
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class IMyPatientsController: UITableViewController  {
    
    var viewModel:IMyPatientsViewModel?
    let session = SessionForIphone.GetSession()
    var realtimer:NSTimer?
    let cellID = "patientCell"
    //我关注的老人集合
    var MyPatientsArray:Array<MyPatientsTableCellViewModel> = Array<MyPatientsTableCellViewModel>()

    
    @IBAction func ConfirmAddPatient(segue:UIStoryboardSegue){
        let choosePatientViewController = segue.sourceViewController as! IChoosePatientsController
        let addPatientList = choosePatientViewController.addList
        //update the tableView
        for addPatient in addPatientList{
            self.MyPatientsArray.append(addPatient)
            let indexPath = NSIndexPath(forRow: self.MyPatientsArray.count - 1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
          
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChoosePatient" {
         let vc = segue.destinationViewController as! IChoosePatientsController
           vc.allPatientInfo = self.viewModel
        }
   

    }
    
    
    //返回指定分区的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return MyPatientsArray.count
    }
    
    //返回表格总列数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //返回单元格的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    //自定义单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:MyPatientsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MyPatientsTableViewCell
        
        if(cell == nil){
            cell = MyPatientsTableViewCell()
        }

        cell.CellLoadData(self.MyPatientsArray[indexPath.row])
        return cell
        
    }
    
    //选中某行操作
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell:MyPatientsTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MyPatientsTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        let session = SessionForIphone.GetSession()
        session!.CurPatientCode = cell.source.BedUserCode!
        session!.CurPatientName = cell.source.BedUserName!
        SetValueIntoPlist("curPatientCode", cell.source.BedUserCode!)
        SetValueIntoPlist("curPatientName", cell.source.BedUserName!)
    }
    
    //显示删除样式
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
           
           //删除model中的这个老人，更新session list，删除和这个老人有关的报警信息
            self.MyPatientsArray[indexPath.row].deleteBedUserHandler!(myPatientsTableViewModel: self.MyPatientsArray[indexPath.row])
            self.MyPatientsArray.removeAtIndex(indexPath.row)
            //删除tableview中的这个老人
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
           
          
        }
    }

    override func viewWillAppear(animated: Bool) {
       
        currentController = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let navigationTitleAttribute: NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject: AnyObject]
        
        rac_Setting()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //初始化设置与属性等绑定
    func rac_Setting(){
        self.viewModel = IMyPatientsViewModel()
        self.MyPatientsArray = self.viewModel!.MyPatientsArray
    }
    
}
