//
//  ViewController.m
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//

#import "ChartView.h"
#import "ChatLineView.h"

@interface ChartView ()

@property(nonatomic,strong) NSMutableArray *yearArr;
@property (nonatomic, weak) UIView *trendChartView;
@property (nonatomic, weak) ChatLineView *lineChartView;


-(void)addTrendChartView:(CGRect) chartframe;

@end

@implementation ChartView


@synthesize valueAll;

@synthesize valueTitleNames;

-(NSMutableArray *)yearArr{
    if(!_yearArr){
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}


/**
 *  走势图
 */
-(void)addTrendChartView:(CGRect) chartframe{
 self.backgroundColor = [UIColor whiteColor];
     ChatLineView *chatLineView = [[ChatLineView alloc]initWithFrame:chartframe];
    self.lineChartView = chatLineView;
    self.lineChartView.backgroundColor = [UIColor whiteColor];
   
 
    int i;
    for(i=0;i<valueTitleNames.count;i++){
        [self.yearArr addObject:[valueTitleNames objectAtIndex:i]];
    }
    self.lineChartView.yearArr = self.yearArr;
    
    self.lineChartView.chartType = self.Type;

 
    self.lineChartView.valueArr = valueAll;
  
    self.lineChartView.xValueArr = self.valueXList;



  
    [self addSubview:self.lineChartView];
}

-(void)RemoveTrendChartView{
    [self.lineChartView removeFromSuperview];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.lineChartView touchesBegan:touches withEvent:event];
    
}

@end
