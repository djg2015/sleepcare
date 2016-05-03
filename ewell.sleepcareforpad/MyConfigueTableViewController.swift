//
//  MyConfigueTableViewController.swift
//
//
//  Created by Qinyuan Liu on 4/19/16.
//
//

import UIKit

class MyConfigueTableViewController:UITableViewController,SetTabbarBadgeDelegate ,SetAlarmPicDelegate{
    
    @IBOutlet weak var usertypeLbl: UILabel!
  
    @IBOutlet weak var logoutCell: UITableViewCell!
   
    @IBOutlet weak var alarmTableCell: UITableViewCell!
    @IBOutlet weak var alarmImg: UIImageView!
   
    
    let session = SessionForIphone.GetSession()
    
    @IBAction func CloseShowTips(segue:UIStoryboardSegue){
            tag = 1
        currentController = self
        
      self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    @IBAction func CloseShowInfo(segue:UIStoryboardSegue){
    
        tag = 1
        currentController = self
              self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //关闭“我的老人窗口”，1更新父页面上的报警数目；2若是“监护人”且beduserlist不为空，则更新curbeduser信息为这个老人
    @IBAction func CloseMyPatients(segue:UIStoryboardSegue){
        IAlarmHelper.GetAlarmInstance().ReloadUndealedWarning()

        if session?.User?.UserType == LoginUserType.UserSelf{
            try {
                ({
                    let beduserlist =  BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager").GetBedUsersByLoginName(self.session!.User!.LoginName, mainCode: self.session!.User!.MainCode).bedUserInfoList
                    if beduserlist.count == 1{
                        self.session!.CurPatientCode = beduserlist[0].BedUserCode
                        self.session!.CurPatientName = beduserlist[0].BedUserName
                        SetValueIntoPlist("curPatientCode", beduserlist[0].BedUserCode)
                        SetValueIntoPlist("curPatientName", beduserlist[0].BedUserName)
                        
                    }
                    },
                    catch: { ex in
                        //异常处理
                        handleException(ex,showDialog: true)
                    },
                    finally: {
                        
                    }
                )}
        }
        
    
        tag = 1
        currentController = self
        
       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
//    
//    @IBAction func CloseAlarmView(segue:UIStoryboardSegue){
// 
//        tag = 1
//        currentController = self
//  
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModifyAccount" {
            let vc = segue.destinationViewController as! IAccountSetController
            vc.parentController = self
          
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tag = 1
        currentController = self
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        if SessionForIphone.GetSession()?.User?.UserType == LoginUserType.Monitor{
            let alarmcount =  IAlarmHelper.GetAlarmInstance().GetAlarmCount()
            self.SetTabbarBadge(alarmcount)
            self.SetAlarmPic(alarmcount)

        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        //监护人显示报警cell，对使用者隐藏
        if SessionForIphone.GetSession()?.User?.UserType == LoginUserType.Monitor{
            self.alarmTableCell.hidden = false

            //设置tabbar上的报警数目,设置实时报警代理
            if IAlarmHelper.GetAlarmInstance().Warningcouts > 0{
                self.tabBarItem.badgeValue = String(IAlarmHelper.GetAlarmInstance().Warningcouts)
            }
            IAlarmHelper.GetAlarmInstance().tabbarBadgeDelegate = self
            IAlarmHelper.GetAlarmInstance().alarmpicdelegate = self
            self.usertypeLbl.text = "监护人"
        }
            //使用者
        else{
            self.alarmTableCell.hidden = true
            self.usertypeLbl.text = "使用者"
        }
        
        
            
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 6{
            let nextController = ShowAlarmViewController(nibName:"AlarmView", bundle:nil)
            nextController.parentController = self
        self.presentViewController(nextController, animated: true, completion: nil)
        }
    }
    
    
    func SetTabbarBadge(count:Int) {
        if count <= 0{
            self.tabBarItem.badgeValue = nil
        }
        else{
            self.tabBarItem.badgeValue = String(count)
        }
    }
    
    func SetAlarmPic(count:Int){
        if count>0{
            self.alarmImg.image = UIImage(named:"alarm.png")
        }
        else{
            self.alarmImg.image = UIImage(named:"noalarm.png")
        }
    }
}
