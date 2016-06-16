//
//  MyDatePicker.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//


#import "MyDatePicker.h"

@implementation MyDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //创建一个日期选择器
        _dp = [[UIDatePicker alloc] initWithFrame:self.bounds];
        
        //设置模式
        _dp.datePickerMode = UIDatePickerModeDate;
        
        //设置本地化(中国)
        _dp.locale = [NSLocale localeWithLocaleIdentifier:@"zh-ch"];
        
        //添加事件
        [_dp addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_dp];
    }
    return self;
}

- (void)dateChange:(UIDatePicker *)dp{
    
    //格式化日期
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *strDate = [df stringFromDate:dp.date];
    //选中的日期传走
    self.selDateStr=[NSString stringWithFormat:@"%@",self.selDateStr];
    self.selDateStr=strDate;
    [self.delegate sendDate:strDate];
}

@end
