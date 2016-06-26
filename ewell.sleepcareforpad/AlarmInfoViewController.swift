//
//  AlarmInfoViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class AlarmInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableview1: UITableView!
    
   var source:Array<AlarmTableCell> = Array<AlarmTableCell>()
    
    let font14 = UIFont.systemFontOfSize(14)
    let font12 = UIFont.systemFontOfSize(12)
    let screenwidth = UIScreen.mainScreen().bounds.width
    let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        
        //初始化报警data
        var alarm1 = AlarmTableCell()
        alarm1.AlarmType = "离床"
        alarm1.AlarmTime = "16/06/01  16:00:13"
        alarm1.AlarmContent = "还是贷记卡了还是打了卡技术开发了就挖坑了几分才开始才能建立起核武器的封口处库马诺沃青年卡家呢好人"
        alarm1.UserGender = "女"
        alarm1.UserName = "王奶奶"
        alarm1.UserBedNumber = "12床"
        alarm1.EquipmentCode = "3786895674"
        
        var alarm2 = AlarmTableCell()
        alarm2.AlarmType = "心率"
        alarm2.AlarmTime = "16/06/01  16:00:15"
        alarm2.AlarmContent = "受到法律框架阿斯利康觉得希拉克就到了卡简单"
        alarm2.UserGender = "男"
        alarm2.UserName = "江爷爷"
        alarm2.UserBedNumber = "20床"
        alarm2.EquipmentCode = "000000001"
        
        var alarm3 = AlarmTableCell()
        alarm3.AlarmType = "呼吸"
        alarm3.AlarmTime = "16/06/01  16:00:14"
        alarm3.AlarmContent = "啊我是不讲理你了就看我能从快乐；jwpc "
        alarm3.UserGender = "男"
        alarm3.UserName = "毛爷爷"
        alarm3.UserBedNumber = "111床"
        alarm3.EquipmentCode = "00103283284"
        
        self.source.append(alarm1)
        self.source.append(alarm2)
        self.source.append(alarm3)
        
        
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
        return 180
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
                       //报警信息cell
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "alarmCell")
           
            //报警图标 报警类型 时间
            //分割线
            //性别图标   姓名  床号
            //报警内容
            //分割线
            //设备编号
          
            
            var alarmImage =  UIImageView(frame: CGRectMake(12, 0, 27, 47))
            alarmImage.image = UIImage(named:"icon_报警页面.png")
            cell?.contentView.addSubview(alarmImage)
            
            var typeLabel = UILabel(frame:CGRectMake(45, 18, 76, 21))
            typeLabel.text = self.source[indexPath.section].AlarmType
            typeLabel.font = self.font14
            cell?.contentView.addSubview(typeLabel)
            
            var timeLabel = UILabel(frame:CGRectMake(screenwidth-122, 18, 110, 21))
            timeLabel.text = self.source[indexPath.section].AlarmTime
            timeLabel.textAlignment = NSTextAlignment.Right
            timeLabel.font = self.font12
            cell?.contentView.addSubview(timeLabel)
            
            var underlineLabel1 = UILabel(frame:CGRectMake(12, 47, screenwidth-24, 1))
            underlineLabel1.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            cell?.contentView.addSubview(underlineLabel1)
            
            var genderImageName:String = ""
            if self.source[indexPath.section].UserGender == "男"{
                genderImageName = "icon_male_choose.png"
            }
            else if self.source[indexPath.section].UserGender == "女"{
                genderImageName = "icon_female_choose.png"
            }
            var genderImage =  UIImageView(frame: CGRectMake(19, 62, 13, 16))
            genderImage.image = UIImage(named:genderImageName)
            cell?.contentView.addSubview(genderImage)
            
            var nameLabel = UILabel(frame:CGRectMake(45, 59, 85, 21))
            nameLabel.text = self.source[indexPath.section].UserName
            nameLabel.font = self.font14
            cell?.contentView.addSubview(nameLabel)
            
            var bednumberLabel = UILabel(frame:CGRectMake(138, 59, 60, 21))
            bednumberLabel.text = self.source[indexPath.section].UserName
            bednumberLabel.font = self.font14
            cell?.contentView.addSubview(bednumberLabel)
            
            
            
            var alarmcontentText = UITextView(frame:CGRectMake(38, 80,screenwidth-42 , 56))
            alarmcontentText.text =  self.source[indexPath.section].AlarmContent
            alarmcontentText.font = self.font12
            alarmcontentText.editable = false
            cell?.contentView.addSubview(alarmcontentText)
            
            var underlineLabel2 = UILabel(frame:CGRectMake(12, 136, screenwidth-24, 1))
            underlineLabel2.backgroundColor = self.seperatorColor
            cell?.contentView.addSubview(underlineLabel2)
            
            var setnumberLabel = UILabel(frame:CGRectMake(screenwidth-162, 147, 150, 21))
            setnumberLabel.text = "设备编号  " + self.source[indexPath.section].EquipmentCode
            setnumberLabel.font = self.font12
            setnumberLabel.textAlignment = NSTextAlignment.Right
            cell?.contentView.addSubview(setnumberLabel)
            
            var deleteImage =  UIImageView(frame: CGRectMake(screenwidth, 0, 200, 180))
           // deleteImage.backgroundColor = UIColor.redColor()
              deleteImage.image = UIImage(named:"icon_alarmtrash.png")
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
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }


    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame:CGRectMake(0, 0, screenwidth,15))
        footerView.backgroundColor = self.seperatorColor
        return footerView
    }
}

class AlarmTableCell:NSObject{
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
    
    var _userBedNumber:String?
    dynamic var UserBedNumber:String?{
        get
        {
            return self._userBedNumber
        }
        set(value)
        {
            self._userBedNumber=value
        }
    }
    
    var _alarmTime:String?
    dynamic var AlarmTime:String?{
        get
        {
            return self._alarmTime
        }
        set(value)
        {
            self._alarmTime=value
        }
    }
    
    
    var _alarmContent:String?
    dynamic var AlarmContent:String?{
        get
        {
            return self._alarmContent
        }
        set(value)
        {
            self._alarmContent=value
        }
    }
    
    var _alarmType:String?
    dynamic var AlarmType:String?{
        get
        {
            return self._alarmType
        }
        set(value)
        {
            self._alarmType=value
        }
    }
    
}
