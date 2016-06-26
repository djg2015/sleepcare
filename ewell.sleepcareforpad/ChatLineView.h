//
//  ChatLine.h
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatLineView : UIView

/**
 *  所有的值
 */
//@property(nonatomic, strong) NSArray *valueArr;
@property(nonatomic, strong) NSArray *valueArr;

/**
 *  x轴
 */
@property(nonatomic, strong) NSArray *xValueArr;

/**
 *  标题数组
 */
@property(nonatomic, strong) NSArray *yearArr;

/**
 *  销售额度
 */
@property(nonatomic, copy) NSString *unitYStr;

//chart类型：1心率，2呼吸，3书面
@property(nonatomic, strong) NSString *chartType;



@end
