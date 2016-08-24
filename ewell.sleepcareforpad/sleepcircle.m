//
//  sleepcircle.m
//  
//
//  Created by Qinyuan Liu on 8/18/16.
//
//
#import "sleepcircle.h"

@interface sleepcircle()
@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *lshapeLayer;
@property(strong,nonatomic)CAShapeLayer *dshapeLayer;
@property(strong,nonatomic)CAShapeLayer *ashapeLayer;

@property(strong,nonatomic)CAShapeLayer *bgLayer;

@end

@implementation sleepcircle


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    CGAffineTransform transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformRotate(transform, M_PI / 2);
    
       return self;
}


-(void) drawcircle
{
    if (self) {
        _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = _lineWidth;
        _bgLayer.strokeColor = [UIColor colorWithRed:245/255.0 green: 245/255.0 blue: 245/255.0 alpha:0.5].CGColor;
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = 1.f;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];
        
      
        _dshapeLayer = [CAShapeLayer layer];
        _dshapeLayer.frame = self.bounds;
        _dshapeLayer.fillColor = [UIColor clearColor].CGColor;
        _dshapeLayer.lineWidth = _lineWidth;
        _dshapeLayer.lineCap = kCALineCapRound;
        _dshapeLayer.strokeColor = _deepsleeplineColor.CGColor;
        _dshapeLayer.strokeStart = 0.f;
        _dshapeLayer.strokeEnd = _deepsleepvalue;
        _dshapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_dshapeLayer];
        
        
        _lshapeLayer = [CAShapeLayer layer];
        _lshapeLayer.frame = self.bounds;
        _lshapeLayer.fillColor = [UIColor clearColor].CGColor;
        _lshapeLayer.lineWidth = _lineWidth;
        _lshapeLayer.lineCap = kCALineCapRound;
        _lshapeLayer.strokeColor = _lightsleeplineColor.CGColor;
        _lshapeLayer.strokeStart = _deepsleepvalue;
        _lshapeLayer.strokeEnd = _lightsleepvalue+_deepsleepvalue;
        _lshapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_lshapeLayer];
        
        _ashapeLayer = [CAShapeLayer layer];
        _ashapeLayer.frame = self.bounds;
        _ashapeLayer.fillColor = [UIColor clearColor].CGColor;
        _ashapeLayer.lineWidth = _lineWidth;
        _ashapeLayer.lineCap = kCALineCapRound;
        _ashapeLayer.strokeColor = _awakelineColor.CGColor;
        _ashapeLayer.strokeStart = _deepsleepvalue+_lightsleepvalue;
        _ashapeLayer.strokeEnd = _lightsleepvalue+_deepsleepvalue+_awakevalue;
        _ashapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_ashapeLayer];
        
        
    }

}

@synthesize lightsleepvalue = _lightsleepvalue;
-(void)setLightSleepValue:(CGFloat)lightsleepvalue{
    _lightsleepvalue = lightsleepvalue;
    _lshapeLayer.strokeEnd = lightsleepvalue;
    
}
-(CGFloat)lightsleepvalue{
    return _lightsleepvalue;
}

@synthesize lightsleeplineColor = _lightsleeplineColor;
-(void)setLightSleepLineColor:(UIColor *)lightsleeplineColor{
    _lightsleeplineColor = lightsleeplineColor;
    _lshapeLayer.strokeColor = lightsleeplineColor.CGColor;
}
-(UIColor*)lightsleeplineColor{
    return _lightsleeplineColor;
}

@synthesize deepsleepvalue = _deepsleepvalue;
-(void)setDeepSleepValue:(CGFloat)deepsleepvalue{
    _deepsleepvalue = deepsleepvalue;
    _dshapeLayer.strokeEnd = deepsleepvalue;
    
}
-(CGFloat)deepsleepvalue{
    return _deepsleepvalue;
}

@synthesize deepsleeplineColor = _deepsleeplineColor;
-(void)setDeepSleepLineColor:(UIColor *)deepsleeplineColor{
    _deepsleeplineColor = deepsleeplineColor;
    _dshapeLayer.strokeColor = deepsleeplineColor.CGColor;
}
-(UIColor*)deepsleeplineColor{
    return _deepsleeplineColor;
}

@synthesize awakevalue = _awakevalue;
-(void)setAwakeValue:(CGFloat)awakevalue{
    _awakevalue = awakevalue;
    _ashapeLayer.strokeEnd = awakevalue;
    
}
-(CGFloat)awakevalue{
    return _awakevalue;
}

@synthesize awakelineColor = _awakelineColor;
-(void)setAwakeLineColor:(UIColor *)awakelineColor{
    _awakelineColor = awakelineColor;
    _ashapeLayer.strokeColor = awakelineColor.CGColor;
}
-(UIColor*)awakelineColor{
    return _awakelineColor;
}


@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
   
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}

@end