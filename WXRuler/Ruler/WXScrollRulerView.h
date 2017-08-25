//
//  WXScrollRulerView.h
//
//  Created by wxj on 2017/8/24.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXScrollRulerView : UIView

//是否显示刻度值 (默认显示)
@property (nonatomic, assign) BOOL  showRulerNumber;

//_|_|_最小刻度值(默认为 1.0)
@property (nonatomic, assign) float minRulerValue;

//刻度颜色
@property (nonatomic, strong) UIColor *rulerColor;

//刻度值颜色
@property (nonatomic, strong) UIColor *rulerValueColor;

//拖动显示数值回掉
@property (nonatomic, copy)   void(^currentValueChanged)(float value);

/**
 @param frame 刻度尺坐标位置
 @param minValue 最小值
 @param maxValue 最大值
 @param initialValue 初始值
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(float )minValue maxValue:(float)maxValue initialValue:(float) initialValue;

@end
