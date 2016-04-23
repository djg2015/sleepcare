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
    @IBAction func CloseShowTips(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
     
    }
    
    
    @IBAction func CloseShowInfo(segue:UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CloseMyPatients(segue:UIStoryboardSegue){
        IAlarmHelper.GetAlarmInstance().ReloadUndealedWarning()
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
