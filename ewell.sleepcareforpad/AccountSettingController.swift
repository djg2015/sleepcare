//
//  AccountSettingController.swift
//  
//
//  Created by Qinyuan Liu on 6/25/16.
//
//

import UIKit

class AccountSettingController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
  
    
    @IBOutlet weak var logoutBtn:UIButton!
    @IBOutlet weak var tableview1: UITableView!

    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        
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
        return 1
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    

    
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        
        //首先根据标示去缓存池取
        
           cell = tableView.dequeueReusableCellWithIdentifier("modifyaccountcell") as? UITableViewCell
       
        
        //如果缓存池没有取到则重新创建并放到缓存池中
        if cell == nil{
            
               cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "modifyaccountcell")
                 cell?.textLabel!.text = "帐号与安全"
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
          
            cell?.textLabel?.textColor = textGraycolor
            cell?.textLabel?.font = font16

        }
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
              self.performSegueWithIdentifier("modifyaccount", sender: self)
      
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
}





