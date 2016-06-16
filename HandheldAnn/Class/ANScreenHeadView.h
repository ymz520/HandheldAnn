//
//  ANScreenHeadView.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/18.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANScreenHeadView : UIView
- (IBAction)clickTime:(UIButton *)sender;

- (IBAction)clickHierarchy:(UIButton *)sender;

- (IBAction)clickBar:(UIButton *)sender;

- (IBAction)clickLine:(UIButton *)sender;

- (IBAction)clickDaily:(UIButton *)sender;

- (IBAction)clickMonthReport:(UIButton *)sender;

+(instancetype)getMineHeadView;

@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnbar;
@property (weak, nonatomic) IBOutlet UIButton *btnLine;
@property (weak, nonatomic) IBOutlet UIButton *btnHierarchy;
@property (weak, nonatomic) IBOutlet UIButton *btnDaily;
@property (weak, nonatomic) IBOutlet UIButton *btnMonthlyReport;
@end
