//
//  ANScreenViewController.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/5.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANScreenViewController : UIViewController
{
    UILabel *labTitle1,*labTitle2,*labTitle3,*labTitle4,*labTitle5,*labTitle6,*labTitle7,*labTitle8,*labTitle9;
    UITextField *labInfo1,*labInfo2,*labInfo3,*labInfo4,*labInfo5,*labInfo6,*labInfo7,*labInfo8,*labInfo9;
    UIButton *btnInfo1,*btnInfo2,*btnInfo3,*btnInfo4,*btnInfo5,*btnInfo6,*btnInfo7,*btnInfo8,*btnInfo9,*btnInfo10,*btnInfo11,*btnInfo12,*btnInfo13,*btnInfo14,*btnInfo15;
}

@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic,strong)UIButton *selectBtn;


@end
