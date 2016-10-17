//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)


+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-265);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(90);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
