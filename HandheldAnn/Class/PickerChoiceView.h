//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPickerDelegate <NSObject>

@optional;
- (void)PickerSelectorIndixString:(NSString *)str;

@end

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    StartTimeArray,
    EndTimeArray,
    ShowArray,
    WangDianArray,
    ProvinceArray,
    RegionalArray,
    Distribution,
    AreaArray,
    BranchesArray,
    StoresArray
};

@interface PickerChoiceView : UIView
{
    
    NSMutableArray *_arrayData;
    NSDictionary *paraDic;
    NSMutableArray *dataArray;
}

@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic, strong) NSArray *customArr;

@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic,strong)NSString *selectStr;

@property (nonatomic,strong)NSString *superiorStr1,*superiorStr2,*superiorStr3,*superiorStr4,*superiorStr5,*superiorStr6;

@property (nonatomic,assign)id<TFPickerDelegate>delegate;

@end
