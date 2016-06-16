//
//  ANTaskListTableViewCell.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/1.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANTaskListTableViewCell.h"

@implementation ANTaskListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(20, 0, self.frame.size.width-60, 30);
        title.font=[UIFont systemFontOfSize:14];
        self.title = title;
        [self.contentView addSubview:self.title];
        
        UIButton *btnImg=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 5, 20, 20)];
        btnImg.layer.borderWidth=1.0;
        btnImg.layer.borderColor=[UIColor blackColor].CGColor;
        self.yesOrNo = btnImg;
        [self.contentView addSubview:self.yesOrNo];
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
