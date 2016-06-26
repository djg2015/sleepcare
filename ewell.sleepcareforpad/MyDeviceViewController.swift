//
//  MyDeviceViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class MyDeviceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

     @IBOutlet weak var tableview1: UITableView!
    
   var source:Array<EquipmentTableCell>=Array<EquipmentTableCell>()
    
    let font14 = UIFont.systemFontOfSize(14)
    let font12 = UIFont.systemFontOfSize(12)
    let screenwidth = UIScreen.mainScreen().bounds.width
     let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        
                //初始化设备data
                var equipment1 = EquipmentTableCell()
                equipment1.UserName = "张爷爷"
                equipment1.UserGender = "男"
                equipment1.EquipmentAddress = "江苏省无锡市时间回复你脸上的肌肤立刻黑色的礼服回家吃完了卡首发恶俗发 i 就会问 iu "
                equipment1.EquipmentCode = "00000000001"
        
                var equipment2 = EquipmentTableCell()
                equipment2.UserName = "张奶奶"
                equipment2.UserGender = "女"
                equipment2.EquipmentAddress = "为史蒂芬斯洛伐克婚纱索科洛夫就饿哦情况为了假期哦复活节假期维护费和乌伦古湖期望"
                equipment2.EquipmentCode = "00000000002"
        
                var equipment3 = EquipmentTableCell()
                equipment3.UserName = "王奶奶"
                equipment3.UserGender = "女"
                equipment3.EquipmentAddress = "发生的风输入个人跟我二哥问"
                equipment3.EquipmentCode = "0000000003"
        
                self.source.append(equipment1)
                 self.source.append(equipment2)
                 self.source.append(equipment3)
        
        //去除末尾多余的行
        self.tableview1.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.source.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        // cell = tableView.dequeueReusableCellWithIdentifier("equipmentCell") as? UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier("alarmCell") as? UITableViewCell
        
        if cell == nil{
                        //我的设备cell
                        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "equipmentCell")
            
                        //性别 姓名 设备编号
                        //分割线
                        //地址图标 地址
                        var genderImageName:String = ""
                        if self.source[indexPath.section].UserGender == "男"{
                        genderImageName = "icon_male_choose.png"
                        }
                        else if self.source[indexPath.section].UserGender == "女"{
                        genderImageName = "icon_female_choose.png"
                        }
                        var genderImage =  UIImageView(frame: CGRectMake(19, 11, 13, 16))
                        genderImage.image = UIImage(named:genderImageName)
                        cell?.contentView.addSubview(genderImage)
            
                        var nameLabel = UILabel(frame:CGRectMake(49, 10, 93, 21))
                        nameLabel.text = self.source[indexPath.section].UserName
                        nameLabel.font = self.font14
                        cell?.contentView.addSubview(nameLabel)
            
                        var setnumberLabel = UILabel(frame:CGRectMake(screenwidth-160, 10, 150, 21))
                        setnumberLabel.text = "设备编号  " + self.source[indexPath.section].EquipmentCode
                        setnumberLabel.font = self.font12
                        setnumberLabel.textAlignment = NSTextAlignment.Right
                        cell?.contentView.addSubview(setnumberLabel)
            
                        var underlineLabel = UILabel(frame:CGRectMake(18, 37, screenwidth-18, 1))
                        underlineLabel.backgroundColor = self.seperatorColor
                        cell?.contentView.addSubview(underlineLabel)
            
                        var addressImage =  UIImageView(frame: CGRectMake(19, 52, 14, 17))
                        addressImage.image = UIImage(named:"btn_address.png")
                        cell?.contentView.addSubview(addressImage)
            
            
                        var addressTextfield = UITextView(frame:CGRectMake(42, 42,screenwidth-42 , 48))
                        addressTextfield.text =  self.source[indexPath.section].EquipmentAddress
                         addressTextfield.font = self.font12
                       addressTextfield.editable = false
                        cell?.contentView.addSubview(addressTextfield)
            
            
                        var deleteImage =  UIImageView(frame: CGRectMake(screenwidth, 0, 200, 95))
                    //  deleteImage.backgroundColor = UIColor.redColor()
                        deleteImage.image = UIImage(named:"icon_equipmenttrash.png")
                        cell?.contentView.addSubview(deleteImage)
        }
            return cell!
            
    }
    
    func tableView(tableView:UITableView ,canEditRowAtIndexPath indexPath:NSIndexPath)->Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
        }
    }
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
//        return "删除"
//    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame:CGRectMake(0, 0, screenwidth,15))
        footerView.backgroundColor = self.seperatorColor
        return footerView
    }
}

class EquipmentTableCell:NSObject{
    //属性定义
    var _equipmentCode:String = ""
    dynamic var EquipmentCode:String{
        get
        {
            return self._equipmentCode
        }
        set(value)
        {
            self._equipmentCode=value
        }
    }
    
    var _userGender:String?
    dynamic var UserGender:String?{
        get
        {
            return self._userGender
        }
        set(value)
        {
            self._userGender=value
        }
    }
    
    var _userName:String?
    dynamic var UserName:String?{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName=value
        }
    }
    
    
    
    var _equipmentAddress:String?
    dynamic var EquipmentAddress:String?{
        get
        {
            return self._equipmentAddress
        }
        set(value)
        {
            self._equipmentAddress=value
        }
    }
}

