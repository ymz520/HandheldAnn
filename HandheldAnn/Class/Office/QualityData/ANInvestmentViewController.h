//
//  ANInvestmentViewController.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/16.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANInvestmentViewController : UIViewController
/*
 图表样式chartStyle：折线图1／柱状图2
 */
@property (nonatomic,assign) NSInteger chartStyle;

/*维度action：日期getDate，层级getSite*/
@property (nonatomic,copy) NSString *action;
@end
