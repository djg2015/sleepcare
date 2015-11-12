//
//  IRegistViewController.swift
//
//
//  Created by djg on 15/11/12.
//
//

import UIKit

class IRegistViewController: UIViewController,PopDownListItemChoosed {
    @IBOutlet weak var btnBack: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    @IBOutlet weak var btnChooseRole: UIButton!
    var popDownListForIphone:PopDownListForIphone?
    override func viewDidLoad() {
        super.viewDidLoad()
        rac_settings()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.btnRegist!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                
        }
        
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.btnChooseRole!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                var source:Array<PopDownListItem> = Array<PopDownListItem>()
                var item1 = PopDownListItem()
                item1.key = "1"
                item1.value = "养老院1"
                source.append(item1)
                var item2 = PopDownListItem()
                item2.key = "1"
                item2.value = "养老院1"
                source.append(item2)
                if(self.popDownListForIphone == nil){
                    
                    self.popDownListForIphone = PopDownListForIphone()
                    self.popDownListForIphone?.delegate = self
                }
                self.popDownListForIphone?.Show("选择养老院/医院", source: source)
        }
    }
    
    func ChoosedItem(item:PopDownListItem){
        
    }

    
    
}
