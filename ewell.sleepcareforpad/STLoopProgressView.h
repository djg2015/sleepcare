//
//  STLoopProgressView.h
//  STLoopProgressView
//
//  Created by TangJR on 6/29/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, STClockWiseType) {
    STClockWiseYes,
    STClockWiseNo
};

@interface STLoopProgressView : UIView

@property (assign, nonatomic) CGFloat persentage;

@property (assign, nonatomic) UIColor *startColor;// 起始颜色
@property (assign, nonatomic) UIColor *centerColor;// 中间过渡颜色
@property (assign, nonatomic) UIColor *endColor;// 结束颜色
@property (assign, nonatomic) UIColor *defaultbackgroundColor;// 空环背景颜色

@property (assign, nonatomic) CGFloat lineWidth; // 线宽

- (void)addCircleView:(CGRect)frame withdefaultcolor:(UIColor *)defaultColor withstartcolor:(UIColor*)startColor withcentercolor:(UIColor*)centerColor withendcolor:(UIColor*)endColor withlinewidth:(CGFloat)linewidth;

@end