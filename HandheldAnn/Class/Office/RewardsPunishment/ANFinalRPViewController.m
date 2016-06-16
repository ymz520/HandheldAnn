//
//  ANFinalRPViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANFinalRPViewController.h"

@interface ANFinalRPViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *man,*level,*siteName;
    UITableView *_tableView1,*_tableView2;
    NSArray *_arr1,*_arr2;
    CGFloat _txtH;
    
    NSMutableArray *_arrayData;
    NSDictionary *dicInfo;
    NSDictionary *paraDic;
    
    UIScrollView *_scrollView;
}
@end

@implementation ANFinalRPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrayData=[NSMutableArray array];
    dicInfo=[NSDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    level = [user stringForKey:@"Level"];
    siteName = [user stringForKey:@"SiteName"];
    
    [self loadData];
    [self loadFrame];
}

- (void)loadData{
    _arr1=@[@"日期",@"省区",@"大区",@"所属分拨",@"所属片区",@"网点层级",@"网店编号",@"网店名称"];
    _arr2=@[@"日均货量计划（kg）",@"总货量计划（kg）",@"上月总货量",@"上月日均货量",@"实际完成量（kg）",@"日均完成量（kg）",@"货量完成率",@"差额",@"奖罚方案",@"预计奖罚"];
    //action=getDRList Type:预奖罚8,最终奖罚9 SiteName:网点名称 Man:名称 Level：层级
    paraDic = @{@"action":@"getDRList",@"Type":@"9",@"SiteName":@"重庆观音桥", @"Level":level,@"Man":man};
    [NetWorkRequest getWithExtendUrl:RP Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
            dicInfo=_arrayData[0];
            [_tableView1 reloadData];
            [_tableView2 reloadData];
        } else {
            
        }
    }];
}

- (void)loadFrame{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50)];
    _scrollView.contentSize=CGSizeMake(0, (_arr1.count+_arr2.count-1)*25+130);
    [self.view addSubview:_scrollView];
    _tableView1=[self tableFrame:CGRectMake(10, 10, WIDTH-20, 25*_arr1.count)];
    _tableView2=[self tableFrame:CGRectMake(10, 25*_arr1.count+20, WIDTH-20, 25*_arr2.count)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView1) {
        return _arr1.count;
    } else {
        return _arr2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cargowarnCell" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    UILabel *labs=[self labFrame:CGRectMake(0, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
    labs.backgroundColor=[UIColor colorWithRed:212/255.0 green:234/255.0 blue:240/255.0 alpha:1];
    NSLog(@"dicInfo %@",dicInfo);
    if (tableView==_tableView1) {
        labs.text=[_arr1 objectAtIndex:indexPath.row];
        UILabel *labsInfo=[self labFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
        NSArray *keys=@[@"IDATE",@"REGION",@"PROVINCE",@"ALLOCATE",@"AREA",@"SITE_TYPE_NAME",@"SITE_CODE",@"SITE"];
        labsInfo.text=[dicInfo objectForKey:keys[indexPath.row]];
    } else {
        NSArray *keys=@[@"TAR_D",@"TAR_M",@"WEI_ML",@"WEI_DL",@"WEI_M",@"WEI_D",@"V_COMP",@"V_GAP",@"TIPS",@"V_VAL"];
        labs.text=[_arr2 objectAtIndex:indexPath.row];
        if (indexPath.row!=_arr2.count-2) {
            UILabel *labsInfo=[self labFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
            labsInfo.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:keys[indexPath.row]]];
            if (indexPath.row==_arr2.count-1) {
                labsInfo.textColor=[UIColor redColor];
            }
        } else {
            UILabel *plan=[[UILabel alloc] init];
            plan.numberOfLines=0;
            plan.font=[UIFont systemFontOfSize:14];
            plan.textColor=[UIColor blackColor];
            plan.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:keys[indexPath.row]]];
            _txtH=[CYTools computeLabelH:plan];
            [plan setFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, _txtH)];
            [labs setFrame:CGRectMake(0, 1, cell.frame.size.width/2, _txtH)];
            NSLog(@"---%.f",_txtH);
            [cell.contentView addSubview:plan];
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView2) {
        if (indexPath.row==_arr2.count-2) {
            _tableView2.frame=CGRectMake(10, 25*_arr1.count+20, WIDTH-20, 25*(_arr2.count-1)+_txtH);
            _scrollView.contentSize=CGSizeMake(0, (_arr1.count+_arr2.count-1)*25+_txtH+100);
            return _txtH;
        }
    }
    return 25;
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell {
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:14];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor blackColor];
    [cell.contentView addSubview:lab];
    return lab;
}
#pragma mark 创建table
- (UITableView *)tableFrame:(CGRect)frames{
    UITableView *myTableView=[[UITableView alloc] initWithFrame:frames];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cargowarnCell"];
    myTableView.scrollEnabled = NO;
    myTableView.tableFooterView=[[UIView alloc] init];
    myTableView.layer.borderColor=[UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1].CGColor;
    myTableView.layer.borderWidth=1;
    myTableView.separatorColor = [UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1];
    myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_scrollView addSubview:myTableView];
    return myTableView;
}

#pragma mark 设置端距，这里表示separator离左边和右边均0像素
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
