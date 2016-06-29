//
//  AccountSettingController.swift
//  
//
//  Created by Qinyuan Liu on 6/25/16.
//
//

import UIKit

class AccountSettingController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBAction func UnwindModifyAccount(unwindsegue:UIStoryboardSegue){
       
        currentController = self
    }
    
    @IBOutlet weak var logoutBtn:UIButton!
    @IBOutlet weak var tableview1: UITableView!

    let font14 = UIFont.systemFontOfSize(14)
    let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    var accountsettingViewModel:AccountSettingViewModel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        currentController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.accountsettingViewModel = AccountSettingViewModel()
       // self.logoutBtn.rac_command = self.accountsettingViewModel.logoutCommand
        
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        
        //去除末尾多余的行
        self.tableview1.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    

    
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        
        //首先根据标示去缓存池取
        if (indexPath.row==0) {
           cell = tableView.dequeueReusableCellWithIdentifier("modifyaccountcell") as? UITableViewCell
        }else{
           cell = tableView.dequeueReusableCellWithIdentifier("switchalarmcell") as? UITableViewCell
        }
        
        //如果缓存池没有取到则重新创建并放到缓存池中
        if cell == nil{
            if (indexPath.row==0) {
               cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "modifyaccountcell")
                 cell?.textLabel!.text = "帐号与安全"
                cell?.textLabel?.font = self.font14
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "switchalarmcell")
                cell?.textLabel!.text = "报警提示"
                cell?.textLabel?.font = self.font14
                var sw = UISwitch()
                sw.setOn(true, animated: false)
                sw.addTarget(self, action: "SwitchValueChange:", forControlEvents: UIControlEvents.ValueChanged)
                cell?.accessoryView = sw
            }

        }
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         if (indexPath.row==0) {
              self.performSegueWithIdentifier("modifyaccount", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func SwitchValueChange(switchState: UISwitch){
//        //开启报警通知
//        if switchState.on{
//        print("on")
//        }
//        //关闭
//        else{
//        print("off")
//        }
         self.accountsettingViewModel.SwitchAlarm(switchState.on)
    }
    
}





