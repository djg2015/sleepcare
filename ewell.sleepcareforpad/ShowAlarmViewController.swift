//
//  ShowAlarmViewController.swift
//
//
//  Created by Qinyuan Liu on 4/27/16.
//
//

import UIKit

class ShowAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var alarmTableView: UITableView!
    var source:Array<AlarmTableCellViewModel>!
    var alarmViewModel:AlarmViewModel?
    //存放要删除的cell。<row,alarmcode>
    var deleteDic = Dictionary<Int,String>()
    var parentController:UIViewController!
    
    
    
    @IBAction func Close(sender:AnyObject){
       
        if self.parentController != nil{
            currentController = self.parentController
        }
        
        //把当前页面中的报警信息设置为“已读”
        IAlarmHelper.GetAlarmInstance().SetReadWarning(self.alarmViewModel!.codeList)
        AlarmViewTag = false
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func RightButtonItemAction(){
        //点击“管理”，edit模式为true
        if self.editButton.tag == 10{
            self.alarmTableView.setEditing(true, animated: true);
            self.editButton.setTitle("删除选中", forState:UIControlState.Normal)
            self.editButton.tag = 20
        }
            //点击“删除选中”，edit模式为false，调用方法删除多个选中值
        else{
            self.alarmTableView.setEditing(false, animated: true);
            self.editButton.setTitle("管理", forState: UIControlState.Normal)
            self.editButton.tag = 10
            self.DeleteMutipleAlarm()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        self.alarmTableView.registerNib(UINib(nibName: "alarmCell", bundle:nil), forCellReuseIdentifier: "alarmCell")
        
        
       AlarmViewTag = true
        currentController = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if self.alarmViewModel == nil{
            self.alarmViewModel = AlarmViewModel()
        }
        else{
            self.alarmViewModel!.LoadData()
        }
        
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
        return 158
    }
    func tableView(tableView:UITableView ,canEditRowAtIndexPath indexPath:NSIndexPath)->Bool {
        return true
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
            
            //数据源为空的时候管理按钮不能删除
            if self.source.count == 0{
                self.editButton.enabled = false
            }
            
        }
    }
    
    //点击选中时，加入deleteDic
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editButton.titleLabel!.text == "删除选中"{
            self.deleteDic[indexPath.row] = self.source[indexPath.row].AlarmCode!
        }
    }
    
    //点击取消选中时，从deleteDic中删除
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if editButton.titleLabel!.text == "删除选中"{
            self.deleteDic[indexPath.row] = nil
        }
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
    
    //删除选中的cell
    func DeleteMutipleAlarm(){
        if self.deleteDic.count > 0{
            //从deleteDic中提取所有bedusercodes
            var tempAlarmIndex = Array<Int>()
            for key in deleteDic.keys{
                tempAlarmIndex.append(key)
            }
            
            var tempAlarmCodes = ""
            for (var i=0;i<tempAlarmIndex.count;i++) {
                if i == 0{
                    tempAlarmCodes += deleteDic[tempAlarmIndex[i]]!
                }
                else{
                    tempAlarmCodes += ","
                    tempAlarmCodes += deleteDic[tempAlarmIndex[i]]!
                }
            }
            
            //更新服务器和本地报警信息
            if self.alarmViewModel != nil{
                self.alarmViewModel!.DeleteMutipleAlarms(tempAlarmCodes)
            }
            
            //data source中删除这个老人的信息
            var tempsource = self.source
            var tempsource2 = Array<AlarmTableCellViewModel>()
            //把要删除的cell置空
            for index in tempAlarmIndex{
                tempsource[index] = AlarmTableCellViewModel()
            }
            //从临时source数组中取出非空的cell，放入tempsource2
            for tempcell in tempsource{
                if tempcell.AlarmCode != nil{
                    tempsource2.append(tempcell)
                }
            }
            //把删除后的列表赋值给真正的source
            self.source = tempsource2
            
            
            self.deleteDic = Dictionary<Int,String>()
            
            
            //数据源为空的时候管理按钮不能删除
            if self.source.count == 0{
                self.editButton.enabled = false
            }
            
            //刷新表格
            self.alarmTableView.reloadData()
        }
    }
}
