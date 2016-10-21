//
//  AlarmInfoViewController.swift
//
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class ShowAlarmViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableview1: UITableView!
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    var alarmViewModel:IAlarmViewModel!
    var parentController:UIViewController!
    var source:Array<AlarmTableCell> = Array<AlarmTableCell>()
    
    
    
    
  
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableview1.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.alarmViewModel = IAlarmViewModel()
        
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        
        
        
        //去除末尾多余的行
        self.tableview1.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
        
        RACObserve(self.alarmViewModel, "AlarmArray") ~> RAC(self, "source")
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
            alarmImage.image = UIImage(named:"icon_报警")
            cell?.contentView.addSubview(alarmImage)
            
            var typeLabel = UILabel(frame:CGRectMake(45, 18, 76, 21))
            typeLabel.text = self.source[indexPath.section].AlarmType
            typeLabel.textColor = endColor
            typeLabel.font = font14
            cell?.contentView.addSubview(typeLabel)
            
            var timeLabel = UILabel(frame:CGRectMake(SCREENWIDTH-182, 18, 170, 21))
            timeLabel.text = self.source[indexPath.section].AlarmTime
            timeLabel.textAlignment = NSTextAlignment.Right
            timeLabel.textColor = textGraycolor
            timeLabel.font = font14
            cell?.contentView.addSubview(timeLabel)
            
            var underlineLabel1 = UILabel(frame:CGRectMake(12, 47, SCREENWIDTH-24, 1))
            underlineLabel1.backgroundColor = seperatorColor
            cell?.contentView.addSubview(underlineLabel1)
            
            var genderImageName:String = ""
            if self.source[indexPath.section].UserGender == "男"{
                genderImageName = "icon_male_"
            }
            else if self.source[indexPath.section].UserGender == "女"{
                genderImageName = "icon_female_"
            }
            var genderImage =  UIImageView(frame: CGRectMake(19, 62, 16, 16))
            genderImage.image = UIImage(named:genderImageName)
            cell?.contentView.addSubview(genderImage)
            
            var nameLabel = UILabel(frame:CGRectMake(45, 59, 85, 21))
            nameLabel.text = self.source[indexPath.section].UserName
            nameLabel.textColor = textGraycolor
            nameLabel.font = font14
            cell?.contentView.addSubview(nameLabel)
            
            var bednumberLabel = UILabel(frame:CGRectMake(138, 59, 60, 21))
            bednumberLabel.text = "床号: " + self.source[indexPath.section].UserBedNumber!
            bednumberLabel.textColor = textGraycolor
            bednumberLabel.font = font14
            cell?.contentView.addSubview(bednumberLabel)
            
            
            
            var alarmcontentText = UITextView(frame:CGRectMake(38, 80,SCREENWIDTH-42 , 56))
            alarmcontentText.text =  self.source[indexPath.section].AlarmContent
            alarmcontentText.textColor = textGraycolor
            alarmcontentText.font = font14
            alarmcontentText.editable = false
            cell?.contentView.addSubview(alarmcontentText)
            
            var underlineLabel2 = UILabel(frame:CGRectMake(12, 136, SCREENWIDTH-24, 1))
            underlineLabel2.backgroundColor = seperatorColor
            cell?.contentView.addSubview(underlineLabel2)
            
            var setnumberLabel = UILabel(frame:CGRectMake(SCREENWIDTH-192, 147, 180, 21))
            setnumberLabel.text = "设备编号  " + self.source[indexPath.section].EquipmentCode
            setnumberLabel.font = font14
            setnumberLabel.textColor = textGraycolor
            setnumberLabel.textAlignment = NSTextAlignment.Right
            cell?.contentView.addSubview(setnumberLabel)
            
            var deleteImage =  UIImageView(frame: CGRectMake(SCREENWIDTH, 0, 200, 180))
            // deleteImage.backgroundColor = UIColor.redColor()
            deleteImage.image = UIImage(named:"icon_trash")
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
            
            self.source[indexPath.section].deleteAlarmHandler!(alarmcell: self.source[indexPath.section])
            self.source.removeAtIndex(indexPath.section)
            self.tableview1.reloadData()
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame:CGRectMake(0, 0, SCREENWIDTH,15))
        footerView.backgroundColor = seperatorColor
        return footerView
    }
}

