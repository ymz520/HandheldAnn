//
//  ANInvestmentViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/16.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import "ANInvestmentViewController.h"
#import "UIParameter.h"
#import"PNChart.h"

@interface ANInvestmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UILabel *lab1,*lab2,*lab3,*lab4;
    UILabel *_labIndicators;//当日妥投率
    UILabel *_labComplete;//当月累计妥投率
    UILabel *_labCompletion;//上月累计妥投率
    NSDictionary *_dicData;
    NSMutableArray *_arrayData;
    NSDictionary *dicInfo;
    
    UILabel *dateOrProvincesLab,*signinLab,*shouldSinginLab,*completedI;
    CGFloat txtH1;
    UILabel *_labdateOrProvinces;
    UILabel *_lablastMonthI;//
    UILabel *_labmonthI;
    UILabel *_labTTL;
    
    UITableView *_tableView;
}
@end

@implementation ANInvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dicData=[[NSDictionary alloc] init];
    _arrayData=[[NSMutableArray alloc] initWithCapacity:0];
    
    [self loadFrame];
    [self loadData];
}
- (void)loadData{
    NSDictionary *paraDic1 = @{@"action":@"getTitle", @"man":@"001",@"Level":@"0",@"StartDate":@"2016-1-2"};
    [NetWorkRequest postWithExtendUrl:VoteRate Para:paraDic1 success:^(id data) {
        _dicData=data;
        _labIndicators.text=[NSString stringWithFormat:@"%.2f％",[[_dicData objectForKey:@"ratebyday"] floatValue]*100];
        _labComplete.text=[NSString stringWithFormat:@"%.2f％",[[_dicData objectForKey:@"ratebymonth"] floatValue]*100];
        _labCompletion.text=[NSString stringWithFormat:@"%.2f％",[[_dicData objectForKey:@"ratelastmonth"] floatValue]*100];
    }];
//  时间维度：action=getDate&DM=1&man=001&Level=0&StartDate=2015-11-2&EndDate=2016-2-16
//    NSDictionary *paraDic2 = @{@"action":@"getDate",@"DM":@"1", @"man":@"001",@"Level":@"0",@"StartDate":@"2016-1-17",@"EndDate":@"2016-3-16"};
//  层级维度：action=getSite&DM=1&LL=1&man=001&Level=0&StartDate=2015-11-2&EndDate=2016-2-16
    NSDictionary *paraDic2 = @{@"action":@"getSite",@"DM":@"2",@"LL":@"1", @"man":@"001",@"Level":@"0",@"StartDate":@"2015-8",@"EndDate":@"2016-2"};
    [NetWorkRequest postWithExtendUrl:VoteRate Para:paraDic2 success:^(id data) {
        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[data objectForKey:@"returninfo"];
            [self createPNChart];
            [_tableView reloadData];
        }
    }];
}
- (void)loadFrame{
    [self createSomeLab];
    [self createtableMessage];
    [self createTable];
}

