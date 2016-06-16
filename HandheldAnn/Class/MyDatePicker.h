//
//  MyDatePicker.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol MyDatePickerDelegate <NSObject>

- (void)sendDate:(NSString *)strDate;

@end

@interface MyDatePicker : UIView
@property (nonatomic,assign)id<MyDatePickerDelegate> delegate;
@property (nonatomic,strong)UIDatePicker *dp;
@property (nonatomic,strong) NSString*  selDateStr;
@end
