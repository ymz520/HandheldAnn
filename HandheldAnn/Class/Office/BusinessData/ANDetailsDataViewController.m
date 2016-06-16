//
//  ANDetailsDataViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/11.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANDetailsDataViewController.h"
//#import "ANScreeningTableViewController.h"
//#import "FoldViewController.h"
//#import "ANScreTableViewController.h"
#import "ANScreenViewController.h"
#import "PNChart.h"

#import "ANUserInfo.h"

@interface ANDetailsDataViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ANUserInfo *_userInfo;
    UISegmentedControl *segmentControl;
    UILabel *lab1,*lab2,*lab3,*lab4;
    UILabel *_labIndicators;//当月指标
    UILabel *_labComplete;//累计完成
    UILabel *_labCompletion;//完成率
    UILabel *_labGrowth;//日均环比增长
    
    NSMutableArray *_arrayData;
    NSArray *_arrayTitle;
    NSDictionary *dicInfo;
    
    UILabel *dateOrProLab,*lastMonthIndicatorsLab,*monthIndicatorsLab;
    UILabel *_labdateOrPro;//
    UILabel *_lablastMonthI;//
    UILabel *_labmonthI;
    CGFloat labW1;
    
    UITableView *_tableView;
}
@end

@implementation ANDetailsDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _arrayData=[NSMutableArray array];
    dicInfo=[NSDictionary dictionary];
    self.navigationItem.title=self.title;
    
    labW1=WIDTH/3;
    [self loadFrame];
}
#pragma mark 加载界面
- (void)loadFrame{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleBordered target:self action:@selector(setting)];
    [self createSeg];
    [self createSomeLab];
    [self createtableMessage];
    [self labText:0];
    
    [self loadTableData];
}
- (void)setting{
//    ANScreTableViewController *screenCtl=[[ANScreTableViewController alloc] init];
    ANScreenViewController *screenCtl=[[ANScreenViewController alloc] init];
    [self.navigationController pushViewController:screenCtl animated:YES];
}
- (void)createSeg{
    NSArray *array=@[@"货量日报",@"收入日报",@"mini小包日报"];
    segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBordered;
    //设置位置 大小
    segmentControl.frame=CGRectMake(0, 0, WIDTH, 40);
    //默认选择
    segmentControl.selectedSegmentIndex=0;
    //设置背景色
    segmentControl.tintColor=[UIColor grayColor];
    //设置监听事件
    [segmentControl addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}
- (void)createSomeLab{
    //当月指标、票数
    lab1=[self labFrame:CGRectMake(20, 40+10, (WIDTH-60)/2, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labIndicators=[self labFrame:CGRectMake(20, 40+30, (WIDTH-60)/2, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labIndicators.layer.borderWidth=1;
    _labIndicators.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    
    //累计完成、票数占比
    lab2=[self labFrame:CGRectMake(40+(WIDTH-60)/2, 40+10, (WIDTH-60)/2, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labComplete=[self labFrame:CGRectMake(40+(WIDTH-60)/2, 40+30, (WIDTH-60)/2, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labComplete.layer.borderWidth=1;
    _labComplete.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    
    //完成率、重量
    lab3=[self labFrame:CGRectMake(20, 40+70, (WIDTH-60)/2, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labCompletion=[self labFrame:CGRectMake(20, 40+90, (WIDTH-60)/2, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labCompletion.layer.borderWidth=1;
    _labCompletion.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    
    //日均环比增长、重量占比
    lab4=[self labFrame:CGRectMake(40+(WIDTH-60)/2, 40+70, (WIDTH-60)/2, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1]];
    _labGrowth=[self labFrame:CGRectMake(40+(WIDTH-60)/2, 40+90, (WIDTH-60)/2, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor]];
    _labGrowth.layer.borderWidth=1;
    _labGrowth.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
}
#pragma mark seg点击事件
-(void)changeSegment:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0://货量日报
            
            [self labText:0];
            
            break;
        case 1://收入日报
            
            [self labText:1];
            break;
        case 2://mini小包日报
            [self labText:2];
            break;
        default:
            break;
    }
}
- (void)labText:(int)index{
    if (index==2) {
        lab1.text=@"票数";
        lab2.text=@"票数占比";
        lab3.text=@"重量(吨)";
        lab4.text=@"重量占比";
        dateOrProLab.text=@"省份";
        lastMonthIndicatorsLab.text=@"重量";
        monthIndicatorsLab.text=@"票数";
        [self loadData:2];
    } else {
        lab1.text=@"当月指标";
        lab2.text=@"累计完成";
        lab3.text=@"完成率";
        lab4.text=@"日均环比增长";
        lastMonthIndicatorsLab.text=@"货量";
        monthIndicatorsLab.text=@"本月指标";
        if (index==0) {
            dateOrProLab.text=@"日期";
            [self loadData:0];
        }else{
            dateOrProLab.text=@"日期";
            [self loadData:1];
        }
    }
}

- (void)loadData:(NSInteger)index {
    //  标题：http://58.246.172.54:8085/app/App_Cargo.ashx?action=getTitle&man=001&Level=0&StartDate=2016-1-2
    //  时间维度：http://58.246.172.54:8085/app/App_Mini.ashx?action=getDate&DM=1&man=001&Level=0&StartDate=2015-11-2&EndDate=2016-2-16
    //  层级维度：http://58.246.172.54:8085/app/App_Mini.ashx?action=getSite&DM=1&LL=6&man=001&Level=0&StartDate=2015-11-2&EndDate=2016-2-16
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *man = [user stringForKey:@"Man"];/*_userInfo.Man*/
    NSString *level = [user stringForKey:@"Level"];
    NSString *siteName = [user stringForKey:@"SiteName"];
    NSDictionary *paraTitleDic;
    NSDictionary *paraDic;
    NSString *url,*title1,*title2,*title3,*title4;
    switch (index) {
        case 0:
        {
            paraTitleDic = @{@"action":@"getTitle", @"Man":man,@"Level":level,@"StartDate":@"2016-1-2"};
            url=Cargo;
            title1=@"WEIGHT";
            title2=@"TARGET";
            title3=@"RATE";
            title4=@"avggrowth";
            
            self.DM=1;
            self.LL=1;
            self.chartStyle=1;
            self.StartDate=@"2016-2-17";
            self.EndDate=@"2016-3-16";
            self.action=@"getDate";
            paraDic = @{@"action":self.action,@"DM":@(self.DM), @"man":@"05449",@"Level":@"0",@"StartDate":self.StartDate,@"EndDate":self.EndDate};
            [NetWorkRequest getWithExtendUrl:Cargo Para:paraTitleDic Complete:^(BOOL succeed, id Object) {
                if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
                    _arrayTitle=[Object objectForKey:@"returninfo"];
                    _labIndicators.text=[NSString stringWithFormat:@"%@",[_arrayTitle[0] objectForKey:@"WEIGHT"]];//指标
                    _labComplete.text=[NSString stringWithFormat:@"%@",[_arrayTitle[0] objectForKey:@"TARGET"]];//完成
                    _labCompletion.text=[NSString stringWithFormat:@"%.2f％",[[_arrayTitle[0] objectForKey:@"RATE"] floatValue]*100];//完成率
                    _labGrowth.text=[NSString stringWithFormat:@"%.2f％",[[Object objectForKey:@"avggrowth"] floatValue]*100];//增长率
                }
            }];
        }
            break;
        case 1:
        {
            _labCompletion.text=@"12%";
            _labComplete.text=@"300";
            _labGrowth.text=@"22%";
            _labIndicators.text=@"102";
        }
            break;
        case 2:
        {
            url=Mini;
            title1=@"BILL";
            self.DM=1;
            self.LL=1;
            self.chartStyle=1;
            self.StartDate=@"2016-1-17";
            self.EndDate=@"2016-2-16";
            self.action=@"getDate";
            paraDic = @{@"action":self.action,@"DM":@(self.DM),@"LL":@(self.LL), @"man":man,@"Level":level,@"StartDate":self.StartDate,@"EndDate":self.EndDate};
            paraTitleDic=@{@"action":@"getTitle",@"SiteName":siteName, @"man":man,@"Level":level,@"StartDate":[CYTools getYesterdayDate]};
            [NetWorkRequest getWithExtendUrl:Mini Para:paraTitleDic Complete:^(BOOL succeed, id Object) {
                if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
                    _arrayTitle=[Object objectForKey:@"returninfo"];
                    _labIndicators.text=[NSString stringWithFormat:@"%@",[_arrayTitle[0] objectForKey:@"BILL"]];//票数
                    if ([_labIndicators.text isEqualToString:@"<null>"]) {
                        _labIndicators.text=@"0";
                    }
                    _labComplete.text=[NSString stringWithFormat:@"%.2f％",[[_arrayTitle[0] objectForKey:@"BILLRATE"] floatValue]*100];//票数占比
                    _labCompletion.text=[NSString stringWithFormat:@"%@",[_arrayTitle[0] objectForKey:@"WEIGHT"]];//重量
                    if ([_labCompletion.text isEqualToString:@"<null>"]) {
                        _labCompletion.text=@"0";
                    }
                    _labGrowth.text=[NSString stringWithFormat:@"%.2f％",[[_arrayTitle[0] objectForKey:@"WEIGHTRATE"] floatValue]*100];//重量占比
                }
            }];
        }
            break;
        default:
            break;
    }
    [NetWorkRequest getWithExtendUrl:url Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]]isEqualToString:@"1"]) {
            _arrayData=[Object objectForKey:@"returninfo"];
            NSLog(@"arr:%@==%li",_arrayData,_arrayData.count);
            [self createPNChart];
            [_tableView reloadData];
        }
    }];
}

#pragma mark 图表
- (void)createPNChart{
    
    if (_arrayData.count>0) {
        //X轴数据
        NSMutableArray *dataXArray=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<_arrayData.count; i++) {
            if ([self.action isEqualToString:@"getSite"]) {
                //截取省区
                NSString *provinces=[[_arrayData objectAtIndex:i ] objectForKey:@"SITE"];
                NSString * area = [CYTools substringArea:provinces substring:@"省区"];
                [dataXArray addObject:area];
            } else {
                //截取时间
                NSString * strtime = [NSString stringWithFormat:@"%@",[[_arrayData objectAtIndex:i ] objectForKey:@"IDATE"]];
                NSString * time = [CYTools substringDate:strtime andDM:1];
                [dataXArray addObject:time];
            }
        }
        //Y轴数据
        NSMutableArray *dataYArray=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<_arrayData.count; i++) {
            CGFloat weight = [[NSString stringWithFormat:@"%.2f％",[[[_arrayData objectAtIndex:i ] objectForKey:@"WEIGHT"] floatValue]] floatValue];
            [dataYArray addObject:@(weight)];
        }
        if (self.chartStyle==2) {//柱状图
            PNBarChart * barChart = [[PNBarChart alloc]initWithFrame:CGRectMake(10, 40+120, WIDTH-5, 200)];
            [barChart setXLabels:dataXArray];//X轴数据
            [barChart setYValues:dataYArray];//Y轴数据
            [barChart strokeChart];
            [self.view addSubview:barChart];//加载在视图上
        } else {//折线图
            PNLineChart * lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(10, 40+120, WIDTH-5, 200)];
            lineChart.legendStyle = PNLegendItemStyleSerial;
            lineChart.legendFontColor = [UIColor redColor];
            lineChart.legendFont = [UIFont systemFontOfSize:12.0];
            UIView *legend = [lineChart getLegendWithMaxWidth:WIDTH];
            [legend setFrame:CGRectMake(100, 300, legend.frame.size.width, legend.frame.size.height)];
            [self.view addSubview:legend];
            
            [lineChart setXLabels:dataXArray];
            PNLineChartData *data01 = [PNLineChartData new];
            data01.color = PNYellow;
            data01.itemCount = lineChart.xLabels.count;
            data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [[NSString stringWithFormat:@"%.2f％",[[[_arrayData objectAtIndex:index ] objectForKey:@"WEIGHT"] floatValue]] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            lineChart.chartData = @[data01];
            [lineChart strokeChart];
            [self.view addSubview:lineChart];
        }
    }
}

- (void)createtableMessage{
    //线
    UIImageView *lineImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 360, WIDTH-10, 1)];
    lineImg.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineImg];
    //日期＝＝省区
    dateOrProLab=[self labFrame:CGRectMake(0, 361, labW1, 30) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    //上月指标
    lastMonthIndicatorsLab=[self labFrame:CGRectMake(labW1, 361, labW1, 30) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
    //本月指标
    monthIndicatorsLab=[self labFrame:CGRectMake(labW1*2, 361, labW1, 30) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor]];
}
#pragma mark 创建table
- (void)loadTableData{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 390, WIDTH, HEIGHT-390-64)];
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
    cell.backgroundColor=indexPath.row%2==0?[UIColor colorWithRed:229/255.0 green:236/255.0 blue:245/255.0 alpha:1]:[UIColor whiteColor] ;
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    dicInfo=[_arrayData objectAtIndex:indexPath.row ];
    //日期＝＝省区
    _labdateOrPro=[self labFrame:CGRectMake(0, 0, labW1, cell.frame.size.height) andCell:cell];
    if ([self.action isEqualToString:@"getSite"]) {
        _labdateOrPro.text = [dicInfo objectForKey:@"SITE"];
    } else {
        _labdateOrPro.text = [dicInfo objectForKey:@"IDATE"];
    }
    //重量
    _lablastMonthI=[self labFrame:CGRectMake(labW1, 0, labW1, cell.frame.size.height) andCell:cell];
    _lablastMonthI.text = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"WEIGHT"]];
    //票数
    _labmonthI=[self labFrame:CGRectMake(labW1*2, 0, labW1, cell.frame.size.height) andCell:cell];
    _labmonthI.text = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"BILL"]];
    return cell;
}

//创建lab
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
- (UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:10];
    lab.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:lab];
    return lab;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
