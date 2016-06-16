//
//  ANWarnHeadView.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/31.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANWarnHeadView.h"

@implementation ANWarnHeadView

+(instancetype)getMineHeadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"ANWarnHeadView" owner:nil options:nil]lastObject];
}
@end
