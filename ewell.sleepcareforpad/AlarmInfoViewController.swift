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
    var alarmViewModel:AlarmViewModel!
    var parentController:UIViewController!
    
    let font14 = UIFont.systemFontOfSize(14)
    let font12 = UIFont.systemFontOfSize(12)
    let screenwidth = UIScreen.mainScreen().bounds.width
    let seperatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

    
    var source:Array<AlarmTableCell> = Array<AlarmTableCell>(){
    didSet{
    self.tableview1.reloadData()
    }
    }

    
    @IBAction func Close(sender:AnyObject){
        
        if self.parentController != nil{
            currentController = self.parentController
        }
        
        //把当前页面中的报警信息设置为“已读”
        IAlarmHelper.GetAlarmInstance().SetReadWarning(self.alarmViewModel!.codeList)
        AlarmViewTag = false
        
        //返回上一页
        self.parentController.navigationController?.popViewControllerAnimated(true)
    }

    
    override func viewWillAppear(animated: Bool) {
        currentController = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.alarmViewModel = AlarmViewModel()
        
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
            alarmImage.image = UIImage(named:"icon_报警页面.png")
            cell?.contentView.addSubview(alarmImage)
            
            var typeLabel = UILabel(frame:CGRectMake(45, 18, 76, 21))
            typeLabel.text = self.source[indexPath.section].AlarmType
            typeLabel.font = self.font14
            cell?.contentView.addSubview(typeLabel)
            
            var timeLabel = UILabel(frame:CGRectMake(screenwidth-142, 18, 130, 21))
            timeLabel.text = self.source[indexPath.section].AlarmTime
            timeLabel.textAlignment = NSTextAlignment.Right
            timeLabel.textColor = textGraycolor
            timeLabel.font = self.font12
            cell?.contentView.addSubview(timeLabel)
            
            var underlineLabel1 = UILabel(frame:CGRectMake(12, 47, screenwidth-24, 1))
            underlineLabel1.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            cell?.contentView.addSubview(underlineLabel1)
            
            var genderImageName:String = ""
            if self.source[indexPath.section].UserGender == "1"{
                genderImageName = "icon_male_choose.png"
            }
            else if self.source[indexPath.section].UserGender == "2"{
                genderImageName = "icon_female_choose.png"
            }
            var genderImage =  UIImageView(frame: CGRectMake(19, 62, 13, 16))
            genderImage.image = UIImage(named:genderImageName)
            cell?.contentView.addSubview(genderImage)
            
            var nameLabel = UILabel(frame:CGRectMake(45, 59, 85, 21))
            nameLabel.text = self.source[indexPath.section].UserName
            nameLabel.textColor = textGraycolor
            nameLabel.font = self.font14
            cell?.contentView.addSubview(nameLabel)
            
            var bednumberLabel = UILabel(frame:CGRectMake(138, 59, 60, 21))
            bednumberLabel.text = self.source[indexPath.section].UserName
            bednumberLabel.textColor = textGraycolor
            bednumberLabel.font = self.font14
            cell?.contentView.addSubview(bednumberLabel)
            
            
            
            var alarmcontentText = UITextView(frame:CGRectMake(38, 80,screenwidth-42 , 56))
            alarmcontentText.text =  self.source[indexPath.section].AlarmContent
            alarmcontentText.textColor = textGraycolor
            alarmcontentText.font = self.font12
            alarmcontentText.editable = false
            cell?.contentView.addSubview(alarmcontentText)
            
            var underlineLabel2 = UILabel(frame:CGRectMake(12, 136, screenwidth-24, 1))
            underlineLabel2.backgroundColor = self.seperatorColor
            cell?.contentView.addSubview(underlineLabel2)
            
            var setnumberLabel = UILabel(frame:CGRectMake(screenwidth-162, 147, 150, 21))
            setnumberLabel.text = "设备编号  " + self.source[indexPath.section].EquipmentCode
            setnumberLabel.font = self.font12
            setnumberLabel.textColor = textGraycolor
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
            
             self.source[indexPath.row].deleteAlarmHandler!(alarmcell: self.source[indexPath.row])
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

