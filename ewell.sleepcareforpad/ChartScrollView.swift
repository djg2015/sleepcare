//
//  ChartScrollView.swift
//  
//
//  Created by Qinyuan Liu on 6/12/16.
//
//

import UIKit

class ChartScrollView: UIScrollView {
    var chartView1 = ChartView()
    var chartView2 = ChartView()
    var chartView3 = ChartView()

 
   
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(!self.dragging){
            print("ok1")
            self.nextResponder()?.touchesBegan(touches, withEvent: event)
            
            
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(!self.dragging){
             print("ok3")
          self.nextResponder()?.touchesEnded(touches, withEvent: event)
  
          
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
 
    
   
    
}
