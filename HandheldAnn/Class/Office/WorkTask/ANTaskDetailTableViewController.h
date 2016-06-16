//
//  ANTaskDetailTableViewController.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANTaskDetailTableViewCell.h"

@interface ANTaskDetailTableViewController : UITableViewController{
    
    
    
    NSString* month;
    NSString* day;
    NSString* hour;
    NSString* minute;
    NSString* year;
}
@property(nonatomic,strong)NSString *TID,*ALLOCATE,*reason;
@property(nonatomic,assign)NSInteger type,yesOrNo;

@property (strong,nonatomic) ANTaskDetailTableViewCell *cell;
@property (strong,nonatomic) NSMutableArray *arrayData;
@end
