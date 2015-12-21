//
//  IAlarmViewController.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/16/15.
//  Copyright (c) 2015 djg. All rights reserved.
//

import UIKit

class IAlarmViewController: IBaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    var alarmViewModel:IAlarmViewModel?
     var _source:Array<IAlarmTableCellViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.alarmViewModel = IAlarmViewModel()
        self._source = self.alarmViewModel!.AlarmArray
        
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        self.alarmTableView.registerNib(UINib(nibName: "IAlarmTableViewCell", bundle: nil), forCellReuseIdentifier: "IAlarmCell")
        self.alarmTableView.reloadData()
        
        self.btnEdit.tag = 100
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToController:")
        self.imgBack.addGestureRecognizer(singleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //编辑按钮事件
    @IBAction func EditButtonClicked()
    {
        if (self.btnEdit.tag == 100)
        {
            self.alarmTableView.setEditing(true, animated: true)
            self.btnEdit.tag = 200
            self.btnEdit.setTitle("完成", forState: UIControlState.Normal)
           
        }
        else
        {
            
            self.alarmTableView.setEditing(false, animated: true)
            self.btnEdit.tag = 100
            self.btnEdit.setTitle("处理", forState: UIControlState.Normal)
        }
        
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
        return 88
    }

    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:IAlarmTableViewCell! = tableView.dequeueReusableCellWithIdentifier("IAlarmCell", forIndexPath: indexPath) as! IAlarmTableViewCell
        
        if(cell == nil){
            cell = IAlarmTableViewCell()
        }
        cell.CellLoadData(self._source[indexPath.row])
        return cell
        
    }
    //显示删除样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            self._source[indexPath.row].deleteAlarmHandler!(alarmViewModel: self._source[indexPath.row])
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    func backToController(sender:UITapGestureRecognizer)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
