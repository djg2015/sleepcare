//
//  CircularLoaderView.swift
//  FirstWindo
//
//  Created by zhaoyin on 15/11/11.
//  Copyright (c) 2015年 zhaoyin. All rights reserved.
//

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
    // 圆下方位置显示的文字
    var bottomTitle:String = "当前呼吸"
    // 最大长度
    var maxProcess:CGFloat = 10.0
    // 当前进度
    var currentProcess:CGFloat = 0.0
    
    // 构造
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    // 构造
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // 配置圆
    func configure() {
        // 当前控件的运行空间
        self.frame = bounds
        // 根据当前控件宽度计算出圆的半径
        self.circleRadius = (CGFloat)(bounds.width / 2)
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        // 线的线边冒改为圆形
        circlePathLayer.lineCap = kCALineCapRound
        // 填充色
        circlePathLayer.fillColor = self.fillColor
        // 圆的边线色
        circlePathLayer.strokeColor = self.strokeColor
        layer.addSublayer(circlePathLayer)
        
        circlePathLayerBig.frame = bounds
        circlePathLayerBig.lineWidth = 7
        circlePathLayerBig.lineCap = kCALineCapRound
        circlePathLayerBig.fillColor = self.fillColor
        circlePathLayerBig.strokeColor = self.strokeColor
        layer.addSublayer(circlePathLayerBig)
        
        // 添加圆中心位置的文字
        var centerView = UIView(frame: CGRect(x: 0, y: 20, width: bounds.width, height: bounds.height - 30))
        //        var centerTxt = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width - self.circleRadius))
        //        centerTxt.textAlignment = .Center
        //        centerTxt.adjustsFontSizeToFitWidth = true
        //        centerTxt.font = UIFont.boldSystemFontOfSize(24)
        //        centerTxt.textColor = UIColor.whiteColor()
        //        centerTxt.text = "12321321"
        //        centerView.addSubview(centerTxt)
        //        centerView.backgroundColor = UIColor.yellowColor()
        self.addSubview(centerView)
        
        var bottomTxt = UILabel(frame: CGRect(x: self.circleRadius - 60/2, y: bounds.height - 30, width: 60, height: 30))
        bottomTxt.adjustsFontSizeToFitWidth = true
        bottomTxt.font = UIFont.boldSystemFontOfSize(18)
        bottomTxt.textColor = UIColor.whiteColor()
        bottomTxt.text = self.bottomTitle
        self.addSubview(bottomTxt)
        
        backgroundColor = UIColor.clearColor()
    }
    
    // 绘制内圆
    func circlePath() -> UIBezierPath {
        //        return UIBezierPath(ovalInRect: circleFrame())
        return UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(circlePathLayer.bounds),y: CGRectGetMidY(circlePathLayer.bounds)), radius: circleRadius, startAngle: (CGFloat)(M_PI / 2 + M_PI / 6), endAngle: (CGFloat)(M_PI * 2 + M_PI / 2 - M_PI / 6), clockwise: true)
    }
    
    // 绘制外圆
    func circlePath1() -> UIBezierPath {
        //        return UIBezierPath(ovalInRect: circleFrame())
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
        circlePathLayer.cornerRadius = 0.5
        circlePathLayerBig.path = circlePath1().CGPath
        circlePathLayerBig.cornerRadius = 0.5
    }
}
