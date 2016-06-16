//
//  ANWarnDetailTableViewCell.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/31.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANWarnDetailTableViewCell.h"

@implementation ANWarnDetailTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, self.frame.size.width/2,self.frame.size.height);
        title.backgroundColor = [UIColor colorWithRed:212/255.0 green:234/255.0 blue:240/255.0 alpha:1];
        title.font=[UIFont systemFontOfSize:14];
        title.textAlignment=NSTextAlignmentCenter;
        self.title = title;
        [self.contentView addSubview:self.title];
        
        UILabel *info= [[UILabel alloc] init];
        info.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2,self.frame.size.height);
        info.font=[UIFont systemFontOfSize:14];
        info.textAlignment=NSTextAlignmentCenter;
        self.info = info;
        [self.contentView addSubview:self.info];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
