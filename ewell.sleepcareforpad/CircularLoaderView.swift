//
//  CircularLoaderView.swift
//  FirstWindo
//
//  Created by zhaoyin on 15/11/11.
//  Copyright (c) 2015年 zhaoyin. All rights reserved.
//

let LOWCOLOR:UIColor = UIColor.colorFromRGB(0xEF8626)
let MEDIUMCOLOR:UIColor = UIColor.colorFromRGB(0x44A355)
let HIGHCOLOR:UIColor = UIColor.redColor()

import Foundation
import UIKit

class CircularLoaderView: UIView {
    // 最内侧的圆
    let circlePathLayer = CAShapeLayer()
    // 最外侧的圆
    let circlePathLayerBig = CAShapeLayer()
    // 当前圆的半径
    private var circleRadius: CGFloat = 0.0
    // 填充色 默认为透明
    var fillColor:CGColor = UIColor.clearColor().CGColor
    // 圆的边线色 默认为白色
    var strokeColor:CGColor = UIColor.whiteColor().CGColor
    // 圆中心位置显示的文字
    var centerTitleView:UIView?
    private var bottomTxt:UILabel?
    // 圆下方位置显示的文字
    @IBInspectable var bottomTitle:String = "当前呼吸" {
        didSet{
            if(nil == bottomTxt)
            {
                bottomTxt = UILabel(frame: CGRect(x: self.circleRadius - 60/2, y: bounds.height - 30, width: 60, height: 30))
                bottomTxt!.adjustsFontSizeToFitWidth = true
                bottomTxt!.font = UIFont.boldSystemFontOfSize(18)
                bottomTxt!.textColor = UIColor.whiteColor()
                
                self.addSubview(bottomTxt!)
            }
            bottomTxt!.text = self.bottomTitle
        }
        
    }
    // 最大长度
    @IBInspectable var maxProcess:CGFloat = 10.0 {
        didSet{
            self.layoutSubviews()
        }
        
    }
    // 当前进度
    @IBInspectable var currentProcess:CGFloat = 0.0 {
        didSet{
            self.layoutSubviews()
        }
        
    }
    // 构造
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    // 构造
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    // 配置圆
    func configure() {
        // 当前控件的运行空间
        self.frame = bounds
        // 根据当前控件宽度计算出圆的半径
        self.circleRadius = (CGFloat)(bounds.width / 2)
        self.circlePathLayer.frame = bounds
        self.circlePathLayer.lineWidth = 2
        // 线的线边冒改为圆形
        self.circlePathLayer.lineCap = kCALineCapRound
        // 填充色
        self.circlePathLayer.fillColor = self.fillColor
        // 整圆的边线色
        self.circlePathLayer.strokeColor = self.strokeColor
        layer.addSublayer(self.circlePathLayer)
        //动态的圆圈边线
        self.circlePathLayerBig.frame = bounds
        self.circlePathLayerBig.lineWidth = 7
        self.circlePathLayerBig.lineCap = kCALineCapRound
        self.circlePathLayerBig.fillColor = self.fillColor
        self.circlePathLayerBig.strokeColor = self.strokeColor //LOWCOLOR.CGColor
        layer.addSublayer(self.circlePathLayerBig)
        
        // 添加圆中心位置的文字
        if(nil == self.centerTitleView)
        {
            self.centerTitleView = UIView(frame: CGRect(x: 0, y: 20, width: bounds.width, height: bounds.height - 30))
        }
        self.addSubview(self.centerTitleView!)
        
        backgroundColor = UIColor.clearColor()
    }
    
    // 绘制内圆
    func circlePath() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(circlePathLayer.bounds),y: CGRectGetMidY(circlePathLayer.bounds)), radius: circleRadius, startAngle: (CGFloat)(M_PI / 2 + M_PI / 6), endAngle: (CGFloat)(M_PI * 2 + M_PI / 2 - M_PI / 6), clockwise: true)
    }
    
    // 绘制外圆
    func circlePath1() -> UIBezierPath {
        self.SetCircleColor()
        
        var v = (Double)(5 / 3 * (Double)(self.currentProcess / self.maxProcess))
        if(v == 0)
        {
            return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(circlePathLayer.bounds),y: CGRectGetMidY(circlePathLayer.bounds)), radius: circleRadius, startAngle: (CGFloat)(M_PI / 2 + M_PI / 6), endAngle: (CGFloat)(M_PI / 2 + M_PI / 6), clockwise: true)
        }
        else
        {
            return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(circlePathLayer.bounds),y: CGRectGetMidY(circlePathLayer.bounds)), radius: circleRadius, startAngle: (CGFloat)(M_PI / 2 + M_PI / 6), endAngle: (CGFloat)(2 * M_PI / 3 + M_PI * v), clockwise: true)
        }
    }
    
    //给睡眠页面的外圆上色
    func SetCircleColor(){
        switch bottomTitle{
        case "当前呼吸":
            if currentProcess < 10.0{
            self.circlePathLayerBig.strokeColor = LOWCOLOR.CGColor
            }
            else if currentProcess < 30.0{
             self.circlePathLayerBig.strokeColor = MEDIUMCOLOR.CGColor
            }
            else {
            self.circlePathLayerBig.strokeColor = HIGHCOLOR.CGColor
            }
        case "当前心率":
            if currentProcess < 50.0{
                self.circlePathLayerBig.strokeColor = LOWCOLOR.CGColor
            }
            else if currentProcess < 100.0{
                self.circlePathLayerBig.strokeColor = MEDIUMCOLOR.CGColor
            }
            else {
                self.circlePathLayerBig.strokeColor = HIGHCOLOR.CGColor
            }
        case "睡眠状态":
            if currentProcess < 30.0{
                self.circlePathLayerBig.strokeColor = LOWCOLOR.CGColor
            }
            else {
                self.circlePathLayerBig.strokeColor = MEDIUMCOLOR.CGColor
            }

        default:
            break
        }
    }
    
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circlePathLayer.frame = bounds
        self.circlePathLayer.path = circlePath().CGPath
        self.circlePathLayer.cornerRadius = 0.5
        self.circlePathLayerBig.path = circlePath1().CGPath
        self.circlePathLayerBig.cornerRadius = 0.5
    }
}
