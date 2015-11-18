//
//  PartTableViewCell.swift
//
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class PartTableViewCell: CommonTableCell {
    @IBOutlet weak var lblName: UILabel!
    var source:PartTableViewModel!
    var bindFlag:Bool = false
    override func CellLoadData(data:AnyObject){
        self.source = data as! PartTableViewModel
        if(self.source.IsChoosed){
            self.backgroundColor = UIColor.whiteColor()
            self.source.selectedPartHandler!(partTableViewModel: self.source)
            //self.source.selectedPartHandler!(partTableViewModel: self.source)
            
        }
        
        if(!self.bindFlag){
            RACObserve(self.source, "PartName") ~> RAC(self.lblName, "text")
            self.bindFlag = true
        }
    }
    
    override func Checked(){
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
        self.source.selectedPartHandler!(partTableViewModel: self.source)
    }
    
    override func UnChechked(){
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView.backgroundColor = UIColor(red: 0.85490196080000003, green: 0.85490196080000003, blue: 0.85490196080000003, alpha: 1)

         self.backgroundColor = UIColor(red: 0.85490196080000003, green: 0.85490196080000003, blue: 0.85490196080000003, alpha: 1)
    }
}

class PartTableViewModel:NSObject{
    //属性定义
    //主体编号名
    var _mainCode:String?
    dynamic var MainCode:String?{
        get
        {
            return self._mainCode
        }
        set(value)
        {
            self._mainCode=value
        }
    }
    
    //场景编号名
    var _partCode:String?
    dynamic var PartCode:String?{
        get
        {
            return self._partCode
        }
        set(value)
        {
            self._partCode=value
        }
    }
    
    //场景编号名
    var _partName:String?
    dynamic var PartName:String?{
        get
        {
            return self._partName
        }
        set(value)
        {
            self._partName=value
        }
    }
    
    //是否选中
    var _isChoosed:Bool = false
    dynamic var IsChoosed:Bool{
        get
        {
            return self._isChoosed
        }
        set(value)
        {
            self._isChoosed=value
        }
    }
    
    //操作定义
    var selectedPartHandler: ((partTableViewModel:PartTableViewModel) -> ())?
}
