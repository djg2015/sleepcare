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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.barTintColor = themeColor[themeName]
        let navigationTitleAttribute: NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject: AnyObject]
        
        
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
    //提交删除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            self._source[indexPath.row].deleteAlarmHandler!(alarmViewModel: self._source[indexPath.row])
            self._source.removeAtIndex(indexPath.row)

            //删除tableview中的这个老人
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            //更新报警信息
             IAlarmHelper.GetAlarmInstance().Warningcouts = IAlarmHelper.GetAlarmInstance().Warningcouts - 1

        }
    }
   

  

}
