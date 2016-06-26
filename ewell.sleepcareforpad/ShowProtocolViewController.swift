//
//  ShowProtocolViewController.swift
//  
//
//  Created by Qinyuan Liu on 4/18/16.
//
//

import UIKit

class ShowProtocolViewController: UIViewController {

    var webContent:WKWebView!
    var webContentUnder8:UIWebView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let URL = NSURL(string:"http://www.usleepcare.com/app/protocol.aspx")
        let request = NSURLRequest(URL:URL!)
        
        switch  UIDevice.currentDevice().systemVersion.compare( "8.0.0" , options: NSStringCompareOptions.NumericSearch) {
        case  .OrderedSame, .OrderedDescending:
            // "iOS >= 8.0"
            self.webContent = WKWebView(frame: CGRectMake(0, 60, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-60))
            self.view.addSubview(self.webContent)
            //发出请求，打开url网页
            self.webContent.loadRequest(request)
        case  .OrderedAscending:
            // "iOS < 8.0"
            self.webContentUnder8 = UIWebView(frame:CGRectMake(0, 60, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-60))
            self.view.addSubview(self.webContentUnder8)
            self.webContentUnder8.loadRequest(request)
        default:
            break
            //        self.webContent = WKWebView(frame: CGRectMake(0, 60, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-60))
            //        self.view.addSubview(self.webContent)
            //        //发出请求，打开url网页
            //        var URL = NSURL(string:"http://www.usleepcare.com/app/help.aspx")
            //        var request = NSURLRequest(URL:URL!)
            //        self.webContent.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.webContent = nil
        // Dispose of any resources that can be recreated.
    }

    
}
