//
//  ViewController.h
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property(nonatomic, readwrite) NSArray *valueAll;
//@property(nonatomic, readwrite) NSMutableArray *valueAll;
@property(nonatomic, strong) NSArray *valueXList;
@property(nonatomic, readwrite) NSArray *valueTitleNames;
//chart类型：1心率，2呼吸，3睡眠
@property(nonatomic, strong) NSString *Type;

-(void)addTrendChartView:(CGRect) chartframe;
-(void)RemoveTrendChartView;
@end

