//
//  ANScreenHeadView.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/18.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANScreenHeadView.h"

@implementation ANScreenHeadView

-(void)awakeFromNib{
    [self setPropertyBtn:_btnTime];
    [self setPropertyBtn:_btnbar];
    [self setPropertyBtn:_btnHierarchy];
    [self setPropertyBtn:_btnLine];
    [self setPropertyBtn:_btnDaily];
    [self setPropertyBtn:_btnMonthlyReport];
    _btnTime.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnLine.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnDaily.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
}
- (void)setPropertyBtn:(UIButton *)btn {
    btn.layer.borderColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=5.0;
}

- (IBAction)clickTime:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnHierarchy.backgroundColor=[UIColor whiteColor];
}

- (IBAction)clickHierarchy:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnTime.backgroundColor=[UIColor whiteColor];
}

- (IBAction)clickBar:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnLine.backgroundColor=[UIColor whiteColor];
    
}

- (IBAction)clickLine:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnbar.backgroundColor=[UIColor whiteColor];
}

- (IBAction)clickDaily:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnMonthlyReport.backgroundColor=[UIColor whiteColor];
}

- (IBAction)clickMonthReport:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    _btnDaily.backgroundColor=[UIColor whiteColor];
}

+(instancetype)getMineHeadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"ANScreenHeadView" owner:nil options:nil]lastObject];
}

@end
