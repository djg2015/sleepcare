//
//  AlarmTableViewController.swift
//
//
//  Created by Qinyuan Liu on 4/21/16.
//
//

import UIKit

class AlarmTableViewController: UITableViewController {
    var alarmViewModel:AlarmViewModel?
    var _source:Array<AlarmTableCellViewModel>!
    
    //存放要删除的cell。<row,alarmcode>
    var deleteDic = Dictionary<Int,String>()

    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        if self.alarmViewModel == nil{
            self.alarmViewModel = AlarmViewModel()
        }
        else{
        self.alarmViewModel!.LoadData()
        }
        
        self._source = self.alarmViewModel!.AlarmArray
        
        tag = 3
        currentController = self
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
//        self.navigationController?.navigationBar.barTintColor = themeColor[themeName]
//        let navigationTitleAttribute: NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName)
//        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject: AnyObject]
        
        
        //初始化数据
        self.alarmViewModel = AlarmViewModel()
        self._source = self.alarmViewModel!.AlarmArray
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(_source == nil){
            return 0
        }
        return _source.count
    }
    //返回单元格的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView:UITableView ,canEditRowAtIndexPath indexPath:NSIndexPath)->Bool {
        return true
    }
    
    
    //自定义单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:AlarmTableViewCell! = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        
        if(cell == nil){
            cell = AlarmTableViewCell()
        }
        
        
        cell.CellLoadData(self._source[indexPath.row])
        return cell
        
    }
    
    //显示删除样式
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除单个cell
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            //调用服务器接口方法删除这个老人信息（标记为已读，不进行处理，但不会再接收到这条报警）
            self._source[indexPath.row].deleteAlarmHandler!(alarmViewModel: self._source[indexPath.row])
            //source中删除这个老人的信息
            self._source.removeAtIndex(indexPath.row)
            //删除tableview中的这个老人
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            //更新报警信息
            // IAlarmHelper.GetAlarmInstance().Warningcouts = IAlarmHelper.GetAlarmInstance().Warningcouts - 1
            
            //数据源为空的时候管理按钮不能删除
            if self._source.count == 0{
                self.barButtonItem.enabled = false
            }
            
        }
    }
    
    //点击选中时，加入deleteDic
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if barButtonItem.title == "删除选中"{
            self.deleteDic[indexPath.row] = self._source[indexPath.row].AlarmCode!
        }
    }
    
    //点击取消选中时，从deleteDic中删除
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if barButtonItem.title == "删除选中"{
            self.deleteDic[indexPath.row] = nil
        }
    }
    
    @IBAction func RightButtonItemAction(){
        //点击“管理”，edit模式为true
        if self.barButtonItem.tag == 10{
            self.tableView.setEditing(true, animated: true);
            self.barButtonItem.title = "删除选中"
            self.barButtonItem.tag = 20
        }
            //点击“删除选中”，edit模式为false，调用方法删除多个选中值
        else{
            self.tableView.setEditing(false, animated: true);
            self.barButtonItem.title = "管理"
            self.barButtonItem.tag = 10
            self.DeleteMutipleAlarm()
        }
        
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
            for index in tempAlarmIndex{
             self._source.removeAtIndex(index)
            }

            
            self.deleteDic = Dictionary<Int,String>()
        
            
            //数据源为空的时候管理按钮不能删除
            if self._source.count == 0{
                self.barButtonItem.enabled = false
            }
            
            //刷新表格
            self.tableView.reloadData()
        }
    }
    
}
