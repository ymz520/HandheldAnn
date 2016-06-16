//
//  ANDataWarnViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/13.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANCargoWarningViewController.h"
#import "ANWarnDetailTableViewCell.h"

@interface ANCargoWarningViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *man,*level,*siteName;
    
    NSMutableArray *_arrayData;
    UITableView *_tableView1,*_tableView2;
    NSArray *_arr1,*_arr2;
    
}
@end

@implementation ANCargoWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"货量预警";
    self.navigationController.navigationBar.translucent=NO;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    level = [user stringForKey:@"Level"];
    siteName = [user stringForKey:@"SiteName"];
    
    [self loadData];
    [self loadFrame];
}

- (void)loadData{
    _arr1=@[@"日期",@"省区",@"大区",@"所属分拨",@"所属片区",@"网点层级",@"网店编号",@"网店名称"];
    _arr2=@[@"日均货量计划（kg）",@"总货量计划(kg)",@"上月总货量",@"实际完成量（kg）",@"日均完成量（kg）",@"货量完成率(月)",@"货量完成率(日)"];
    //查询明细 action=getDetail SiteName:网点名称 Man:名称 Level:层级 StartDate:查询日期
    NSDictionary *paraDic=@{@"action":@"getDetail",@"Man":man,@"Level":level,@"SiteName":@"太原小店",@"StartDate":self.StartDate};
    [NetWorkRequest getWithExtendUrl:RP Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
        }
        [_tableView1 reloadData];
        [_tableView2 reloadData];
    }];
}

- (void)loadFrame{
    UILabel *warnLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    warnLab.text=@"货量数据预警";
    warnLab.font=[UIFont systemFontOfSize:14];
    warnLab.textAlignment=NSTextAlignmentLeft;
    warnLab.textColor=[UIColor colorWithRed:43/255.0 green:76/255.0 blue:127/255.0 alpha:1];
    warnLab.backgroundColor=[UIColor colorWithRed:212/255.0 green:234/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:warnLab];
    
    [self createTable];
}

- (void)createTable{
    _tableView1=[self tableFrame:CGRectMake(10, 40, WIDTH-20, 25*_arr1.count)];
    _tableView2=[self tableFrame:CGRectMake(10, 25*_arr1.count+50, WIDTH-20, 25*_arr2.count)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView1) {
        return _arr1.count;
    } else {
        return _arr2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ANWarnDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cargowarnCell"];
    if (cell == nil) {
        cell = [[ANWarnDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cargowarnCell"];
        [cell removeFromSuperview];
    }
    if (cell.title.frame.size.height>25 || cell.info.frame.size.height>25) {
        cell.title.frame=CGRectMake(0, 0, cell.frame.size.width/2, cell.frame.size.height);
        cell.info.frame=CGRectMake(cell.frame.size.width/2, 0, cell.frame.size.width/2, cell.frame.size.height);
    }
    if (tableView==_tableView1) {
        NSArray *array1=@[@"IDATE",@"REGION",@"PROVINCE",@"ALLOCATE",@"AREA",@"DICT_NAME",@"SITE_CODE",@"SITE"];
        cell.title.text = [_arr1 objectAtIndex:indexPath.row];
        cell.info.text = [NSString stringWithFormat:@"%@",[_arrayData[0] objectForKey:array1[indexPath.row]]];
    } else {
        NSArray *array2=@[@"WEIGHT_D",@"WEIGHT_M",@"WEIGHT_L",@"TAR_M",@"TAR_D",@"PER_M",@"PER_D"];
        cell.title.text=[_arr2 objectAtIndex:indexPath.row];
        if (indexPath.row==_arr2.count-1 || indexPath.row==_arr2.count-2) {
            cell.info.text = [NSString stringWithFormat:@"%.2f％",[[_arrayData[0] objectForKey:array2[indexPath.row]] floatValue]*100];
            cell.info.textColor=[UIColor redColor];
        } else {
            cell.info.text = [NSString stringWithFormat:@"%@",[_arrayData[0] objectForKey:array2[indexPath.row]]];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSLog(@"cell=%f   lab=%f",cell.frame.size.height,cell.title.frame.size.height);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

//创建table
- (UITableView *)tableFrame:(CGRect)frames{
    UITableView *myTableView=[[UITableView alloc] initWithFrame:frames];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    myTableView.scrollEnabled = NO;
    myTableView.tableFooterView=[[UIView alloc] init];
    myTableView.layer.borderColor=[UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1].CGColor;
    myTableView.layer.borderWidth=1;
    myTableView.separatorColor = [UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1];
    myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:myTableView];
    return myTableView;
}

//设置端距，这里表示separator离左边和右边均0像素
-(void)viewDidLayoutSubviews {
    if ([_tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView1 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView1 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView2 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView2 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
