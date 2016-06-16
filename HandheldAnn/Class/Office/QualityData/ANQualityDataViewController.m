//
//  ANQualityDataViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/16.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import "ANQualityDataViewController.h"
#import "NinaPagerView.h"

@interface ANQualityDataViewController ()
{
    NSArray *_titleArray;
}
@end


@implementation ANQualityDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _titleArray=@[@"妥投率报表",@"系统欠款报表"];
    /**< 每个标题下对应的控制器，只需将您创建的控制器类名加入下列数组即可(注意:数量应与上方的titles数量保持一致，若少于titles数量，下方会打印您缺少相应的控制器，同时默认设置的最大控制器数量为10=。=)  。
                                       **/
    NSArray *vcsArray = @[
                          @"ANInvestmentViewController",
                          @"ANBalanceViewController",
                          ];
    NSArray *colorArray = @[
                            [UIColor brownColor], /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor grayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            [UIColor clearColor], /**< 下划线颜色 Underline Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    
    
    self.navigationController.navigationBar.translucent = NO;
    /**< 创建ninaPagerView，控制器第一次是根据所划的位置进行相应的添加的，后面再滑动到相应位置时不再重新添加，如果想刷新数据，可以在相应的控制器里加入刷新功能，低耦合。在创建控制器时，设置的frame为FUll_CONTENT_HEIGHT，即全屏高减去导航栏高度再减去Tabbar的高度，如果这个高度不是您想要的，您可以去UIParameter.h中进行设置XD。
     **/
    NinaPagerView *ninaPagerView =[[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:_titleArray WithVCs:vcsArray WithColorArrays:colorArray];

        [self.view addSubview:ninaPagerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
