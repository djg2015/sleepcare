//
//  IWebViewController.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/26/16.
//  Copyright (c) 2016 djg. All rights reserved.
//
import UIKit

class IWebViewController: IBaseViewController {
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webContent: UIWebView!
    var URLstring:String = ""
    var titleName:String = ""
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,titleName:String,url:String) {
        super.init(nibName: nibNameOrNil,bundle:nibBundleOrNil)
        self.titleName = titleName
        self.URLstring = url
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeColor[themeName]
        self.lblTitle.text = self.titleName
        
        //发出请求，打开url网页
        var URL = NSURL(string:self.URLstring)
        var request = NSURLRequest(URL:URL!)
        self.webContent.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func ClickBack(sender:AnyObject){
         IViewControllerManager.GetInstance()!.CloseViewController()
        
    }
    
}
