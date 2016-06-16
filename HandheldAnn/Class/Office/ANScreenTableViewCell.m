//
//  ANScreenTableViewCell.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/25.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANScreenTableViewCell.h"

@implementation ANScreenTableViewCell

- (void)awakeFromNib {
    _screenText.font=[UIFont systemFontOfSize:14.0];
    _titleLab.font=[UIFont systemFontOfSize:14.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
