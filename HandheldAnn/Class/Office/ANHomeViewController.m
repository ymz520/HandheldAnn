//
//  CYHomeViewController.m
//  HandheldAnn
//
//  Created by teacher on 15-12-30.
//  Copyright (c) 2015年 Elle.Sheena. All rights reserved.
//

#import "ANHomeViewController.h"

#import "ANDetailsDataViewController.h"
#import "ANRewardPunishmentsViewController.h"
#import "ANQualityDataViewController.h"
#import "ANRankingViewController.h"
#import "ANTaskListViewController.h"
#import "ANWarningListViewController.h"


//首页类
@interface ANHomeViewController ()
{
    NSArray *_arrayOffice;
    NSUserDefaults *user;
    NSMutableArray *_arrayData;
}

@end

@implementation ANHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"办公";
    //加载数据源
    [self loadData];
//    /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
    NSLog(@"%@",[CYTools getDocumentPath]);
}

#pragma mark 加载数据
- (void)loadData{
    _arrayOffice=@[@"经营数据",@"质量数据",@"行为数据",@"奖罚结果",@"工作任务",@"预警统计"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"officeCell"];
    NSDictionary *paraDic = @{@"action":@"getPower",@"Man":@"00001"};
    [NetWorkRequest getWithExtendUrl:Power Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
            user = [NSUserDefaults standardUserDefaults];
            [user setObject:[_arrayData[0] objectForKey:@"CODE"] forKey:@"Man"];
            [user setObject:[_arrayData[0] objectForKey:@"SITELEVEL"] forKey:@"Level"];
            [user setObject:[_arrayData[0] objectForKey:@"SITELIST"] forKey:@"SiteName"];
            [user setObject:[_arrayData[0] objectForKey:@"NAME"] forKey:@"NAME"];
            
            NSLog(@"Man=%@, Level=%@, Sitename=%@, Name=%@",[_arrayData[0] objectForKey:@"CODE"],[_arrayData[0] objectForKey:@"SITELEVEL"],[_arrayData[0] objectForKey:@"SITELIST"],[_arrayData[0] objectForKey:@"NAME"]);
            if ([[NSString stringWithFormat:@"%@",[_arrayData[0] objectForKey:@"SITELEVEL"]] isEqualToString:@"5"]) {
                _arrayOffice=@[@"经营数据",@"奖罚结果",@"质量数据",@"行为数据",@"工作任务",@"预警统计"];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayOffice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"officeCell" forIndexPath:indexPath];
    cell.textLabel.text=[_arrayOffice objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        ANDetailsDataViewController *detailCtl=[[ANDetailsDataViewController alloc] init];
        detailCtl.title=[_arrayOffice objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailCtl animated:YES];
    } else if (indexPath.row==1){
        ANQualityDataViewController *qualtityCtl=[[ANQualityDataViewController alloc] init];
        [self.navigationController pushViewController:qualtityCtl animated:YES];
    }else if (indexPath.row==2) {
        ANRankingViewController *rankingCtl=[[ANRankingViewController alloc] init];
        [self.navigationController pushViewController:rankingCtl animated:YES];
    }else if (indexPath.row==3) {
        ANRewardPunishmentsViewController *rewardCtl=[[ANRewardPunishmentsViewController alloc] init];
        [self.navigationController pushViewController:rewardCtl animated:YES];
    } else if (indexPath.row==4) {
        ANTaskListViewController *worktaskCtl=[[ANTaskListViewController alloc] init];
        [self.navigationController pushViewController:worktaskCtl animated:YES];
    } else if (indexPath.row==5) {
        ANWarningListViewController *warnCtl=[[ANWarningListViewController alloc] init];
        [self.navigationController pushViewController:warnCtl animated:YES];
    }
}

@end
