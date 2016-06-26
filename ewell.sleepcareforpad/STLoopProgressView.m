//
//  STLoopProgressView.m
//  STLoopProgressView
//
//  Created by TangJR on 6/29/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//


#import "STLoopProgressView+BaseConfiguration.h"

//#define SELF_WIDTH CGRectGetWidth(self.bounds)
//#define SELF_HEIGHT CGRectGetHeight(self.bounds)

@interface STLoopProgressView ()

@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩
@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer; // 蓝色背景遮罩

- (void)addCircleView:(CGRect)frame withdefaultcolor:(UIColor *)defaultColor withstartcolor:(UIColor*)startColor withcentercolor:(UIColor*)centerColor withendcolor:(UIColor*)endColor withlinewidth:(CGFloat)linewidth;

//自定义初始化设置
//@property (nonatomic,strong)IBInspectable UIColor *startColor;// 起始颜色
//@property (nonatomic,strong)IBInspectable UIColor *centerColor;// 中间过渡颜色
//@property (nonatomic,strong)IBInspectable UIColor *endColor;// 结束颜色
//@property (nonatomic,strong)IBInspectable UIColor *defaultbackgroundColor;// 空环背景颜色
//
//@property (nonatomic,assign)IBInspectable CGFloat lineWidth; // 线宽



@end

//IB_DESIGNABLE

@implementation STLoopProgressView

- (void)addCircleView:(CGRect)frame withdefaultcolor:(UIColor*)defaultColor withstartcolor:(UIColor*)startColor withcentercolor:(UIColor*)centerColor withendcolor:(UIColor*)endColor withlinewidth:(CGFloat)linewidth{
    
 
    
    self.backgroundColor = defaultColor;
    _defaultbackgroundColor = defaultColor;
    _centerColor = centerColor;
    _endColor = endColor;
    _startColor = startColor;
    _lineWidth = linewidth;
    
    
    self.frame = frame;
    
  //  NSLog(@"%@",NSStringFromCGRect(self.frame));
  
    [self setupColorLayer];
    [self setupColorMaskLayer];
    [self setupBlueMaskLayer];
}


/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}

/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
 
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];

    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2,self.bounds.size.height);
    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.9, @1];
    leftLayer.colors = @[(id)_centerColor.CGColor, (id)_startColor.CGColor];
    [self.colorLayer addSublayer:leftLayer];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.locations = @[@0.3, @0.9, @1];
    rightLayer.colors = @[(id)_centerColor.CGColor, (id)_endColor.CGColor];
    [self.colorLayer addSublayer:rightLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = _lineWidth + 0.5; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    
    UIBezierPath *path = nil;
    if ([STLoopProgressView clockWiseType]) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:self.bounds.size.width / 2.5 startAngle:[STLoopProgressView startAngle] endAngle:[STLoopProgressView endAngle] clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2.5 startAngle:[STLoopProgressView endAngle] endAngle:[STLoopProgressView startAngle] clockwise:NO];
    }
    
    layer.lineWidth = _lineWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

/**
 *  在修改百分比的时候，修改彩色遮罩的大小
 *
 *  @param persentage 百分比
 */
- (void)setPersentage:(CGFloat)persentage {
    
    _persentage = persentage;
    self.colorMaskLayer.strokeEnd = persentage;
}

@end