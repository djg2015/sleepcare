//
//  CommonTableView.swift
//
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class CommonTableView: UITableView,UITableViewDelegate,UITableViewDataSource  {
    var _source:Array<AnyObject>!
    var _cellHeight:CGFloat!
    var firstCell:CommonTableCell!
    var allCells:Array<CommonTableCell>!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allCells = Array<CommonTableCell>()
        self.showsVerticalScrollIndicator = false
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
        return self._cellHeight
    }
    
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//         var cell:CommonTableCell! = NSBundle.mainBundle().loadNibNamed(self.nibName, owner: self, options: nil).first as! CommonTableCell
//        var cell:CommonTableCell! = tableView.dequeueReusableCellWithIdentifier(self.cellID, forIndexPath: indexPath) as! CommonTableCell
        if(allCells.count <= indexPath.item ){
             var cell:CommonTableCell! = NSBundle.mainBundle().loadNibNamed(self.nibName, owner: self, options: nil).first as! CommonTableCell
            if(cell == nil){
                cell = CommonTableCell()
            }
            cell.CellLoadData(self._source[indexPath.row])
            if(indexPath.item == 0){
                self.firstCell = cell
            }
            allCells.append(cell)
            
            return cell
        }
        else{
            return  allCells[indexPath.item]
        }
        
    }
    //选中某行操作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell:CommonTableCell = allCells[indexPath.item]
        cell.Checked()
        //针对首次代码选中第一行的恢复处理
        if(!tableView.allowsMultipleSelection){
            if(cell != self.firstCell){
                self.firstCell.UnChechked()
            }
        }
    }
    
    //当选中的末行变为未选中时的操作
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        var cell:CommonTableCell? = allCells[indexPath.item]
        
        if(cell != nil){
            cell!.UnChechked()
        }
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        var view:UIView = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    var cellNib:UINib?
    var cellID:String!
    var nibName:String!
    //控件显示入口
    func ShowTableView(nibName:String,cellID:String,source:Array<AnyObject>?,cellHeight:CGFloat){
        
        //注册单元格内容
//        if(self.cellNib == nil){
//            cellNib =  UINib(nibName: nibName, bundle: nil)
//            self.registerNib(cellNib!, forCellReuseIdentifier: cellID)
//        }
        self.nibName = nibName
        self._source = source
        self.cellID = cellID
        self._cellHeight = cellHeight
        self.allCells = Array<CommonTableCell>()
        self.reloadData()
    }
    
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        super.reloadData()
    }
    
    
}

class CommonTableCell:UITableViewCell{
    func CellLoadData(data:AnyObject){
        
    }
    
    func Checked(){
        
    }
    
    func UnChechked(){
        
    }
}
