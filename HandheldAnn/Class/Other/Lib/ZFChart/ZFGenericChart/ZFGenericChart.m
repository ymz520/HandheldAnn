//
//  ZFGenericChart.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFColor.h"

@implementation ZFGenericChart

/**
 *  初始化变量
 */
- (void)commonInit{
    _topic = @"";
    _unit = @"";
    _isAnimated = YES;
    _isShadowForValueLabel = YES;
    _valueOnChartFontSize = 10.f;
    _xLineNameLabelToXAxisLinePadding = 20.f;
    _valueLabelPattern = kPopoverLabelPatternPopover;
    _isShowXLineValue = YES;
}

@end
