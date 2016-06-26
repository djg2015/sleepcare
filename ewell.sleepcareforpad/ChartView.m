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
 self.backgroundColor = [UIColor colorWithRed:245/255.0 green: 245/255.0 blue: 245/255.0 alpha:1.0];
     ChatLineView *chatLineView = [[ChatLineView alloc]initWithFrame:chartframe];
    self.lineChartView = chatLineView;
    self.lineChartView.backgroundColor = [UIColor whiteColor];
 
    //    NSString *valueArr1Year = @"平均心率";
    //    [self.yearArr addObject:valueArr1Year];
    int i;
    for(i=0;i<valueTitleNames.count;i++){
        [self.yearArr addObject:[valueTitleNames objectAtIndex:i]];
    }
    self.lineChartView.yearArr = self.yearArr;
    
    self.lineChartView.chartType = self.Type;
  //   self.lineChartView.chartType = @"1";
    
    
 //   NSArray *valueArr1 = @[@"10",@"15",@"90",@"70",@"30",@"40",@"20",@"50",@"20",@"60",@"110",@"80"];
    //   self.lineChartView.valueArr = @[valueArr1];
    self.lineChartView.valueArr = valueAll;
  //  self.lineChartView.xValueArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.lineChartView.xValueArr = self.valueXList;


    
    // NSArray *valueArr2 = @[@"90000",@"70000",@"50000",@"60000",@"20000",@"50000",@"10000",@"80000",@"70000",@"20000",@"110000",@"130000"];
    // NSString *valueArr2Year = @"2014";
    // [self.yearArr addObject:valueArr2Year];
    //    self.lineChartView.yearArr = @[valueArr1,valueArr2];
    //    self.lineChartView.valueArr = @[valueArr1,valueArr2];
//    self.lineChartView.yearArr = self.yearArr;

  
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
