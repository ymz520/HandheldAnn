//
//  ANTaskDetailTableViewCell.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^myBlock)(NSString *textInfo);

@interface ANTaskDetailTableViewCell : UITableViewCell<UITextViewDelegate>
@property(strong,nonatomic)UILabel *title;
@property(strong,nonatomic)UITextView *textInfos;
//声明block
@property (strong,nonatomic)myBlock block;
@end
