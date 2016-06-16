//
//  ZFConst.h
//  ZFChartView
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ZFColor.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define ZFSin(a) sin(a / 180.f * M_PI)

/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define ZFCos(a) cos(a / 180.f * M_PI)

/**
 *  角度求三角函数tan值
 *  @param a 角度
 */
#define ZFTan(a) tan(a / 180.f * M_PI)

/**
 *  弧度转角度
 *  @param radian 弧度
 */
#define ZFAngle(radian) (radian / M_PI * 180.f)

/**
 *  角度转弧度
 *  @param angle 角度
 */
#define ZFRadian(angle) (angle / 180.f * M_PI)


/**
 *  坐标轴起点x值
 */
extern CGFloat const ZFAxisLineStartXPos;

/**
 *  y轴label tag值
 */
extern NSInteger const YLineValueLabelTag;

/**
 *  x轴item宽度
 */
extern CGFloat const XLineItemWidth;

/**
 *  x轴组与组之间间距
 */
extern CGFloat const XLinePaddingForGroupsLength;

/**
 *  x轴bar与bar之间间距
 */
extern CGFloat const XLinePaddingForBarLength;

/**
 *  坐标y轴最大上限值到箭头的间隔距离
 */
extern CGFloat const ZFAxisLineGapFromYLineMaxValueToArrow;

/**
 *  y轴分段线长度
 */
extern CGFloat const YLineSectionLength;

/**
 *  y轴分段线高度
 */
extern CGFloat const YLineSectionHeight;

/**
 *  开始系数(上方)
 */
extern CGFloat const StartRatio;

/**
 *  结束系数(下方)
 */
extern CGFloat const EndRatio;

/**
 *  线状图圆的半径
 */
extern CGFloat const ZFLineChartCircleRadius;

/**
 *  饼图整圆样式半径系数
 */
extern CGFloat const ZFPieChartCircleRatio;

/**
 *  饼图圆环样式半径系数
 */
extern CGFloat const ZFPieChartCirqueRatio;

/**
 *  饼图百分比label Tag值
 */
extern NSInteger const PieChartPercentLabelTag;

/**
 *  饼图详情背景容器 Tag值
 */
extern NSInteger const PieChartDetailBackgroundTag;

/**
 *  导航栏高度
 */
extern CGFloat const NAVIGATIONBAR_HEIGHT;

/**
 *  tabBar高度
 */
extern CGFloat const TABBAR_HEIGHT;



/**
 *  线状图, 波浪图上的value的位置
 */
typedef enum{
    kChartValuePositionDefalut = 0,//上下分布
    kChartValuePositionOnTop = 1,//上方
    kChartValuePositionOnBelow = 2//下方
}kChartValuePosition;


@interface ZFConst : NSObject

@end
