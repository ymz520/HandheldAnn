//
//  ANWarningListViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/13.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import "ANWarningListViewController.h"
#import "ANCargoWarningViewController.h"
#import "ANWarningTableViewCell.h"
#import "ANWarnHeadView.h"

@interface ANWarningListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *man,*level,*siteName;
    
    NSMutableArray *_arrayData;
    NSDictionary *dicInfo;
}
@end

@implementation ANWarningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预警列表";
    self.view.backgroundColor=[UIColor whiteColor];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    level = [user stringForKey:@"Level"];
    siteName = [user stringForKey:@"SiteName"];
    
    _arrayData=[[NSMutableArray alloc] initWithCapacity:0];
    //action=getListDone SiteName：网点名称  Man：名称   Level：层级
    NSDictionary *paraDic=@{@"action":@"getListDone",@"Man":man,@"Level":level,@"SiteName":@"太原小店"};
    [NetWorkRequest getWithExtendUrl:RP Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
        }
        [_tableView reloadData];
    }];
    
    [self createTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTable{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"ANWarningTableViewCell" bundle:nil] forCellReuseIdentifier:@"warningCell"];
    [self.view addSubview:_tableView];
    ANWarnHeadView *headView=[ANWarnHeadView getMineHeadView];
    headView.backgroundColor=[UIColor colorWithRed:119/255.0 green:122/255.0 blue:110/255.0 alpha:1];
    _tableView.tableHeaderView=headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ANWarningTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"warningCell" forIndexPath:indexPath];
    dicInfo=[_arrayData objectAtIndex:indexPath.row ];
    cell.warnTime.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"IDATE"]] ;
    cell.siteName.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"SITE"]];
    cell.siteCode.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"SITE_CODE"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ANCargoWarningViewController *dataWarnCtl=[[ANCargoWarningViewController alloc] init];
    dataWarnCtl.StartDate=[_arrayData[0] objectForKey:@"IDATE"];
    [self.navigationController pushViewController:dataWarnCtl animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
