//
//  ChatLine.m
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//
#import "ChatLineView.h"
#import "PointBtn.h"
#define rowNum 5
#define distanceToBtm 15

//#define verticalSpace 0.065
#define distanceToLeft 0


@interface ChatLineView()
/**
 *  间隔数值
 */
@property(nonatomic,assign)CGFloat spaceValue;


@property(nonatomic, strong) NSMutableArray *yValueArr;

@property(nonatomic, strong) UIColor *selectColor;

@property(nonatomic, assign) CGFloat horizontalSpace;

@property(nonatomic, assign) int level;

@property(nonatomic, strong) NSMutableArray *pointArr;

@property(nonatomic, assign) int minValue;

@property(nonatomic, assign) float verticalSpace;
@end

@implementation ChatLineView

-(NSMutableArray *)pointArr{
    if(!_pointArr){
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

-(NSMutableArray *)yValueArr{
    if(!_yValueArr){
        self.yValueArr = [NSMutableArray array];
    }
    return _yValueArr;
}

//绘制图形
- (void)drawRect:(CGRect)rect {
    //适配机型
    [self autoGetScale];
    
    self.verticalSpace = 1.0/(self.xValueArr.count+1);
    //1绘制纵轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor]set];
    NSString *unitYStr = self.unitYStr;
    
    UIFont *font = [UIFont systemFontOfSize:11.0];//设置
    //  NSDictionary *dict = @{NSFontAttributeName:font};
    
    //  [unitYStr drawInRect:CGRectMake(distanceToLeft,0,100,10) withAttributes:dict];
    [unitYStr drawInRect:CGRectMake(distanceToLeft,8,100,10) withFont:font];
    for (int i = 0 ; i < self.valueArr.count ; i++) {
        if(i == 0 ){
            if ([self.chartType isEqual: @"4"]){
                [[UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
            }
            else if ([self.chartType isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
                [[UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0];
                
            }
            else{
                [[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                
            }
        }else if (i == 1){
            if ([self.chartType isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
                [[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                
            }
            else if([self.chartType isEqual: @"1"]){
                [[UIColor colorWithRed:86/255.0 green:163/255.0 blue: 253/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:86/255.0 green:163/255.0 blue: 253/255.0 alpha:1.0];
                
            }
        }
        else if(i==2){
            
            [[UIColor colorWithRed:125/255.0 green: 249/255.0 blue: 60/255.0 alpha:1.0] set];
            self.selectColor = [UIColor colorWithRed:125/255.0 green: 249/255.0 blue: 60/255.0 alpha:1.0];
        }
        
        
//        //平均心率／呼吸／睡眠的标题设置,右上角
//        float x = [UIScreen mainScreen].bounds.size.width-10-(i+1)*65;
//        float y = 16;
//        PointBtn *showPoint = [[PointBtn alloc]initWithFrame:CGRectMake(x-4 , y-4 , 7, 7)];
//        [showPoint setBackgroundImage:[UIImage imageNamed:@"circlepoint"] forState:UIControlStateNormal];
//        showPoint.backgroundColor = self.selectColor;
//        showPoint.layer.cornerRadius = 4;
//        showPoint.layer.masksToBounds = YES;
//        showPoint.userInteractionEnabled = NO;
//        [self addSubview:showPoint];
//        
//        //        //self.yearArr[i]圆圈代表什么
//        [self.yearArr[i] drawInRect:CGRectMake( x+10,8,50,10) withFont:font];
    }
    
    
    //self.yValueArr[i]纵坐标值
    [[UIColor lightGrayColor] set];
    for (int i = 0 ; i < self.yValueArr.count ; i++) {
        [self.yValueArr[i] drawInRect:CGRectMake(distanceToLeft,(self.yValueArr.count - i) * self.horizontalSpace,30,10) withFont:font];
    }
    
    //1.1绘制虚线
    [[UIColor colorWithRed:245/255.0 green: 245/255.0 blue: 245/255.0 alpha:1.0] set];
    for (int i = 0 ; i < self.yValueArr.count ; i++) {
        CGContextMoveToPoint(context, distanceToLeft + 20, (self.yValueArr.count - i) * self.horizontalSpace + 10);
        CGContextAddLineToPoint(context, (self.xValueArr.count + 3) * (rect.size.width * self.verticalSpace), (self.yValueArr.count - i) * self.horizontalSpace + 10);
        //这里为其单独设置虚线
        //      CGFloat lengths[] = {3,1};
        //      CGContextSetLineDash(context, 0, lengths, 2);
        CGContextStrokePath(context);
    }
    
    //2绘制横轴
    [[UIColor lightGrayColor] set];
    for (int i = 0 ; i < self.xValueArr.count ; i++) {
        //15+个x值，每隔2个点选一个标记在chart里
        if(self.xValueArr.count>14){
            if(i%2 == 1){
                [self.xValueArr[i] drawInRect:CGRectMake((i + 0.7) * (rect.size.width * self.verticalSpace),(self.yValueArr.count + 1) * self.horizontalSpace ,20 ,10) withFont:font];
            }
        }
        else if(self.xValueArr.count<5){
            [self.xValueArr[i] drawInRect:CGRectMake((i + 1) * (rect.size.width * self.verticalSpace),(self.yValueArr.count + 1) * self.horizontalSpace ,20 ,10) withFont:font];
        }
        else{
            [self.xValueArr[i] drawInRect:CGRectMake((i + 0.7) * (rect.size.width * self.verticalSpace),(self.yValueArr.count + 1) * self.horizontalSpace ,20 ,10) withFont:font];
        }
    }
    

    
    //3绘制点： else表示第二条折线的颜色
    for (int i = 0 ; i < self.valueArr.count ; i++) {
        NSArray *subArr = self.valueArr[i];
        if(i == 0 ){
            if ([self.chartType isEqual: @"4"]){
                [[UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
            }
            else if ([self.chartType isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
                [[UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0];
                
            }
            else{
                [[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                
            }
        }else if (i == 1){
            if ([self.chartType isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
                [[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                
            }
            else if([self.chartType isEqual: @"1"]){
                [[UIColor colorWithRed:86/255.0 green:163/255.0 blue: 253/255.0 alpha:1.0] set];
                self.selectColor = [UIColor colorWithRed:86/255.0 green:163/255.0 blue: 253/255.0 alpha:1.0];
                
            }
        }
        else if(i==2){
            
            [[UIColor colorWithRed:125/255.0 green: 249/255.0 blue: 60/255.0 alpha:1.0] set];
            self.selectColor = [UIColor colorWithRed:125/255.0 green: 249/255.0 blue: 60/255.0 alpha:1.0];
        }
        
        
        
        //给点添加事件,scrollview中被scrollview的屏幕触碰方法截获，需要用touche方法传递到chartlineview类
        for (int j = 0 ; j < subArr.count ; j++) {
            
      
             float y = (self.yValueArr.count -  [subArr[j] floatValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
            float x =  (j + 1) * (rect.size.width * self.verticalSpace)-8 ;
            
            //test1 x-4
            PointBtn *clickBtn = [[PointBtn alloc]initWithFrame:CGRectMake(x+4 , y - 4, 7, 7)];
            [clickBtn setBackgroundImage:[UIImage imageNamed:@"circlepoint"] forState:UIControlStateNormal];
            clickBtn.yearStr = self.yearArr[i];
            clickBtn.valueStr = subArr[j];
            clickBtn.monthStr = [NSString stringWithFormat:@"%d",j + 1];
            //    [clickBtn addTarget:self action:@selector(pointClick:) forControlEvents:UIControlEventTouchUpInside];
            clickBtn.tag = j;
            clickBtn.backgroundColor = self.selectColor;
            
            
            clickBtn.layer.cornerRadius = 4;
            clickBtn.layer.masksToBounds = YES;
            [self addSubview:clickBtn];
            [self.pointArr addObject:clickBtn];
            
        }
       
        //绘制蒙版
        //4绘制折线
        float firstY = (self.yValueArr.count -  0 / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
        float firstX =   1 * (rect.size.width * self.verticalSpace);
        CGContextMoveToPoint(context, firstX, firstY);
        for (int j = 0 ; j < subArr.count ; j++) {
            float y = (self.yValueArr.count -  [subArr[j] floatValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
            float x =  (j + 1) * (rect.size.width * self.verticalSpace) ;
            if(j == 0){
                CGContextMoveToPoint(context, x, y);
            }else{
                CGContextAddLineToPoint(context, x, y);
            }
        }
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineDash(context, 0, 0, 0);
        CGContextStrokePath(context);
        
        
        if(![self.chartType isEqual: @"6"]){
            //绘制蒙版
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            CGMutablePathRef path = CGPathCreateMutable();
            //1.起始点
            CGPathMoveToPoint(path, NULL, firstX, firstY);
            for (int j = 0 ; j < subArr.count ; j++) {
                float y = (self.yValueArr.count -  [subArr[j] floatValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
                float x =  (j +1) * (rect.size.width * self.verticalSpace);
                CGPathAddLineToPoint(path, NULL, x, y);
            }
            
            //2.绘制终点
            float lastY = (self.yValueArr.count -  0 / (self.spaceValue * self.level) ) * self.horizontalSpace + 6;
            float lastX =  (subArr.count ) * (rect.size.width * self.verticalSpace);
            CGPathAddLineToPoint(path, NULL, lastX, lastY);
            CGContextSetLineWidth(context1, 2.0);
            CGContextSetLineDash(context1, 0, 0, 0);
            
            
            if(i == 0 ){
                if ([self.chartType isEqual: @"4"]){
                    [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                    
                }
                else if ([self.chartType isEqual: @"3"] || [self.chartType isEqual: @"6"]){
                    [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                }
                else{
                    [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                    
                }
            }else if (i == 1){
                if ([self.chartType isEqual: @"3"] || [self.chartType isEqual: @"6"]){
                    [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                }
                else if ([self.chartType isEqual: @"1"] ){
                    [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:86/255.0 green: 163/255.0 blue: 253/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                }
                
            }
            else if(i==2){
                
                [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:125/255.0 green: 249/255.0 blue: 60/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
                
            }
        }
    }
    
}

-(void)setValueArr:(NSArray *)valueArr{
    _valueArr = valueArr;
    //找出所有数组中的最大值与最小值
    float maxValue = 0.0;
    NSString *minStrValue = self.valueArr[0][0];
    float minValue = [minStrValue floatValue];
    for (int i = 0 ; i < self.valueArr.count; i++) {
        NSArray *subArr = self.valueArr[i];
        for (int j = 0 ; j < subArr.count ; j++) {
            float compareValue = [subArr[j] floatValue];
            if(maxValue < compareValue){
                maxValue = compareValue;
            }
            if(minValue > compareValue){
                minValue = compareValue;
            }
        }
    }
    if (maxValue > 0.0){
        
        self.spaceValue = (maxValue  / [self getUnitWithMaxValue:maxValue]) / (rowNum) ;
        
    }
    else {
        self.spaceValue = 10;
        self.level = 1;
        if ( [self.chartType  isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
            self.unitYStr = @"睡眠周期(时/日)";
        }
        //离床
        else if ([self.chartType  isEqual: @"4"]){
            self.unitYStr = @"离床(次/日)";
        }
        //心率，呼吸
        else if ([self.chartType  isEqual: @"1"]){
            self.unitYStr = @"心率(次/分)";
        }
        else if ([self.chartType  isEqual: @"2"]){
            self.unitYStr = @"呼吸(次/分)";
        }
    }
    int spaceInt = ceil(self.spaceValue);
    self.spaceValue = ceil(self.spaceValue);
    if (self.spaceValue<1.0){
        
        for (int i = 0 ; i <rowNum + 1; i++) {
                NSString *value2 = [NSString stringWithFormat:@"%d", i];
                [self.yValueArr addObject:value2];
                  }
    }
    else{
    for (int i = 0 ; i < rowNum + 1; i++) {
        NSString *value = [NSString stringWithFormat:@"%d",spaceInt * i];
        [self.yValueArr addObject:value];
    }
    }
}


-(void)pointClick:(PointBtn *)clickBtn{
    /**
     *年
     */
    CGPoint btnOrigin = clickBtn.frame.origin;
    UIColor *defaultColor = clickBtn.backgroundColor;
 
  
    UILabel *moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(btnOrigin.x, btnOrigin.y-25,30, 20)];
    moneyLable.text = [NSString stringWithFormat:@"%@",clickBtn.valueStr];
    
    //点击圆圈后，颜色根据值变化
    if([self.chartType isEqualToString:@"1"]){
        if ([clickBtn.valueStr intValue]<=0){
            moneyLable.textColor = [UIColor grayColor];
            clickBtn.backgroundColor = [UIColor grayColor];
        }
        else if([clickBtn.valueStr intValue]<=80){
            moneyLable.textColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1];
            clickBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1];
        }
        else{
            moneyLable.textColor = [UIColor redColor];
            clickBtn.backgroundColor = [UIColor redColor];
        }
    }
    else if ([self.chartType isEqualToString:@"2"]){
        if ([clickBtn.valueStr intValue]<=0){
            moneyLable.textColor = [UIColor grayColor];
            clickBtn.backgroundColor = [UIColor grayColor];
        }
        else if([clickBtn.valueStr intValue]<=40){
            moneyLable.textColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1];
            clickBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:0.1];
        }
        else{
            moneyLable.textColor = [UIColor redColor];
            clickBtn.backgroundColor = [UIColor redColor];
        }
        
    }
    else if ([self.chartType isEqualToString:@"3"]){
        if ([clickBtn.valueStr intValue]<=0){
            moneyLable.textColor = [UIColor grayColor];
            clickBtn.backgroundColor = [UIColor grayColor];
        }
        else {
            moneyLable.textColor = [UIColor blueColor];
            clickBtn.backgroundColor = [UIColor blueColor];
        }
        
        
    }
    
    
    [moneyLable sizeToFit];
    
    [self addSubview:moneyLable];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        moneyLable.alpha = 0;
        clickBtn.backgroundColor = defaultColor;
     
    });
}


-(void)autoGetScale{
    
    self.horizontalSpace = self.frame.size.height / 8  ;
}


-(int )getUnitWithMaxValue:(int )maxValue{

    //睡眠
    self.level = 1;
    if ( [self.chartType  isEqual: @"3"]|| [self.chartType isEqual: @"6"]){
        self.unitYStr = @"睡眠周期(时/日)";
    }
    //离床
    else if ([self.chartType  isEqual: @"4"]){
        self.unitYStr = @"离床(次/日)";
    }
    //心率，呼吸
    else if ([self.chartType  isEqual: @"1"]){
        self.unitYStr = @"心率(次/分)";
    }
    else if ([self.chartType  isEqual: @"2"]){
        self.unitYStr = @"呼吸(次/分)";
    }

    return self.level;
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //获取屏幕点击的点的坐标
    UITouch*touch=[[event allTouches]anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    int touchpoint_x = (int)(touchPoint.x);
    int touchpoint_y = (int)(touchPoint.y);
    int width_screen = (int)([UIScreen mainScreen].bounds.size.width-40);
    //去掉touchpoint_x的偏移量
    while (touchpoint_x/width_screen>0){
        touchpoint_x = touchpoint_x - width_screen;
    }
    
    
    //判断点击的地方是否在self.pointArr数组中某个点8像素内：是，显示这个点的值；否，不做任何操作
    for (PointBtn * clickBtn in self.pointArr) {
        int btn_x = (int)(clickBtn.frame.origin.x);
        int btn_y = (int)(clickBtn.frame.origin.y);
        
        
        if (abs(touchpoint_x-btn_x)<8) {
            if (abs(touchpoint_y-btn_y)<8){
                
                UIColor *defaultColor = clickBtn.backgroundColor;
                UILabel *moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(btn_x, btn_y-25,30, 20)];
                moneyLable.text = [NSString stringWithFormat:@"%@",clickBtn.valueStr];
                
                //点击圆圈后，颜色根据值变化
                if([self.chartType isEqualToString:@"1"]){
                    if ([clickBtn.valueStr intValue]<=0){
                        moneyLable.textColor = [UIColor grayColor];
                        clickBtn.backgroundColor = [UIColor grayColor];
                    }
                    else if([clickBtn.valueStr intValue]<=80){
                        moneyLable.textColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                        clickBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                    }
                    else{
                        moneyLable.textColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
                        clickBtn.backgroundColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
                    }
                }
                else if ([self.chartType isEqualToString:@"2"]){
                    if ([clickBtn.valueStr intValue]<=0){
                        moneyLable.textColor = [UIColor grayColor];
                        clickBtn.backgroundColor = [UIColor grayColor];
                    }
                    else if([clickBtn.valueStr intValue]<=40){
                        moneyLable.textColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                        clickBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green: 224/255.0 blue: 211/255.0 alpha:1.0];
                    }
                    else{
                        moneyLable.textColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
                        clickBtn.backgroundColor = [UIColor colorWithRed:254/255.0 green: 79/255.0 blue: 74/255.0 alpha:1.0];
                    }
                    
                }
                else if ([self.chartType isEqualToString:@"3"]){
                    if ([clickBtn.valueStr intValue]<=0){
                        moneyLable.textColor = [UIColor grayColor];
                        clickBtn.backgroundColor = [UIColor grayColor];
                    }
                    else {
                        moneyLable.textColor = [UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0];
                        clickBtn.backgroundColor = [UIColor colorWithRed:92/255.0 green: 130/255.0 blue: 245/255.0 alpha:1.0];
                    }
                    
                }
                
                
                [moneyLable sizeToFit];
                
                [self addSubview:moneyLable];
                
                
                //1秒后值label消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    moneyLable.alpha = 0;
                    
                    clickBtn.backgroundColor = defaultColor;
                });
                
                
                break;
            }
        }
    }
    
}

@end
