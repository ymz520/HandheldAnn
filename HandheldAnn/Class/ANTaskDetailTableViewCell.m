//
//  ANTaskDetailTableViewCell.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANTaskDetailTableViewCell.h"

@implementation ANTaskDetailTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(2, 0, self.frame.size.width/3, 40);
        title.font=[UIFont systemFontOfSize:14];
        self.title = title;
        [self.contentView addSubview:self.title];
        
        UITextView *textInfo=[[UITextView alloc] initWithFrame:CGRectMake(self.frame.size.width/3, 5, self.frame.size.width/3*2-10, 30)];
        textInfo.font=[UIFont systemFontOfSize:14];
        textInfo.textAlignment=NSTextAlignmentLeft;
        textInfo.layer.borderColor=[UIColor grayColor].CGColor;
        textInfo.layer.borderWidth=2;
        textInfo.delegate=self;
        self.textInfos = textInfo;
        [self.contentView addSubview:self.textInfos];
    }
    return self;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.block)
    {
        self.block(self.textInfos.text);
    }
    NSLog(@"===%@",self.textInfos.text);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
