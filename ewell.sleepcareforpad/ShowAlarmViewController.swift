//
//  ShowAlarmViewController.swift
//  
//
//  Created by Qinyuan Liu on 4/27/16.
//
//

import UIKit

class ShowAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var alarmTableView: UITableView!
    var source:Array<AlarmTableCellViewModel>!
    var alarmViewModel:AlarmViewModel?
    
    @IBAction func Close(sender:AnyObject){
    
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        self.alarmTableView.registerNib(UINib(nibName: "alarmCell", bundle:nil), forCellReuseIdentifier: "alarmCell")
        self.alarmViewModel = AlarmViewModel()
        self.source = self.alarmViewModel!.AlarmArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(source == nil){
            return 0
        }
        return source.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:AlarmTableViewCell! = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
       
        if(cell == nil){
            cell = AlarmTableViewCell()
        }
        
        
        cell.CellLoadData(self.source[indexPath.row])
        return cell
        
    }
    //显示删除样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除单个cell
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            //调用服务器接口方法删除这个老人信息（标记为已读，不进行处理，但不会再接收到这条报警）
            self.source[indexPath.row].deleteAlarmHandler!(alarmViewModel: self.source[indexPath.row])
            //source中删除这个老人的信息
            self.source.removeAtIndex(indexPath.row)
            //删除tableview中的这个老人
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
           
            
        }
    }
}
