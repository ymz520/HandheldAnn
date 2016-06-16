//
//  ANDetailsDataViewController.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/11.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANDetailsDataViewController : UIViewController

/**
 图表样式chartStyle：折线图1／柱状图2
*/
@property (nonatomic,assign) NSInteger chartStyle;

/**
 维度action：日期getDate，层级getSite
*/
@property (nonatomic,assign) NSString * action;

/**
 LL：查询层级（传入值 1,2,3,4,5,6），（省区，大区，分拨，区域，网点，门店）
 */
@property (nonatomic,assign) NSInteger LL;

/**
 DM：日报1，月报2
 */
@property (nonatomic,assign) NSInteger DM;

/**
 开始时间：StartDate，结束时间：EndDate
 */
@property (nonatomic,assign) NSString * StartDate, *EndDate;

@end
