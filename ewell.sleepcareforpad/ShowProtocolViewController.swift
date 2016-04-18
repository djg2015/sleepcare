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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    self.webContent = WKWebView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-44))
        self.view.addSubview(self.webContent)
        //发出请求，打开url网页
        var URL = NSURL(string:"http://www.usleepcare.com/app/protocol.aspx")
        var request = NSURLRequest(URL:URL!)
        self.webContent.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.webContent = nil
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
