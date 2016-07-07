//
//  MyDeviceViewController.swift
//
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class MyDeviceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "adddevice"{
            let adddeviceVC = segue.destinationViewController as! AddDeviceViewController
            adddeviceVC.parentController = self
        }
    }
    
  
    
    @IBAction func UnwindAdddevice(unwindsegue:UIStoryboardSegue){
        currentController = self
    }
    
    @IBOutlet weak var tableview1: UITableView!
    
    var source:Array<EquipmentTableCell>=Array<EquipmentTableCell>()
    
    
    var mydeviceViewModel:MyDeviceViewModel!
    

    
    let screenwidth = UIScreen.mainScreen().bounds.width
    let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableview1.reloadData()
        currentController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mydeviceViewModel = MyDeviceViewModel()
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        
        
        //去除末尾多余的行
        self.tableview1.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
        RACObserve(self.mydeviceViewModel, "DeviceArray") ~> RAC(self, "source")
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
            if self.source[indexPath.section].UserGender == "1"{
                genderImageName = "icon_male_choose.png"
            }
            else if self.source[indexPath.section].UserGender == "2"{
                genderImageName = "icon_female_choose.png"
            }
            var genderImage =  UIImageView(frame: CGRectMake(18, 12, 16, 16))
            genderImage.image = UIImage(named:genderImageName)
            cell?.contentView.addSubview(genderImage)
            
            var nameLabel = UILabel(frame:CGRectMake(49, 10, 93, 21))
            nameLabel.text = self.source[indexPath.section].UserName
            nameLabel.font = font14
            nameLabel.textColor = textGraycolor
            cell?.contentView.addSubview(nameLabel)
            
            var setnumberLabel = UILabel(frame:CGRectMake(screenwidth-190, 10, 180, 21))
            setnumberLabel.text = "设备编号  " + self.source[indexPath.section].EquipmentCode
            setnumberLabel.font = font14
            setnumberLabel.textColor = textBluecolor
            setnumberLabel.textAlignment = NSTextAlignment.Right
            cell?.contentView.addSubview(setnumberLabel)
            
            var underlineLabel = UILabel(frame:CGRectMake(18, 37, screenwidth-18, 1))
            underlineLabel.backgroundColor = self.seperatorColor
            cell?.contentView.addSubview(underlineLabel)
            
            var addressImage =  UIImageView(frame: CGRectMake(19, 50, 12, 18))
            addressImage.image = UIImage(named:"btn_address.png")
            cell?.contentView.addSubview(addressImage)
            
            
            var addressTextfield = UITextView(frame:CGRectMake(42, 42,screenwidth-42 , 48))
            addressTextfield.text =  self.source[indexPath.section].EquipmentAddress
            addressTextfield.font = font14
            addressTextfield.textColor = textGraycolor
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
            //调用服务器接口方法删除这个设备信息（
            self.source[indexPath.section].deleteDeviceHandler!(devicecell: self.source[indexPath.section])
            //            //source中删除
                       self.source.removeAtIndex(indexPath.section)
          
            //            //删除tableview中此设备
       //    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableview1.reloadData()
        }
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
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
    
    var _userCode:String?
    dynamic var UserCode:String?{
        get
        {
            return self._userCode
        }
        set(value)
        {
            self._userCode=value
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
    
    //操作定义
    var deleteDeviceHandler: ((devicecell:EquipmentTableCell) -> ())?
}

