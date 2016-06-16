//
//  ANTaskListViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/12.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import "ANTaskListViewController.h"
#import "ANInterviewTableViewController.h"
#import "ANTaskDetailTableViewController.h"
#import "ANTaskListTableViewCell.h"

@interface ANTaskListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *man;
    UISegmentedControl *segmentControl;
    
    NSMutableArray *_arrayDatas,*_array1,*_array2,*_array3;
    NSMutableArray *arrayData;
    NSDictionary *dicInfo;
}
@end

@implementation ANTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"工作任务列表";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    _arrayDatas=[NSMutableArray array];
    arrayData=[NSMutableArray array];
    _array1=[NSMutableArray array];
    _array2=[NSMutableArray array];
    _array3=[NSMutableArray array];
    //action= TaskList Man:登陆名称 ALLOCATE：所属分拨  Date：当前时间
    NSDictionary *paraDic=@{@"action":@"TaskList",@"Man":man,@"ALLOCATE":@"武汉分拨中心",@"Date":@"2016-03-22"};//[CYTools getNowDate]
    [NetWorkRequest getWithExtendUrl:Interview Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]]isEqualToString:@"1"]) {
            _arrayDatas=[Object objectForKey:@"returninfo"];
            for (int i=0; i<_arrayDatas.count; i++) {
                NSString *type=[NSString stringWithFormat:@"%@",[_arrayDatas[i] objectForKey:@"TYPE"]];
                if ([type isEqualToString:@"1"]) {
                    [_array1 addObject:_arrayDatas[i]];
                    NSLog(@"arr1=%@",_array1);
                } else if ([type isEqualToString:@"2"]) {
                    [_array2 addObject:_arrayDatas[i]];
                    NSLog(@"arr2=%@",_array2);
                } else {
                    [_array3 addObject:_arrayDatas[i]];
                    NSLog(@"arr3=%@",_array3);
                }
            }
            arrayData=_array1;
            [_tableView reloadData];
        }else {
            
        }
    }];
    [self createSeg];
    [self createTable];
}

- (void)createSeg{
    NSArray *array=@[@"货量任务",@"妥投率任务",@"欠款任务"];
    segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBordered;
    //设置位置 大小
    segmentControl.frame=CGRectMake(0, 0, WIDTH, 40);
    //默认选择
    segmentControl.selectedSegmentIndex=0;
    //设置背景色
    segmentControl.tintColor=[UIColor grayColor];
    //设置监听事件
    [segmentControl addTarget:self action:@selector(changeSegmentTask:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}

- (void)changeSegmentTask:(UISegmentedControl *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
            arrayData=_array1;
            NSLog(@"arrayData=%@  arr1=%@",arrayData,_array1);
            break;
        case 1:
            arrayData=_array2;
            NSLog(@"arrayData=%@  arr2=%@",arrayData,_array2);
            break;
        case 2:
            arrayData=_array3;
            NSLog(@"arrayData=%@  arr3=%@",arrayData,_array3);
            break;
        default:
            break;
    }
    [_tableView reloadData];
}

- (void)createTable{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, HEIGHT)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    dicInfo=[arrayData objectAtIndex:indexPath.row ];
    ANTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cargowarnCell"];
    if (cell == nil) {
        cell = [[ANTaskListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cargowarnCell"];
        [cell removeFromSuperview];
    }
    cell.frame=CGRectMake(0, 0, WIDTH, 30);
    cell.title.text=[dicInfo objectForKey:@"SITE"];
    NSString *yesOrNo = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"YESORNO"]];
    if ([yesOrNo isEqualToString:@"1"]) {
        [cell.yesOrNo setTitle:@"√" forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"cell=%f title=%f  yesorno=%f",cell.frame.size.height,cell.title.frame.size.height,cell.yesOrNo.frame.size.height);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ANTaskDetailTableViewController *interviewCtl=[[ANTaskDetailTableViewController alloc] init];
//    ANInterviewTableViewController *interviewCtl=[[ANInterviewTableViewController alloc] init];
    dicInfo=[arrayData objectAtIndex:indexPath.row ];
    interviewCtl.TID=[dicInfo objectForKey:@"TID"];
    interviewCtl.ALLOCATE=[dicInfo objectForKey:@"SITE"];
    NSInteger type = [[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"TYPE"]] integerValue];
    interviewCtl.type=type;
    if (type==1) {
        interviewCtl.reason = @"货量";
    } else if (type==2){
        interviewCtl.reason = @"妥投率";
    } else {
        interviewCtl.reason = @"系统欠款";
    }
    interviewCtl.yesOrNo=[[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"YESORNO"]] integerValue];
    [self.navigationController pushViewController:interviewCtl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
