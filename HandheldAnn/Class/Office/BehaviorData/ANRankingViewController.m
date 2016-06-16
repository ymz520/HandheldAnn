//
//  ANRankingViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/12.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import "ANRankingViewController.h"
#import "ZFChart.h"
#import "ANUserInfo.h"

@interface ANRankingViewController ()<UITableViewDataSource,UITableViewDelegate,ZFGenericChartDataSource, ZFBarChartDelegate>
{
    ANUserInfo *_userInfo;
    UILabel *ranking,*maxRanking,*minRanking;
    UILabel *_labRanking;//当月总和综合排名
    UILabel *_labmaxRanking;//最高排名
    UILabel *_labminRanking;//最低排名
    
    NSMutableArray *_arrayData;
    NSDictionary *paraDic,*_dicdata;
    
    UILabel *monthLab,*provincesLab,*lastMonthIndicatorsLab,*monthIndicatorsLab;
    UILabel *_labmonth;//
    UILabel *_labprovinces;//
    UILabel *_lablastMonthI;//
    UILabel *_labmonthI;
    UITableView *_tableView;
}
@end

@implementation ANRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    self.title=@"综合管控排名";
    _userInfo = [[ANUserInfo alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _userInfo.Name = [user stringForKey:@"NAME"];
    _userInfo.Sitename = [user stringForKey:@"SiteName"];
    _userInfo.Level = [user stringForKey:@"Level"];
    NSLog(@"name=%@  siteName=%@ level=%@",_userInfo.Name,_userInfo.Sitename,_userInfo.Level);
    _arrayData = [NSMutableArray array];
    _dicdata = [NSDictionary dictionary];
    
    [self loadData];
    
    [self createFrame];
}
#pragma mark 加载数据源
- (void)loadData{
    ///SysEcharts/Ashx/AllControls.ashx?urlType=app&siteName=江苏省区&Man=严帅帅&level=1&sDate=2016-02
    paraDic = @{@"urlType":@"app",@"sDate":@"2016-02",@"siteName":_userInfo.Sitename,@"Man":_userInfo.Name,@"level":_userInfo.Level};
    [NetWorkRequest getWithExtendUrl:Controls Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
            [_tableView reloadData];
        } else {
            
        }
    }];
}
#pragma mark 加载界面
- (void)createFrame{
    [self createLab];
    [self showBarChart];
    [self createtableMessage];
    [self createTableData];
}
//创建lab
- (void)createLab{
    //最高排名
    maxRanking=[self labFrame:self.view.bounds andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labmaxRanking=[self labFrame:self.view.bounds andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labmaxRanking.layer.borderWidth=1;
    _labmaxRanking.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    
    //最低排名
    minRanking=[self labFrame:self.view.bounds andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labminRanking=[self labFrame:self.view.bounds andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labminRanking.layer.borderWidth=1;
    _labminRanking.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
#pragma mark 判断是否为总部领导
    if ([_userInfo.Sitename isEqualToString:@"总部"]) {//总部领导
        maxRanking.frame=CGRectMake(25, 10, (WIDTH-60)/2, 20);
        maxRanking.text=@"排名最高区域";
        _labmaxRanking.frame=CGRectMake(25, 30, (WIDTH-60)/2, 30);
        
        minRanking.frame=CGRectMake((WIDTH-60)/2+35, 10, (WIDTH-60)/2, 20);
        minRanking.text=@"排名最低区域";
        _labminRanking.frame=CGRectMake((WIDTH-60)/2+35, 30, (WIDTH-60)/2, 30);
    } else {//普通用户
        //当月综合排名
        ranking=[self labFrame:CGRectMake(20, 10, (WIDTH-50)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
        ranking.text=@"当月综合排名";
        _labRanking=[self labFrame:CGRectMake(20, 30, (WIDTH-50)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
        _labRanking.layer.borderWidth=1;
        _labRanking.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
        maxRanking.frame=CGRectMake((WIDTH-50)/3+25, 10, (WIDTH-50)/3, 20);
        maxRanking.text=@"排名最高";
        _labmaxRanking.frame=CGRectMake((WIDTH-50)/3+25, 30, (WIDTH-50)/3, 30);
        minRanking.frame=CGRectMake((WIDTH-50)/3*2+30, 10, (WIDTH-50)/3, 20);
        minRanking.text=@"排名最低";
        _labminRanking.frame=CGRectMake((WIDTH-50)/3*2+30, 30, (WIDTH-50)/3, 30);
    }
}
#pragma mark 柱状图
- (void)showBarChart{
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 220)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.unit = @"%";
    [self.view addSubview:barChart];
    [barChart strokePath];
}
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"23", @"56", @"30", @"83"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"货量",@"Mini小包",@"妥投率",@"系统欠款"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFMagenta];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 100;
}
//bar宽度(若不设置，默认为25.f)
- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
    return 40;
}
//组与组之间的间距(若不设置,默认为20.f)
- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
    return 20;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

- (void)createtableMessage{
    //线
    UIImageView *lineImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 349, WIDTH-10, 1)];
    lineImg.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineImg];
    //日期
    monthLab=[self labFrame:CGRectMake(0, 350, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    monthLab.text=@"日期";
    //省区
    provincesLab=[self labFrame:CGRectMake(labW, 350, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    provincesLab.text=@"省区";
    //上月排名
    lastMonthIndicatorsLab=[self labFrame:CGRectMake(labW*2, 350, WIDTH/5, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    lastMonthIndicatorsLab.text=@"上月排名";
    //本月排名
    monthIndicatorsLab=[self labFrame:CGRectMake(labW*3, 350, WIDTH/5, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    monthIndicatorsLab.text=@"本月排名";
}
#pragma mark 加载地区＝＝数据
- (void)createTableData{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 380, WIDTH, HEIGHT-380-64)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"regionCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
    for (UIView *views in cell.subviews) {
        [views removeFromSuperview];
    }
    cell.backgroundColor=indexPath.row%2==0?[UIColor colorWithRed:229/255.0 green:236/255.0 blue:245/255.0 alpha:1]:[UIColor whiteColor] ;
    _dicdata = [_arrayData objectAtIndex:indexPath.row];
    //日期
    _labmonth=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, labW, cell.frame.size.height)];
    _labmonth.text=[NSString stringWithFormat:@"%@-%@",[_dicdata objectForKey:@"IYEAR"],[_dicdata objectForKey:@"IMONTH"]];
    _labmonth.font=[UIFont systemFontOfSize:10];
    _labmonth.textAlignment=NSTextAlignmentCenter;;
    [cell addSubview:_labmonth];
    //省区
    _labprovinces=[[UILabel alloc] initWithFrame:CGRectMake(labW, 0, labW, cell.frame.size.height)];
    _labprovinces.text=[NSString stringWithFormat:@"%@",[_dicdata objectForKey:@"FIELDNAME"]];
    _labprovinces.font=[UIFont systemFontOfSize:10];
    _labprovinces.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:_labprovinces];
    //上月
    _lablastMonthI=[[UILabel alloc] initWithFrame:CGRectMake(labW*2, 0, labW, cell.frame.size.height)];
    _lablastMonthI.text=[NSString stringWithFormat:@"%@",[_dicdata objectForKey:@"SCORE_L"]];
    _lablastMonthI.font=[UIFont systemFontOfSize:10];
    _lablastMonthI.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:_lablastMonthI];
    //本月
    _labmonthI=[[UILabel alloc] initWithFrame:CGRectMake(labW*3, 0, labW, cell.frame.size.height)];
    _labmonthI.text=[NSString stringWithFormat:@"%@",[_dicdata objectForKey:@"SCORE_T"]];
    _labmonthI.font=[UIFont systemFontOfSize:10];
    _labmonthI.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:_labmonthI];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

-(UILabel *)labFrame:(CGRect)frames andFont:(CGFloat)size andTextColor:(UIColor *)textColor  andBackgroundColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:size];
    lab.backgroundColor=color;
    lab.textColor=textColor;
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    return lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
