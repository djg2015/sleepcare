//
//  SleepCareTableView.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class MyPatientsTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var _source:Array<MyPatientsTableCellViewModel>!
    override init(frame: CGRect) {
        super.init(frame: frame,style:UITableViewStyle.Plain)
        self.backgroundColor = UIColor.whiteColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.delegate = self
        self.dataSource = self
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //注册单元格内容
        var cellNib =  UINib(nibName: "MyPatientsTableViewCell", bundle: nil)
        self.registerNib(cellNib, forCellReuseIdentifier: "patientCell")
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.whiteColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.delegate = self
        self.dataSource = self
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
        return 195
    }
    
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:MyPatientsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MyPatientsTableViewCell
        
        if(cell == nil){
            cell = MyPatientsTableViewCell()
        }
        cell.CellLoadData(self._source[indexPath.row])
        return cell
        
    }
    
    //选中某行操作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell:MyPatientsTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MyPatientsTableViewCell
        cell.imageViewTouch()
        
    }
    
    //显示删除样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
    //提交删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            self._source[indexPath.row].deleteBedUserHandler!(myPatientsTableViewModel: self._source[indexPath.row])
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    var cellNib:UINib?
    var cellID = "patientCell"
    //控件显示入口
    func ShowTableView(source:Array<MyPatientsTableCellViewModel>?){
        
        //注册单元格内容
        if(self.cellNib == nil){
            cellNib =  UINib(nibName: "MyPatientsTableViewCell", bundle: nil)
            self.registerNib(cellNib!, forCellReuseIdentifier: cellID)
        }
        self._source = source
        self.reloadData()
    }
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        
        
        super.reloadData()
    }
    
}
