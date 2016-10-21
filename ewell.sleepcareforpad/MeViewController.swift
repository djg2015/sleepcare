//
//  MeTabViewController.swift
//
//
//  Created by Qinyuan Liu on 6/17/16.
//
//

import UIKit

class MeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var memuTable: UITableView!
    
    var imageList:Array<Array<String>>!
    var titleList:Array<Array<String>>!
    var hiddenalarm:Bool = true
    
    
    @IBAction func BtnBack(sender:UIButton){
    self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        let count = IAlarmHelper.GetAlarmInstance().WarningList.count
        if count > 0{
            self.hiddenalarm = false
          
        }
        else{
            self.hiddenalarm = true
          
        }
        self.memuTable.reloadData()
        
        currentController = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.memuTable.delegate = self
        self.memuTable.dataSource = self
        self.memuTable.contentSize = CGSize(width: SCREENWIDTH - 60, height:SCREENHIGHT)
        
        self.imageList = [["icon_nurse"],["icon_报警信息","icon_time"],["icon_当前版本"],["icon_set"]]
        self.titleList = [["用户名"],["报警信息","周报表"],["当前版本"],["设置"]]
        
        //去除末尾多余的行
        self.memuTable.tableFooterView = UIView()
        
        //去除顶部留白
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        
        //首先根据标示去缓存池取
        if (indexPath.section==0){
            //监护人：图片＋文字,cell高70
            cell = tableView.dequeueReusableCellWithIdentifier("samplecell1") as? UITableViewCell
        }
        else if (indexPath.section == 2 ){
            //当前版本：图片＋文字＋文字
            cell = tableView.dequeueReusableCellWithIdentifier("samplecell2") as? UITableViewCell
        }
        else if (indexPath.section == 1 && indexPath.row == 0){
            //报警信息：图片＋文字＋红色圆点 ＋右箭头
            //    cell = tableView.dequeueReusableCellWithIdentifier("samplecell3") as? UITableViewCell
        }
        else{
            //其他：图片＋文字＋右箭头,cell高45
            cell = tableView.dequeueReusableCellWithIdentifier("samplecell4") as? UITableViewCell
            
        }
        
        
        //如果缓存池没有取到则重新创建并放到缓存池中
        if (cell == nil) {
            if (indexPath.section==0){
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "samplecell1")
                
                var image1 =  UIImageView(frame: CGRectMake(12, 11, 52, 48))
                image1.image = UIImage(named:self.imageList[indexPath.section][indexPath.row])
                cell?.contentView.addSubview(image1)
                
                //  var label1 = UILabel(frame:CGRectMake(79, 24, 114, 21))
                //  label1.font = font16
                var label1 = MeTabLabel(frame:CGRectMake(79, 24, 114, 21))
                label1.text = self.titleList[indexPath.section][indexPath.row]
                cell?.contentView.addSubview(label1)
                
               
            }
            else if (indexPath.section == 2 ){
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "samplecell2")
                var image2 =  UIImageView(frame: CGRectMake(14, 8, 27, 27))
                image2.image = UIImage(named:self.imageList[indexPath.section][indexPath.row])
                cell?.contentView.addSubview(image2)
                
                //  var label2 = UILabel(frame:CGRectMake(56, 11, 122, 21))
                // label2.font = font16
                var label2 = MeTabLabel(frame:CGRectMake(56, 11, 122, 21))
                label2.text = self.titleList[indexPath.section][indexPath.row]
                cell?.contentView.addSubview(label2)
                
                
                var label2_2 = UILabel(frame:CGRectMake(SCREENWIDTH-60, 11, 40, 21))
                label2_2.text = "1.0"
                label2_2.textColor = textGraycolor
                label2_2.textAlignment = NSTextAlignment.Right
                label2_2.font = font16
                cell?.contentView.addSubview(label2_2)
            }
            else if (indexPath.section == 1 && indexPath.row == 0){
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "samplecell3")
                var image3 =  UIImageView(frame: CGRectMake(14, 8, 27, 27))
                image3.image = UIImage(named:self.imageList[indexPath.section][indexPath.row])
                cell?.contentView.addSubview(image3)
                
                var label3 = MeTabLabel(frame:CGRectMake(56, 11, 70, 21))
                label3.text = self.titleList[indexPath.section][indexPath.row]
                //   label3.font = font16
                cell?.contentView.addSubview(label3)
                
                if !self.hiddenalarm{
                    var image3_2 =  UIImageView(frame: CGRectMake(122, 9, 9, 9))
                    image3_2.image = UIImage(named:"icon_redcircle")
                    cell?.contentView.addSubview(image3_2)
                }
                
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "samplecell4")
                var image4 =  UIImageView(frame: CGRectMake(14, 8, 27, 27))
                image4.image = UIImage(named:self.imageList[indexPath.section][indexPath.row])
                cell?.contentView.addSubview(image4)
                
                var label4 = MeTabLabel(frame:CGRectMake(56, 11, 122, 21))
                label4.text = self.titleList[indexPath.section][indexPath.row]
                // label4.font = font16
                cell?.contentView.addSubview(label4)
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 70
        }
        return 45
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return 2
        }
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1){
            if indexPath.row == 1{
                self.performSegueWithIdentifier("showweekreport", sender: self)
            }
            else if indexPath.row == 0{
                self.performSegueWithIdentifier("showalarmlist", sender: self)
                
            }
            
        }
        
        else if (indexPath.section == 3){
            self.performSegueWithIdentifier("accountsetting", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    func SetAlarmPic(count:Int){
        
        if count > 0{
            self.hiddenalarm = false
            
        }
        else{
            self.hiddenalarm = true
        }
        self.memuTable.reloadData()
    }
    
    
    
    
}