- (void)createSomeLab{
    //当日妥投率
    lab1=[self labFrame:CGRectMake(20, 10, (WIDTH-60)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab1.text=@"当日妥投率";
    _labIndicators=[self labFrame:CGRectMake(20, 30, (WIDTH-60)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
    
    //当月累计妥投率
    lab2=[self labFrame:CGRectMake(25+(WIDTH-60)/3, 10, (WIDTH-60)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab2.text=@"当月累计妥投率";
    _labComplete=[self labFrame:CGRectMake(25+(WIDTH-60)/3, 30, (WIDTH-60)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
    
    //上月累计妥投率
    lab3=[self labFrame:CGRectMake(30+(WIDTH-60)/3*2, 10, (WIDTH-60)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab3.text=@"上月累计妥投率";
    _labCompletion=[self labFrame:CGRectMake(30+(WIDTH-60)/3*2, 30, (WIDTH-60)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
}

- (void)createPNChart{
    if (_arrayData.count==0) {
        return;
    }
    //X轴数据
    NSMutableArray *dataXArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_arrayData.count; i++) {
        self.action=@"getSite";
        if ([self.action isEqualToString:@"getSite"]) {
            //截取省区
            NSString *provinces=[[_arrayData objectAtIndex:i ] objectForKey:@"SITE"];
            NSString * str = [CYTools substringArea:provinces substring:@"省区"];
            [dataXArray addObject:str];
        } else {
            //截取日期
            NSString * strtime = [NSString stringWithFormat:@"%@",[[_arrayData objectAtIndex:i ] objectForKey:@"IDATE"]];
            NSString * time = [CYTools substringDate:strtime andDM:1];
            [dataXArray addObject:time];
        }
    }
    //Y轴数据
    NSMutableArray *dataYArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_arrayData.count; i++) {
        //        NSString *rate=[[_arrayData objectAtIndex:i ] objectForKey:@"RATE"];
        NSString *rate=[NSString stringWithFormat:@"%.2f％",[[[_arrayData objectAtIndex:i] objectForKey:@"RATE"] floatValue]*100];
        [dataYArray addObject:rate];
    }
    if (self.chartStyle==2) {
#pragma mark 柱状图
        PNBarChart * barChart = [[PNBarChart alloc]initWithFrame:CGRectMake(0, 70,SCREEN_WIDTH, HEIGHT/2-20)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.yChartLabelWidth = 20.0;
        barChart.chartMarginLeft = 25.0;
        barChart.chartMarginRight = 0.0;
        barChart.chartMarginTop = 5.0;
        barChart.chartMarginBottom = 10.0;
        barChart.labelMarginTop = 0.0;
        barChart.showChartBorder = YES;
        
        //X轴数据
        [barChart setXLabels:dataXArray];
        [barChart setYValues:dataYArray];
        [barChart strokeChart];
        //加载在视图上
        [self.view addSubview:barChart];
    } else {
#pragma mark 折线图
        PNLineChart * lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 70,SCREEN_WIDTH, HEIGHT/2-20)];
        [lineChart setXLabels:dataXArray];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNHealYellow;
        data01.itemCount = lineChart.xLabels.count;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [[NSString stringWithFormat:@"%f％",[[[_arrayData objectAtIndex:index ] objectForKey:@"RATE"] floatValue]*100] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lineChart.chartData = @[data01];
        [lineChart strokeChart];
        [self.view addSubview:lineChart];
    }
}

- (void)createtableMessage{
    //线
    UIImageView *lineImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, HEIGHT/2-1, WIDTH-10, 1)];
    lineImg.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineImg];
    //日期===省区
    dateOrProvincesLab=[self labFrame:CGRectMake(0, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    dateOrProvincesLab.text=@"省区";
    //累计签收票数
    signinLab=[self labFrame:CGRectMake(labW, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    signinLab.text=@"累计签收票数";
    //累计应签收票数
    shouldSinginLab=[[UILabel alloc] init];
    shouldSinginLab.numberOfLines=0;
    shouldSinginLab.font=[UIFont systemFontOfSize:12];
    shouldSinginLab.textColor=[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1];
    shouldSinginLab.text=@"累计应签收票数";
    shouldSinginLab.textAlignment=NSTextAlignmentCenter;
    txtH1=[CYTools computeLabelH:shouldSinginLab];
    CGSize maxSize = CGSizeMake(300, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [shouldSinginLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    NSLog(@"==txt:%f  %f   %f",txtH1,textH,WIDTH/4);
    if (textH>WIDTH/4+2) {
        txtH1=17.900391*2;
        shouldSinginLab.frame=CGRectMake(labW*2, HEIGHT/2, labW, txtH1);
    }else{
        txtH1=25;
        shouldSinginLab.frame=CGRectMake(labW*2, HEIGHT/2, labW, 25);
    }
    [self.view addSubview:shouldSinginLab];
    //妥投率
    completedI=[self labFrame:CGRectMake(labW*3, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    completedI.text=@"妥投率";
}

- (void)createTable{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT/2+txtH1, WIDTH, HEIGHT/2-txtH1-64-PageBtn)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InvestmentCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InvestmentCell" forIndexPath:indexPath];
    cell.backgroundColor=indexPath.row%2==0?[UIColor colorWithRed:229/255.0 green:236/255.0 blue:245/255.0 alpha:1]:[UIColor whiteColor] ;
    for (UIView *views in cell.subviews) {
        [views removeFromSuperview];
    }
    dicInfo=[_arrayData objectAtIndex:indexPath.row ];
    //日期===省区
    _labdateOrProvinces=[self labFrame:CGRectMake(0, 0, labW, cell.frame.size.height)andCell:cell];
    _labdateOrProvinces.text=[dicInfo objectForKey:@"SITE"];
    
    //累积签收票数
    _lablastMonthI=[self labFrame:CGRectMake(labW, 0, labW, cell.frame.size.height)andCell:cell];
    _lablastMonthI.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"ACT"] ];
    //累积应签收票数
    _labmonthI=[self labFrame:CGRectMake(labW*2, 0, labW, cell.frame.size.height)andCell:cell];
    _labmonthI.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"TTL"]];
    //妥投率
    _labTTL=[self labFrame:CGRectMake(labW*3, 0, labW, cell.frame.size.height)andCell:cell];
    _labTTL.text=[NSString stringWithFormat:@"%.2f％",[[dicInfo objectForKey:@"RATE"] floatValue]*100];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andFont:(CGFloat)size andTextColor:(UIColor *)textColor  andBackgroundColor:(UIColor *)color andIndex:(int)index
{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:size];
    lab.backgroundColor=color;
    lab.textColor=textColor;
    lab.textAlignment=NSTextAlignmentCenter;
    if (index==2) {
        lab.layer.borderWidth=1;
        lab.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    }
    lab.numberOfLines=0;
    [self.view addSubview:lab];
    return lab;
}

- (UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:10];
    lab.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:lab];
    return lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
