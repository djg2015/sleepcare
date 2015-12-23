//
//  IAlarmViewController.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import UIKit

class IAlarmViewController: IBaseViewController,UITableViewDelegate,UITableViewDataSource,MSCMoreOptionTableViewCellDelegate ,MoreOptionDelegate{

    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    var alarmViewModel:IAlarmViewModel?
     var _source:Array<IAlarmTableCellViewModel>!
    var MSCMoreOptionDelegate:MSCMoreOptionTableViewCellDelegate!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.alarmViewModel = IAlarmViewModel()
        self._source = self.alarmViewModel!.AlarmArray
        
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        self.alarmTableView.registerNib(UINib(nibName: "IAlarmTableViewCell", bundle: nil), forCellReuseIdentifier: "MSCMoreOptionTableViewCell")
        self.alarmTableView.reloadData()
    
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToController:")
        self.imgBack.addGestureRecognizer(singleTap)
     
       self.MSCMoreOptionDelegate = self
           }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(_source == nil){
            return 0
        }
        return _source.count
    }
    
    //返回表格总列数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(tableView:UITableView ,canEditRowAtIndexPath indexPath:NSIndexPath)->Bool {
    return true
    }


    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:IAlarmTableViewCell! = tableView.dequeueReusableCellWithIdentifier("MSCMoreOptionTableViewCell", forIndexPath: indexPath) as! IAlarmTableViewCell
        
        if(cell == nil){
            cell = IAlarmTableViewCell()
        }
    
        cell.moreoptionDelegate = self
        cell.CellLoadData(self._source[indexPath.row])
        return cell
        
    }
    
    //显示删除样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tabbleView:UITableView,titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath)->String{
    return "误报警"
    }
   
    //点击“误报警”
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            self._source[indexPath.row].deleteAlarmHandler!(alarmViewModel: self._source[indexPath.row])
            self._source.removeAtIndex(indexPath.row)
             IAlarmHelper.GetAlarmInstance().Warningcouts = IAlarmHelper.GetAlarmInstance().Warningcouts - 1
            self.alarmTableView.reloadData()
        }
    }

    func backToController(sender:UITapGestureRecognizer)
    {
       
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func MoreOption(indexPath:NSIndexPath){
                self._source.removeAtIndex(indexPath.row)
                self.alarmTableView.reloadData()}

}
