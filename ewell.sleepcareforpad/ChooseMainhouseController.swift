//
//  ChooseMainhouseController.swift
//  表格动画手势示例
//
//  Created by Semper Idem on 14-10-22.
//  Copyright (c) 2014年 星夜暮晨. All rights reserved.
//

import UIKit
import MessageUI

//
//
//class EmailMenuItem: UIMenuItem{
//    var indexPath: NSIndexPath!
//}

class ChooseMainhouseController: BaseViewController,SectionHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var mainhouseTableView: UITableView!
    @IBOutlet weak var btnClickOk: UIButton!
   
    let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    var plays:NSArray!
    var sectionInfoArray:NSMutableArray!
    var pinchedIndexPath:NSIndexPath!
    var opensectionindex:Int!
    var playe:NSMutableArray?
    var sectionHeaderView:SectionHeaderView!
    
    //当缩放手势同时改变了所有单元格高度时使用uniformRowHeight
    var uniformRowHeight: Int!
    
    let DefaultRowHeight = 40
    let HeaderHeight = 40
    
    
    var parentController:BaseViewController?
    var Mainname:String = ""
    var choosepartDelegate:ChoosePartDelegate!
    
    
    //关闭选择科室页面
    @IBAction func btnConfirm(sender: AnyObject) {
        if self.parentController != nil{
        self.parentController!.dismissSemiModalView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mainhouseTableView.delegate = self
        self.mainhouseTableView.dataSource = self
        // 设置Header的高度
        self.mainhouseTableView.sectionHeaderHeight = CGFloat(HeaderHeight)
        
        // 分节信息数组在viewWillUnload方法中将被销毁，因此在这里设置Header的默认高度是可行的。如果您想要保留分节信息等内容，可以在指定初始化器当中设置初始值。
        self.uniformRowHeight = DefaultRowHeight
        self.opensectionindex = NSNotFound
        
        let sectionHeaderNib: UINib = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.mainhouseTableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
        plays = played()
        
        if Session.GetSession().CurPartCode == ""{
        self.btnClickOk.hidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
     override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 检查分节信息数组是否已被创建，如果其已创建，则再检查节的数量是否仍然匹配当前节的数量。通常情况下，您需要保持分节信息与单元格、分节格同步过您要允许在表视图中编辑信息，您需要在编辑操作中适当更新分节信息。
        
        if (self.sectionInfoArray == nil || self.sectionInfoArray.count != self.numberOfSectionsInTableView(self.mainhouseTableView)){
            
            //对于每个场次来说，需要为每个单元格设立一个一致的、包含默认高度的SectionInfo对象。
            var infoArray = NSMutableArray()
            
            for play in self.plays {
                var dic = (play as! Play).partnames
                var sectionInfo = SectionInfo()
                sectionInfo.play = play as! Play
                sectionInfo.open = false
                
                var defaultRowHeight = DefaultRowHeight
                var countOfQuotations = sectionInfo.play.partnames.count
                for (var i = 0; i < countOfQuotations; i++) {
                    sectionInfo.insertObject(defaultRowHeight, inRowHeightsAtIndex: i)
                }
                
                infoArray.addObject(sectionInfo)
            }
            
            self.sectionInfoArray  = infoArray
        }
        
        //去除多余的分割线
        self.mainhouseTableView.tableFooterView = UIView()
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 这个方法返回 tableview 有多少个section
        return self.plays.count
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 这个方法返回对应的section有多少个元素，也就是多少行
        var sectionInfo: SectionInfo = self.sectionInfoArray[section] as! SectionInfo
        var numStoriesInSection = sectionInfo.play.partnames.count
        var sectionOpen = sectionInfo.open!
        
        return sectionOpen ? numStoriesInSection : 0
    }
    
    //选中某行操作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell:PartNameCell = tableView.cellForRowAtIndexPath(indexPath) as! PartNameCell
        var Partcode = cell.quotation.partcode
        var Partname = cell.quotation.partname
        //更新session的curPartCode，并写入本地sleepcare。plist。调用代理刷新mainview
            if self.parentController != nil{
                    var session = Session.GetSession()
                    session.CurPartCode = Partcode
                    SetValueIntoPlist("curPartcode", Partcode)
                    SetValueIntoPlist("curPartname", Partname)
                    TodoList.sharedInstance.removeItemAll()
                
                    if self.choosepartDelegate != nil{
                        self.choosepartDelegate.ChoosePart(Partcode,partname:Partname,mainname:"古荡养老院")
                    }
                    self.parentController!.dismissSemiModalView()
            }
    }



     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let QuoteCellIdentifier = "QuoteCellIdentifier"
      
      //  var cell:PartNameCell = self.mainhouseTableView.dequeueReusableCellWithIdentifier(QuoteCellIdentifier) as! PartNameCell
        var cell:PartNameCell! = NSBundle.mainBundle().loadNibNamed("PartNameCell", owner: self, options: nil).first as! PartNameCell
        if(cell == nil){
            cell = PartNameCell()
        }
        
        var play:Play = (self.sectionInfoArray[indexPath.section] as! SectionInfo).play
        cell.quotation = play.partnames[indexPath.row] as! Part
        cell.setTheQuotation(cell.quotation)
        
        // 通过cell.accessoryType 可以设置是饱满的向右的蓝色箭头，还是单薄的向右箭头，还是勾勾标记。
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的 section header 的view，如果没有，这个函数可以不返回view
        var sectionHeaderView: SectionHeaderView = self.mainhouseTableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderViewIdentifier) as! SectionHeaderView
      
        var sectionInfo: SectionInfo = self.sectionInfoArray[section] as! SectionInfo
        sectionInfo.headerView = sectionHeaderView
        
        sectionHeaderView.titleLabel.text = sectionInfo.play.name
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        
        return sectionHeaderView
    }

     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 这个方法返回指定的 row 的高度
        var sectionInfo: SectionInfo = self.sectionInfoArray[indexPath.section] as! SectionInfo

        return CGFloat(sectionInfo.objectInRowHeightsAtIndex(indexPath.row) as! NSNumber)
        //又或者，返回单元格的行高
    }
    
    // _________________________________________________________________________
    // SectionHeaderViewDelegate
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int) {

        var sectionInfo: SectionInfo = self.sectionInfoArray[sectionOpened] as! SectionInfo
        
        sectionInfo.open = true
        
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        
        var countOfRowsToInsert = sectionInfo.play.partnames.count
        var indexPathsToInsert = NSMutableArray()
        
        for (var i = 0; i < countOfRowsToInsert; i++) {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        
        // 创建一个包含单元格索引路径的数组来实现删除单元格的操作：这些路径对应之前打开的节的单元格
        
        var indexPathsToDelete = NSMutableArray()
        
        var previousOpenSectionIndex = self.opensectionindex
        if previousOpenSectionIndex != NSNotFound {
            
            var previousOpenSection: SectionInfo = self.sectionInfoArray[previousOpenSectionIndex] as! SectionInfo
            previousOpenSection.open = false
            previousOpenSection.headerView.toggleOpenWithUserAction(false)
            var countOfRowsToDelete = previousOpenSection.play.partnames.count
            for (var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: previousOpenSectionIndex))
            }
        }

        // 设计动画，以便让表格的打开和关闭拥有一个流畅（很屌）的效果
        var insertAnimation: UITableViewRowAnimation
        var deleteAnimation: UITableViewRowAnimation
        if previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex {
            insertAnimation = UITableViewRowAnimation.Top
            deleteAnimation = UITableViewRowAnimation.Bottom
        }else{
            insertAnimation = UITableViewRowAnimation.Bottom
            deleteAnimation = UITableViewRowAnimation.Top
        }
        
        // 应用单元格的更新
        self.mainhouseTableView.beginUpdates()
        self.mainhouseTableView.deleteRowsAtIndexPaths(indexPathsToDelete as [AnyObject], withRowAnimation: deleteAnimation)
        self.mainhouseTableView.insertRowsAtIndexPaths(indexPathsToInsert as [AnyObject], withRowAnimation: insertAnimation)
        
        self.opensectionindex = sectionOpened

        self.mainhouseTableView.endUpdates()
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int) {
        
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        var sectionInfo: SectionInfo = self.sectionInfoArray[sectionClosed] as! SectionInfo
        
        sectionInfo.open = false
        var countOfRowsToDelete = self.mainhouseTableView.numberOfRowsInSection(sectionClosed)
        
        if countOfRowsToDelete > 0 {
            var indexPathsToDelete = NSMutableArray()
            for (var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: sectionClosed))
            }
            self.mainhouseTableView.deleteRowsAtIndexPaths(indexPathsToDelete as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
        }
        self.opensectionindex = NSNotFound
    }
    
    
    
    func played() -> NSArray {
        
        if playe == nil {
            
            var url = NSBundle.mainBundle().URLForResource("MainHouseName", withExtension: "plist")
            var playDictionariesArray = NSArray(contentsOfURL: url!)
            playe = NSMutableArray(capacity: playDictionariesArray!.count)
            
            //playDictionary每个养老院
            for playDictionary in playDictionariesArray! {
                
                var play: Play! = Play()
                play.name = playDictionary["HouseName"] as! String

                var partnameDictionaries:NSArray = playDictionary["PartNames"] as! NSArray
                var parts = NSMutableArray(capacity: partnameDictionaries.count)
                 //每个科室封装成part对象
                for partDictionary in partnameDictionaries {
                    
                    var partDic:NSDictionary = partDictionary as! NSDictionary
                   var part: Part = Part()
                    
                    part.setValuesForKeysWithDictionary(partDic as [NSObject : AnyObject])
                    parts.addObject(part)
                }
                play.partnames = parts
                playe!.addObject(play)

            }
        }
        
        return playe!
    }
}


protocol ChoosePartDelegate{
    func ChoosePart(partcode:String,partname:String,mainname:String)
}
