//
//  MyConfigueTableViewController.swift
//
//
//  Created by Qinyuan Liu on 4/19/16.
//
//

import UIKit

class MyConfigueTableViewController: UITableViewController,SetTabbarBadgeDelegate ,SetAlarmPicDelegate{
    
    @IBOutlet weak var alarmTableCell: UITableViewCell!
    @IBOutlet weak var alarmImg: UIImageView!
    
    
    let session = SessionForIphone.GetSession()
    
    @IBAction func CloseShowTips(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func CloseShowInfo(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func CloseAlarmView(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func UnwindShowPatientDetail(unwindsegue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if SessionForIphone.GetSession()?.User?.UserType == LoginUserType.Monitor{
            let alarmcount =  IAlarmHelper.GetAlarmInstance().GetAlarmCount()
            self.SetTabbarBadge(alarmcount)
            self.SetAlarmPic(alarmcount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //监护人显示报警cell，对使用者隐藏
        if SessionForIphone.GetSession()?.User?.UserType == LoginUserType.Monitor{
            self.alarmTableCell.hidden = false
            //设置tabbar上的报警数目,设置实时报警代理
            if IAlarmHelper.GetAlarmInstance().Warningcouts > 0{
                self.tabBarItem.badgeValue = String(IAlarmHelper.GetAlarmInstance().Warningcouts)
            }
            IAlarmHelper.GetAlarmInstance().tabbarBadgeDelegate = self
            IAlarmHelper.GetAlarmInstance().alarmpicdelegate = self
        }
        else{
            self.alarmTableCell.hidden = true
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
