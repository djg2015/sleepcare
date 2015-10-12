//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainController: BaseViewController,UIScrollViewDelegate {
    //界面控件
   
    @IBOutlet weak var curPager: Pager!
    @IBOutlet weak var search: UISearchBar!
    //类字段
     var mainScroll:UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScroll = UIScrollView()
        
        self.mainScroll.backgroundColor = UIColor.clearColor()
        self.mainScroll.frame = self.view.frame
        self.mainScroll.frame.origin.y = 170
        self.mainScroll.frame.size.height = 500
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = false
        self.mainScroll.delegate = self
        self.mainScroll.bounces = false
        self.view.addSubview(self.mainScroll)
        
        self.mainScroll.contentSize = CGSize(width: self.view.bounds.size.width * 2, height: 500)
        
        let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).last as! SleepCareCollectionView
        mainview1.frame = CGRectMake(0, 0, 1024, self.mainScroll.frame.size.height)
        //self.mainview = SleepCareCollectionView(frame: CGRectMake(0, 0, 300, 400), collectionViewLayout: UICollectionViewLayout())
        mainview1.reloadData()
        self.mainScroll.addSubview(mainview1)
        self.mainScroll.bringSubviewToFront(mainview1)
        
        let mainview2 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).last as! SleepCareCollectionView
        mainview2.frame = CGRectMake(1024, 0, 1024, self.mainScroll.frame.size.height)
        //self.mainview = SleepCareCollectionView(frame: CGRectMake(0, 0, 300, 400), collectionViewLayout: UICollectionViewLayout())
        mainview2.reloadData()
        self.mainScroll.addSubview(mainview2)
        self.mainScroll.bringSubviewToFront(mainview2)
        
        //去掉搜索按钮背景
         //self.search.backgroundColor = UIColor(patternImage: UIImage(named:"transbg.png")!)
        for(var i = 0 ; i < self.search.subviews[0].subviews.count; i++) {
            println(self.search.subviews[0].subviews[i])
            if(self.search.subviews[0].subviews[i].isKindOfClass(NSClassFromString("UISearchBarBackground"))){
                self.search.subviews[0].subviews[i].removeFromSuperview()
            }
        }
        
        //设置分页控件
        self.curPager.pageCount = 3
        self.curPager.go()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
