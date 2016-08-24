//
//  sleepcircle.h
//  segmentcircle
//
//  Created by Qinyuan Liu on 8/18/16.
//  Copyright (c) 2016 Qinyuan Liu. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface sleepcircle : UIView

-(void)drawcircle;

@property(assign,nonatomic)CGFloat lineWidth;
@property(assign,nonatomic)CGFloat lightsleepvalue;
@property(strong,nonatomic)UIColor *lightsleeplineColor;

@property(assign,nonatomic)CGFloat deepsleepvalue;
@property(strong,nonatomic)UIColor *deepsleeplineColor;

@property(assign,nonatomic)CGFloat awakevalue;
@property(strong,nonatomic)UIColor *awakelineColor;

@end